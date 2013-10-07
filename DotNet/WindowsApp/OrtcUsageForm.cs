using System;
using System.Collections.Generic;
using System.Configuration;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using Ibt.Ortc.Api;
using Ibt.Ortc.Api.Extensibility;
using System.Diagnostics;

namespace Ibt.Ortc.Demo.WindowsApp
{
    public partial class OrtcUsageForm : Form
    {
        long messageCounter;

        #region Constants

        private const int BUGILION_MAX = 2000;

        private const string POST_AUTH_TOKEN_PARAM_PATTERN = "AT=([^&]*)";
        private const string POST_AUTH_TOKEN_IS_PRIVATE_PARAM_PATTERN = "&PVT=([^&]*)";
        private const string POST_APP_KEY_PARAM_PATTERN = "&AK=([^&]*)";
        private const string POST_TTL_PARAM_PATTERN = "&TTL=([^&]*)";
        private const string POST_PRIVATE_KEY_PARAM_PATTERN = "&PK=([^&]*)";

        #endregion

        #region Attributes

        private OrtcClient _ortc;

        #endregion

        #region Constructor

        public OrtcUsageForm()
        {
            InitializeComponent();
        }

        #endregion

        #region Form Load

        private void OrtcUsageForm_Load(object sender, EventArgs e)
        {           
            
            timer1.Start();

            PopulateFields();

            btnSendBugilion.Text = String.Format("Send {0} messages", BUGILION_MAX);

            StringBuilder postParams = new StringBuilder();

            int ttl;
            if (!int.TryParse(txtPostAuthTTL.Text, out ttl))
            {
                ttl = 61;
            }

            Dictionary<string, ChannelPermissions> channelPermissions = new Dictionary<string, ChannelPermissions>();

            int i = 0;

            // Get permissions
            string[] channels = Regex.Split(txtPostAuthChannel.Text, "\r\n");
            string[] permissions = Regex.Split(txtPostAuthPermission.Text, "\r\n");

            foreach (string channel in channels)
            {
                if (!channelPermissions.ContainsKey(channel))
                {
                    try
                    {
                        channelPermissions.Add(channel, permissions[i] == "r" ? ChannelPermissions.Read : ChannelPermissions.Write);

                    }
                    catch (Exception)
                    {
                        channelPermissions.Add(channel, ChannelPermissions.Read);
                    }
                }
                i++;
            }

            postParams.Append(String.Format("AT={0}&PVT={1}&AK={2}&TTL={3}&PK={4}", txtPostAuthToken.Text, 0, txtPostAuthAppKey.Text, ttl, txtPostAuthPrivateKey.Text));
            postParams.Append(String.Format("&TP={0}", channelPermissions.Count));

            foreach (var item in channelPermissions)
            {
                postParams.Append(String.Format("&{0}={1}", item.Key, item.Value == ChannelPermissions.Read ? "r" : "w"));
            }

            txtPostParams.Text = postParams.ToString();

            LoadFactory();
        }

        #endregion

        #region Methods

