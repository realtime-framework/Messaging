using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using Microsoft.Phone.Controls;
using Ibt.Ortc.Mobile.Extensibility;
using Ibt.Ortc.Mobile.Api;
using System.Text.RegularExpressions;

namespace Ibt.Ortc.Demo.Mobile
{
    public partial class MainPage : PhoneApplicationPage
    {
        private IOrtcClient client;
        private const String url = "http://ortc-developers.realtime.co/server/2.1/";
        private const String appKey = "YOUR_APPLICATION_KEY";
        private const String authToken = "AUTHENTICATION_TOKEN";
        private const String privateKey = "YOUR_APPLICATION_PRIVATE_KEY";
        private bool isAuthenticationRequired = false;

        // Constructor
        public MainPage()
        {
            InitializeComponent();

            AuthenticateClient();
        }

        private void AuthenticateClient()
        {
            if (isAuthenticationRequired)
            {
                textBlockConnectionStatus.Text = String.Format("Authenticating");

                var permissions = new Dictionary<String, ChannelPermissions>();
                permissions.Add("MyChannel", ChannelPermissions.Write);

                Ibt.Ortc.Mobile.Api.Ortc.SaveAuthenticationAsync(url, true, "UserConnectionMetadata", false, appKey, 3600, privateKey, permissions, (error, authenticated) =>
                {
                    if (error != null)
                    {
                        throw error;
                    }
                    else
                    {
                        textBlockConnectionStatus.Text = String.Format("Authenticated");
                        InitializeClient();
                    }
                });
            }
            else
            {
                InitializeClient();
            }
        }

        private void InitializeClient()
        {
            var ortc = new Ibt.Ortc.Mobile.Api.Ortc();

            var factory = ortc.LoadOrtcFactory("IbtRealTimeSJ");

            client = factory.CreateClient();

            client.OnConnected += (s) =>
            {
                textBlockConnectionStatus.Text = String.Format("Connected to {0}", ((IOrtcClient)s).Url);
            };

            client.OnDisconnected += (s) =>
            {
                textBlockConnectionStatus.Text = String.Format("Disconnected");
            };

            client.OnException += (s, error) =>
            {
                textBlockLog.Text += String.Format("Error: {0}{1}", error.Message, Environment.NewLine);
            };

            client.OnReconnecting += (s) =>
            {
                textBlockConnectionStatus.Text = String.Format("Disconnected");
                textBlockLog.Text = String.Format("Reconnecting");
            };

            client.OnReconnected += (s) =>
            {
                textBlockConnectionStatus.Text = String.Format("Reconnected to {0}", ((IOrtcClient)s).Url);
            };

            client.OnSubscribed += (s, channel) =>
            {
                textBlockLog.Text += String.Format("Channel {0} subscribed.{1}", channel, Environment.NewLine);
            };

            client.OnUnsubscribed += (s, channel) =>
            {
                textBlockLog.Text += String.Format("Channel {0} unsubscribed.{1}", channel, Environment.NewLine);
            }; 
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            client.ClusterUrl = url;

            client.ConnectionMetadata = "UserConnectionMetadata";

            client.AnnouncementSubChannel = "WP7";

            client.Connect(appKey, authToken);            
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            client.Disconnect();
        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            textBlockLog.Text = String.Empty;
        }

        private void Button_Click_3(object sender, RoutedEventArgs e)
        {
            client.Subscribe(textBoxChannel.Text, true, (s, channel, message) =>
            {
                textBlockLog.Text += String.Format("Message on channel {0}: {1}{2}", channel,message,  Environment.NewLine);
            });
        }

        private void Button_Click_4(object sender, RoutedEventArgs e)
        {
            client.Send(textBoxChannel.Text, textBoxMessage.Text);
        }

        private void Button_Click_5(object sender, RoutedEventArgs e)
        {
            client.Unsubscribe(textBoxChannel.Text);
        }

        private void Button_Click_6(object sender, RoutedEventArgs e)
        {
            Ibt.Ortc.Mobile.Api.Ortc.Presence(
               url,
               true,
               appKey,
               authToken,
               textBoxChannel.Text,
               (error, presence) =>
               {
                   if (error != null)
                   {
                       textBlockLog.Text += String.Format("Error: {0}{1}", error.Message, Environment.NewLine);
                   }
                   else
                   {
                       textBlockLog.Text += String.Format("Subscriptions {0}{1}", presence.Subscriptions, Environment.NewLine);
                       if (presence.Metadata != null)
                       {
                           foreach (var metadata in presence.Metadata)
                           {
                               textBlockLog.Text += String.Format("{0} - {1}{2}", metadata.Key, metadata.Value,Environment.NewLine);
                           }
                       }
                   }
               });
        }
    }
}