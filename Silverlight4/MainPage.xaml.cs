using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;
using System.Xml;
using Ibt.Ortc.Mobile.Api;
using Ibt.Ortc.Mobile.Extensibility;

namespace Ibt.Ortc.Demo.SilverlightApplication
{
    public partial class MainPage : UserControl
    {
        #region Attributes

        private IOrtcClient _ortcClient;
        private Dictionary<string, string> _configs;

        #endregion

        #region Constructor

        public MainPage()
        {
            InitializeComponent();
            InitializeConfig();
            InitializeFields();
            InitializeClient();
        }

        #endregion

        #region Methods

        private void InitializeFields()
        {
            txtPostUrl.Text = _configs["PostAuthenticationServer"];
            chkPostIsCluster.IsChecked = bool.Parse(_configs["PostAuthenticationIsCluster"]);
            txtPostAuthToken.Text = _configs["PostAuthenticationToken"];
            chkPostIsPrivate.IsChecked = bool.Parse(_configs["PostAuthenticationTokenIsPrivate"]);
            txtPostAppKey.Text = _configs["PostAuthenticationApplicationKey"];
            txtPostPrivateKey.Text = _configs["PostAuthenticationPrivateKey"];
            txtPostTtl.Text = _configs["PostAuthenticationTtl"];
            txtPostChannels.Text = _configs["PostAuthenticationChannels"].Replace("\\r", Environment.NewLine);
            txtPostPermissions.Text = _configs["PostAuthenticationPermissions"].Replace("\\r", Environment.NewLine);

            txtConnectionUrl.Text = _configs["ClientServer"];
            chkConnectionIsCluster.IsChecked = bool.Parse(_configs["ClientIsCluster"]);
            txtConnectionAuthToken.Text = _configs["ClientToken"];
            txtConnectionAppKey.Text = _configs["ClientApplicationKey"];
            txtConnectionConnMeta.Text = _configs["ClientConnectionMetadata"];
            txtConnectionChannel.Text = _configs["ClientChannel"];
            txtConnectionMessage.Text = _configs["ClientMessage"];
            txtConnectionChannelIsSubscribed.Text = _configs["ClientChannel"];
        }

        private void InitializeClient()
        {
            var ortc = new Ibt.Ortc.Mobile.Api.Ortc();

            var factory = ortc.LoadOrtcFactory("IbtRealTimeSJ");

            if (factory != null)
            {
                _ortcClient = factory.CreateClient();

                _ortcClient.OnConnected += (s) =>
                {
                    IOrtcClient ortcClient = (IOrtcClient)s;

                    Log(String.Format("Connected to: {0}", ortcClient.Url));
                    Log(String.Format("Connection metadata: {0}", ortcClient.ConnectionMetadata));
                    Log(String.Format("Session ID: {0}", ortcClient.SessionId));
                };

                _ortcClient.OnDisconnected += (s) =>
                {
                    Log("Disconnected");
                };

                _ortcClient.OnException += (s, error) =>
                {
                    Log(String.Format("Error: {0}", error.Message));
                };

                _ortcClient.OnReconnecting += (s) =>
                {
                    IOrtcClient ortcClient = (IOrtcClient)s;

                    // Update URL with user entered text
                    if ((bool)chkConnectionIsCluster.IsChecked)
                    {
                        Log(String.Format("Reconnecting to: {0}", ortcClient.ClusterUrl));
                    }
                    else
                    {
                        Log(String.Format("Reconnecting to: {0}", ortcClient.Url));
                    }
                };

                _ortcClient.OnReconnected += (s) =>
                {
                    IOrtcClient ortcClient = (IOrtcClient)s;

                    Log(String.Format("Reconnected to {0}", ortcClient.Url));
                };

                _ortcClient.OnSubscribed += (s, channel) =>
                {
                    Log(String.Format("Subscribed to: {0}", channel));
                };

                _ortcClient.OnUnsubscribed += (s, channel) =>
                {
                    Log(String.Format("Unsubscribed from: {0}", channel));
                };
            }
            else {
                Log("Factory is null");
            }
        }

        private void Log(string text)
        {
            DateTime dt = DateTime.Now;
            string datePatt = @"HH:mm:ss";

            txtLog.Text += ((txtLog.Text != "" ? Environment.NewLine : "") + String.Format("{0}: {1}", dt.ToString(datePatt), text));
        }

        public Dictionary<string, string> InitializeConfig()
        {
            XmlReader reader = XmlReader.Create("app.config");

            _configs = new Dictionary<string, string>();

            reader.MoveToContent();

            while (reader.Read())
            {
                if (reader.NodeType == XmlNodeType.Element && reader.Name == "add")
                {
                    if (reader.HasAttributes)
                    {
                        string keyToGet = reader.GetAttribute("key");

                        if (!string.IsNullOrEmpty(keyToGet))
                        {
                            string valueToGet = reader.GetAttribute("value");

                            _configs.Add(keyToGet, valueToGet);
                        }
                    }
                }
            }

            return _configs;
        }

        #endregion

        #region Events

        private void btnConnect_Click(object sender, RoutedEventArgs e)
        {
            // Update URL with user entered text
            if ((bool)chkConnectionIsCluster.IsChecked)
            {
                _ortcClient.ClusterUrl = txtConnectionUrl.Text;
            }
            else
            {
                _ortcClient.Url = txtConnectionUrl.Text;
            }

            Log(String.Format("Connecting to: {0}...", txtConnectionUrl.Text));

            _ortcClient.ConnectionMetadata = txtConnectionConnMeta.Text;
            _ortcClient.AnnouncementSubChannel = txtConnectionAnnouncementSubChannel.Text;

            _ortcClient.Connect(txtConnectionAppKey.Text, txtConnectionAuthToken.Text);
        }