        private void PopulateFields()
        {
            if (ConfigurationManager.AppSettings["PostAuthenticationServer"] != null)
            {
                txtPostAuthUrl.Text = ConfigurationManager.AppSettings["PostAuthenticationServer"];
            }

            if (ConfigurationManager.AppSettings["PostAuthenticationIsCluster"] != null)
            {
                chkPostAuthIsCluster.Checked = Boolean.Parse(ConfigurationManager.AppSettings["PostAuthenticationIsCluster"]);
            }

            if (ConfigurationManager.AppSettings["PostAuthenticationToken"] != null)
            {
                txtPostAuthToken.Text = ConfigurationManager.AppSettings["PostAuthenticationToken"];
            }

            if (ConfigurationManager.AppSettings["PostAuthenticationTokenIsPrivate"] != null)
            {
                chkPostAuthTokenIsPrivate.Checked = Boolean.Parse(ConfigurationManager.AppSettings["PostAuthenticationTokenIsPrivate"]);
            }

            if (ConfigurationManager.AppSettings["PostAuthenticationApplicationKey"] != null)
            {
                txtPostAuthAppKey.Text = ConfigurationManager.AppSettings["PostAuthenticationApplicationKey"];
            }

            if (ConfigurationManager.AppSettings["PostAuthenticationPrivateKey"] != null)
            {
                txtPostAuthPrivateKey.Text = ConfigurationManager.AppSettings["PostAuthenticationPrivateKey"];
            }

            if (ConfigurationManager.AppSettings["PostAuthenticationTtl"] != null)
            {
                txtPostAuthTTL.Text = ConfigurationManager.AppSettings["PostAuthenticationTtl"];
            }

            if (ConfigurationManager.AppSettings["PostAuthenticationChannels"] != null)
            {
                txtPostAuthChannel.Text = ConfigurationManager.AppSettings["PostAuthenticationChannels"];
            }

            if (ConfigurationManager.AppSettings["PostAuthenticationPermissions"] != null)
            {
                txtPostAuthPermission.Text = ConfigurationManager.AppSettings["PostAuthenticationPermissions"];
            }

            if (ConfigurationManager.AppSettings["ClientServer"] != null)
            {
                txtClientUrl.Text = ConfigurationManager.AppSettings["ClientServer"];
            }

            if (ConfigurationManager.AppSettings["ClientIsCluster"] != null)
            {
                chkClientIsCluster.Checked = Boolean.Parse(ConfigurationManager.AppSettings["ClientIsCluster"]);
            }

            if (ConfigurationManager.AppSettings["ClientToken"] != null)
            {
                txtClientToken.Text = ConfigurationManager.AppSettings["ClientToken"];
            }

            if (ConfigurationManager.AppSettings["ClientApplicationKey"] != null)
            {
                txtClientAppKey.Text = ConfigurationManager.AppSettings["ClientApplicationKey"];
            }

            if (ConfigurationManager.AppSettings["ClientConnectionMetadata"] != null)
            {
                txtClientConnectionMetadata.Text = ConfigurationManager.AppSettings["ClientConnectionMetadata"];
            }

            if (ConfigurationManager.AppSettings["ClientChannel"] != null)
            {
                txtClientChannel.Text = ConfigurationManager.AppSettings["ClientChannel"];
                txtClientChannelSubscribed.Text = ConfigurationManager.AppSettings["ClientChannel"];
            }

            if (ConfigurationManager.AppSettings["ClientMessage"] != null)
            {
                txtClientMessage.Text = ConfigurationManager.AppSettings["ClientMessage"];
            }
        }

        private void LoadFactory()
        {
            try
            {
                // Load factory
                var api = new Api.Ortc("Plugins");
                IOrtcFactory factory = api.LoadOrtcFactory("IbtRealTimeSJ");

                if (factory != null)
                {
                    // Construct object
                    _ortc = factory.CreateClient();

                    if (_ortc != null)
                    {
                        _ortc.Id = "dot_net_client";
                        //_ortc.ConnectionTimeout = 10000;

                        // Handlers
                        _ortc.OnConnected += new OnConnectedDelegate(ortc_OnConnected);
                        _ortc.OnDisconnected += new OnDisconnectedDelegate(ortc_OnDisconnected);
                        _ortc.OnReconnecting += new OnReconnectingDelegate(ortc_OnReconnecting);
                        _ortc.OnReconnected += new OnReconnectedDelegate(ortc_OnReconnected);
                        _ortc.OnSubscribed += new OnSubscribedDelegate(ortc_OnSubscribed);
                        _ortc.OnUnsubscribed += new OnUnsubscribedDelegate(ortc_OnUnsubscribed);
                        _ortc.OnException += new OnExceptionDelegate(ortc_OnException);
                    }
                }
                else
                {
                    Log("Factory is null");
                }
            }
            catch (Exception ex)
            {
                Log(ex.Message);
            }

            if (_ortc == null)
            {
                Log("ORTC object is null");
            }
        }

        private void Log(string text)
        {
            DateTime dt = DateTime.Now;
            string datePatt = @"HH:mm:ss";

            txtLog.AppendText((txtLog.Text != "" ? Environment.NewLine : "") + String.Format("{0}: {1}", dt.ToString(datePatt), text));
        }

        private void DrawCircle()
        {
            double precision = 0.06;
            double radious = 70;
            double x, y;

            for (double i = 0; i < 2*Math.PI; i += precision)
            {
                x = Math.Cos(i) * radious;
                y = Math.Sin(i) * radious;

                int ix = 150 + Convert.ToInt32(x);
                int iy = 150 + Convert.ToInt32(y);

                string message = "{ \"left\": \"" + ix + "\", \"top\": \"" + iy + "\" }";

                Log("Send:" + message + " to " + txtClientChannel.Text);

                _ortc.Send(txtClientChannel.Text, message);
            }
        }

        private void SendBugilion()
        {
            for (int i = 1; i <= BUGILION_MAX; i++)
            {
                Log("Send:" + i + " to " + txtClientChannel.Text);

                _ortc.Send(txtClientChannel.Text, i.ToString());
            }
        }

        #endregion

        #region Events

        private void OnMessageCallback(object sender, string channel, string message)
        {            
            switch (channel)
            {
                case "ortcClientConnected":
                    Log(String.Format("A client connected: {0}", message));
                    break;
                case "ortcClientDisconnected":
                    Log(String.Format("A client disconnected: {0}", message));
                    break;
                case "ortcClientSubscribed":
                    Log(String.Format("A client subscribed: {0}", message));
                    break;
                case "ortcClientUnsubscribed":
                    Log(String.Format("A client unsubscribed: {0}", message));
                    break;
                default:
                    //Log(String.Format("Received at {0}: {1}", channel, message.Substring(message.Length - 5)));
                    Log(String.Format("Received at {0}: {1}", channel, message));
                    break;
            }
        }

        private void btnPostPermissions_Click(object sender, EventArgs e)
        {
            try
            {
                Log("Posting permissions...");

                Dictionary<string, List<ChannelPermissions>> channelPermissions = new Dictionary<string, List<ChannelPermissions>>();

                // Get permissions from TextBox
                string[] permissionChannel = txtPostAuthChannel.Text.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);
                string[] permission = txtPostAuthPermission.Text.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);

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