        private void btnSubscribe_Click(object sender, RoutedEventArgs e)
        {
            Log(String.Format("Subscribing to: {0}...", txtConnectionChannel.Text));

            _ortcClient.Subscribe(txtConnectionChannel.Text, true, (s, channel, message) =>
            {
                Log(String.Format("Message on channel {0}: {1}", channel, message));
            });
        }

        private void btnSend_Click(object sender, RoutedEventArgs e)
        {
            Log("Send:" + txtConnectionMessage.Text + " to " + txtConnectionChannel.Text);

            _ortcClient.Send(txtConnectionChannel.Text, txtConnectionMessage.Text);
        }

        private void btnUnsubscribe_Click(object sender, RoutedEventArgs e)
        {
            Log(String.Format("Unsubscribing from: {0}...", txtConnectionChannel.Text));

            _ortcClient.Unsubscribe(txtConnectionChannel.Text);
        }

        private void btnDisconnect_Click(object sender, RoutedEventArgs e)
        {
            Log("Disconnecting...");

            _ortcClient.Disconnect();
        }

        private void btnPostAuthentication_Click(object sender, RoutedEventArgs e)
        {
            Log("Posting permissions...");

            Dictionary<string, List<ChannelPermissions>> channelPermissions = new Dictionary<string, List<ChannelPermissions>>();

            // Get permissions from TextBox
            string[] permissionChannel = Regex.Split(txtPostChannels.Text.Replace("\n", ""), "\r");
            string[] permission = Regex.Split(txtPostPermissions.Text.Replace("\n", ""), "\r");

            int i = 0;
            foreach (string perm in permissionChannel)
            {
                if (!channelPermissions.ContainsKey(perm))
                {
                    try
                    {
                        var permissionsList = new List<ChannelPermissions>();

                        for (var z = 0; z < permission[i].Length; z++)
                        {
                            permissionsList.Add(permission[i][z] == 'r' ?
                                ChannelPermissions.Read : permission[i][z] == 'p' ?
                                    ChannelPermissions.Presence : ChannelPermissions.Write);
                        }

                        channelPermissions.Add(perm, permissionsList);

                    }
                    catch (Exception)
                    {
                        channelPermissions.Add(perm, new List<ChannelPermissions> { ChannelPermissions.Read });
                    }
                }

                i++;
            }

            Ibt.Ortc.Mobile.Api.Ortc.SaveAuthenticationAsync(txtPostUrl.Text, ((bool)chkPostIsCluster.IsChecked) ? true : false, txtPostAuthToken.Text, (bool)chkPostIsPrivate.IsChecked, txtPostAppKey.Text, int.Parse(txtPostTtl.Text.ToString()), txtPostPrivateKey.Text, channelPermissions, (error, authenticated) =>
            {
                if (error != null)
                {
                    Log("Unable to post permissions: " + (error.InnerException != null ? error.InnerException.Message : error.Message));
                }
                else
                {
                    Log("Permissions posted");
                }
            });
        }

        private void btnClearLog_Click(object sender, RoutedEventArgs e)
        {
            txtLog.Text = String.Empty;
        }

        private void btnIsSubscribed_Click(object sender, RoutedEventArgs e)
        {
            bool? result = _ortcClient.IsSubscribed(txtConnectionChannelIsSubscribed.Text);

            if (result == true)
            {
                Log("YES");
            }
            else if (result == false)
            {
                Log("NO");
            }
        }

        #endregion

        private void btnPresence_Click(object sender, RoutedEventArgs e)
        {
            Ibt.Ortc.Mobile.Api.Ortc.Presence(
                txtConnectionUrl.Text,
                chkConnectionIsCluster.IsChecked.Value,
                txtConnectionAppKey.Text,
                txtConnectionAuthToken.Text,
                txtConnectionChannel.Text,
                (error, presence) => {
                    if (error != null)
                    {
                        Log(String.Format("Error: {0}", error.Message));
                    }
                    else
                    {
                        Log(String.Format("Subscriptions {0}", presence.Subscriptions));

                        if (presence.Metadata != null)
                        {
                            foreach (var metadata in presence.Metadata)
                            {
                                Log(metadata.Key + " - " + metadata.Value);
                            }
                        }
                    }
                });
        }

        private void btnEnablePresence_Click(object sender, RoutedEventArgs e)
        {
            Ibt.Ortc.Mobile.Api.Ortc.EnablePresence(
                txtConnectionUrl.Text,
                chkConnectionIsCluster.IsChecked.Value,
                txtConnectionAppKey.Text,
                txtPostPrivateKey.Text,
                txtConnectionChannel.Text,
                true,
                (error, result) =>
                {
                    if (error != null)
                    {
                        Log(String.Format("Error: {0}", error.Message));
                    }
                    else
                    {
                        Log(result);
                    }
                });
        }

        private void btnDisablePresence_Click(object sender, RoutedEventArgs e)
        {
            Ibt.Ortc.Mobile.Api.Ortc.DisablePresence(
               txtConnectionUrl.Text,
               chkConnectionIsCluster.IsChecked.Value,
               txtConnectionAppKey.Text,
               txtPostPrivateKey.Text,
               txtConnectionChannel.Text,
               (error, result) =>
               {
                   if (error != null)
                   {
                       Log(String.Format("Error: {0}", error.Message));
                   }
                   else
                   {
                       Log(result);
                   }
               });
        }

    }
}