                if (Ortc.Api.Ortc.SaveAuthentication(txtPostAuthUrl.Text, chkPostAuthIsCluster.Checked, txtPostAuthToken.Text, chkPostAuthTokenIsPrivate.Checked, txtPostAuthAppKey.Text, Int32.Parse(txtPostAuthTTL.Text), txtPostAuthPrivateKey.Text, channelPermissions))
                {
                    Log("Permissions posted");
                }
                else
                {
                    Log("Unable to post permissions");
                }
            }
            catch (Exception ex)
            {
                if (ex.InnerException != null)
                {
                    Log(ex.InnerException.Message);
                }
                else
                {
                    Log(ex.Message);
                }
            }
        }

        #region ORTC Handlers

        private void ortc_OnConnected(object sender)
        {
            Log(String.Format("Connected to: {0}", _ortc.Url));
            Log(String.Format("Connection metadata: {0}", _ortc.ConnectionMetadata));
            Log(String.Format("Session ID: {0}", _ortc.SessionId));

            btnDrawCircle.Enabled = true;
            btnSendBugilion.Enabled = true;
        }

        private void ortc_OnDisconnected(object sender)
        {
            Log("Disconnected");

            btnDrawCircle.Enabled = false;
            btnSendBugilion.Enabled = false;
        }

        private void ortc_OnReconnecting(object sender)
        {
            // Update URL with user entered text
            if (chkClientIsCluster.Checked)
            {
                Log(String.Format("Reconnecting to: {0}", _ortc.ClusterUrl));
            }
            else
            {
                Log(String.Format("Reconnecting to: {0}", _ortc.Url));
            }
        }

        private void ortc_OnReconnected(object sender)
        {
            Log(String.Format("Reconnected to: {0}", _ortc.Url));

            btnDrawCircle.Enabled = true;
            btnSendBugilion.Enabled = true;
        }

        private void ortc_OnSubscribed(object sender, string channel)
        {
            Log(String.Format("Subscribed to: {0}", channel));
        }

        private void ortc_OnUnsubscribed(object sender, string channel)
        {
            Log(String.Format("Unsubscribed from: {0}", channel));
        }

        private void ortc_OnException(object sender, Exception ex)
        {
            Log(String.Format("Error: {0}", ex.Message));
        }

        #endregion

        #region Buttons Click

        private void btnDisconnect_Click(object sender, EventArgs e)
        {
            Log("Disconnecting...");

            _ortc.Disconnect();
        }

        private void btnConnect_Click(object sender, EventArgs e)
        {
            // Update URL with user entered text
            if (chkClientIsCluster.Checked)
            {
                _ortc.ClusterUrl = txtClientUrl.Text;
            }
            else
            {
                _ortc.Url = txtClientUrl.Text;
            }

            Log(String.Format("Connecting to: {0}...", txtClientUrl.Text));

            _ortc.ConnectionMetadata = txtClientConnectionMetadata.Text;
            _ortc.AnnouncementSubChannel = txtClientAnnouncementSubChannel.Text;

            _ortc.Connect(txtClientAppKey.Text, txtClientToken.Text);
        }

        private void btnPresence_Click(object sender, EventArgs e)
        {
            if (_ortc.IsConnected)
            {
                _ortc.Presence(txtClientChannel.Text, (error, result) =>
                {
                    if (error != null)
                    {
                        Log(String.Format("Error: {0}", error.Message));
                    }
                    else
                    {
                        if (result == null)
                        {
                            Log(String.Format("Subscriptions {0}", 0));
                        }
                        else
                        {
                            Log(String.Format("Subscriptions {0}", result.Subscriptions));

                            if (result.Metadata != null)
                            {
                                foreach (var metadata in result.Metadata)
                                {
                                    Log(metadata.Key + " - " + metadata.Value);
                                }
                            }
                        }
                    }
                });
            }
            else
            {
                var isCluster = chkClientIsCluster.Checked;
                var url = txtClientUrl.Text;

                Ortc.Api.Ortc.Presence(url, isCluster, txtClientAppKey.Text, txtClientToken.Text, txtClientChannel.Text, (error, result) =>
                {
                    if (error != null)
                    {
                        Log(String.Format("Error: {0}", error.Message));
                    }
                    else
                    {
                        if (result == null)
                        {
                            Log(String.Format("Subscriptions {0}", 0));
                        }
                        else
                        {
                            Log(String.Format("Subscriptions {0}", result.Subscriptions));

                            if (result.Metadata != null)
                            {
                                foreach (var metadata in result.Metadata)
                                {
                                    Log(metadata.Key + " - " + metadata.Value);
                                }
                            }
                        }                        
                    }
                });
            }
        }

        private void btnSubscribe_Click(object sender, EventArgs e)
        {
            Log(String.Format("Subscribing to: {0}...", txtClientChannel.Text));

            _ortc.Subscribe(txtClientChannel.Text, true, OnMessageCallback);
        }

        private void btnUnsubscribe_Click(object sender, EventArgs e)
        {
            Log(String.Format("Unsubscribing from: {0}...", txtClientChannel.Text));

            _ortc.Unsubscribe(txtClientChannel.Text);
        }

        private void btnSend_Click(object sender, EventArgs e)
        {
            // Parallel Task: Send
            Task.Factory.StartNew(() =>
            {
                Log("Send:" + txtClientMessage.Text + " to " + txtClientChannel.Text);

                _ortc.Send(txtClientChannel.Text, txtClientMessage.Text);

            }, new CancellationTokenSource().Token, TaskCreationOptions.LongRunning, TaskScheduler.FromCurrentSynchronizationContext());
        }

        private void btnSendBugilion_Click(object sender, EventArgs e)
        {
            // Parallel Task: Send
            Task.Factory.StartNew(() => SendBugilion(), new CancellationTokenSource().Token, TaskCreationOptions.LongRunning, TaskScheduler.FromCurrentSynchronizationContext());
        }

        private void btnDrawCircle_Click(object sender, EventArgs e)
        {
            // Parallel Task: Send
            Task.Factory.StartNew(() => DrawCircle(), new CancellationTokenSource().Token, TaskCreationOptions.LongRunning, TaskScheduler.FromCurrentSynchronizationContext());
        }

        private void btnClearLog_Click(object sender, EventArgs e)
        {
            txtLog.Clear();
        }

        private void btnIsSubscribed_Click(object sender, EventArgs e)
        {
            bool result = _ortc.IsSubscribed(txtClientChannelSubscribed.Text);

            if (result == true)
            {
                Log("YES");
            }
            else if(result == false)
            {
                Log("NO");
            }
        }

        #endregion

        #region Post Authentication Text Changes

        private void txtPostAuthToken_TextChanged(object sender, EventArgs e)
        {
            txtPostParams.Text = Regex.Replace(txtPostParams.Text, POST_AUTH_TOKEN_PARAM_PATTERN, "AT=" + ((TextBox)sender).Text);
        }

        private void chkPostAuthTokenIsPrivate_CheckedChanged(object sender, EventArgs e)
        {
            txtPostParams.Text = Regex.Replace(txtPostParams.Text, POST_AUTH_TOKEN_IS_PRIVATE_PARAM_PATTERN, "&PVT=" + (chkPostAuthTokenIsPrivate.Checked ? "1" : "0"));
        }

        private void txtPostAppKey_TextChanged(object sender, EventArgs e)
        {
            txtPostParams.Text = Regex.Replace(txtPostParams.Text, POST_APP_KEY_PARAM_PATTERN, "&AK=" + ((TextBox)sender).Text);
        }

        private void txtPostTTL_TextChanged(object sender, EventArgs e)
        {
            txtPostParams.Text = Regex.Replace(txtPostParams.Text, POST_TTL_PARAM_PATTERN, "&TTL=" + ((TextBox)sender).Text);
        }

        private void txtPostPrivateKey_TextChanged(object sender, EventArgs e)
        {
            txtPostParams.Text = Regex.Replace(txtPostParams.Text, POST_PRIVATE_KEY_PARAM_PATTERN, "&PK=" + ((TextBox)sender).Text);
        }

        #endregion

        private void timer1_Tick(object sender, EventArgs e)
        {
            DateTime dt = DateTime.Now;
            string datePatt = @"HH:mm:ss";

            lblCurrentTime.Text = String.Format("{0}", dt.ToString(datePatt));
        }

        #endregion

        private void btnEnablePresence_Click(object sender, EventArgs e)
        {
            var metadata = !String.IsNullOrEmpty(txtClientConnectionMetadata.Text);

            if (_ortc.IsConnected)
            {
                _ortc.EnablePresence(txtPostAuthPrivateKey.Text,txtClientChannel.Text, metadata, (error, result) =>
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
            else
            {
                var isCluster = chkClientIsCluster.Checked;
                var url = txtClientUrl.Text;

                Ibt.Ortc.Api.Ortc.EnablePresence(url, isCluster, txtClientAppKey.Text, txtPostAuthPrivateKey.Text,txtClientChannel.Text, metadata, (error, result) =>
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

        private void btnDisablePresence_Click(object sender, EventArgs e)
        {
            if (_ortc.IsConnected)
            {
                _ortc.DisablePresence(txtPostAuthPrivateKey.Text, txtClientChannel.Text, (error, result) =>
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
            else
            {
                var isCluster = chkClientIsCluster.Checked;
                var url = txtClientUrl.Text;

                Ibt.Ortc.Api.Ortc.DisablePresence(url, isCluster, txtClientAppKey.Text, txtPostAuthPrivateKey.Text, txtClientChannel.Text, (error, result) =>
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


}