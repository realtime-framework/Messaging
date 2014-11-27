using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using Windows.UI.Xaml;

using RealtimeFramework.Messaging;

namespace OrtcConsole
{
    public class OrtcExample : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged; 
        private OrtcClient ortcClient;

        public string ApplicationKey { get; set; }
        public string AuthenticationToken { get; set; }
        public string Url { get; set; }
        public string ConnectionMetadata { get; set; }
        public string Channel { get; set; }
        public string Message { get; set; }
        public string Log { get;  set; }
        public Boolean IsCluster { get; set; }
        public string ActionName { get; set; }

        public string PrivateKey { get; set; }
        public Boolean Metadata { get; set; }
        public Boolean IsPrivate { get; set; }
        public Int32 Ttl { get; set; }
        public string PermisionType { get; set; }

        public OrtcExample() {
            ortcClient = new RealtimeFramework.Messaging.OrtcClient();
            ApplicationKey = "YourApplicationKey";
            AuthenticationToken = "YourToken";
            Url = "https://ortc-developers.realtime.co/server/ssl/2.1";// "http://ortc-prd2-useast1-S0002.realtime.co";// 
            ConnectionMetadata = "Windows 8.1 Example";
            Channel = "yellow";
            Message = "This is the message.";
            Log = "";
            IsCluster = true;
            ActionName = "Connect";
            PrivateKey = "YourPrivateKey";
            IsPrivate = false;
            Ttl = 1800;
            PermisionType = "Read";

            ortcClient.OnConnected += ortcClient_OnConnected;
            ortcClient.OnDisconnected += ortcClient_OnDisconnected;
            ortcClient.OnException += ortcClient_OnException;
            ortcClient.OnSubscribed += ortcClient_OnSubscribed;
            ortcClient.OnUnsubscribed += ortcClient_OnUnsubscribed;
            ortcClient.OnReconnecting += ortcClient_OnReconnecting;
            ortcClient.OnReconnected += ortcClient_OnReconnected;
        }

        void ortcClient_OnReconnected(object sender) {
            WriteLog("Reconnected!");
        }

        void ortcClient_OnReconnecting(object sender) {
            WriteLog("Reconnecting...");
        }

        void ortcClient_OnUnsubscribed(object sender, string channel) {
            WriteLog("Unsubscribed from: " + channel);
        }

        void ortcClient_OnSubscribed(object sender, string channel) {
            WriteLog("Subscribed to: " + channel);
        }

        void ortcClient_OnException(object sender, Exception ex) {
            WriteLog("Exception: " + ex.Message);
        }

        void ortcClient_OnDisconnected(object sender) {
            ActionName = "Connect";
            NotifyPropertyChanged("ActionName");
            WriteLog("Disconnected!");
        }

        void ortcClient_OnConnected(object sender) {
            ActionName = "Disconnect";
            NotifyPropertyChanged("ActionName");
            WriteLog("Connected to: " + ortcClient.Url);
        }

        private void WriteLog(string p) {
            Log = DateTime.Now.ToString("HH:mm:ss") + " :: " + p + Environment.NewLine + Log;
            NotifyPropertyChanged("Log");
        }

        public void DoConnectDisconnect(object sender, RoutedEventArgs e) {
            if (ortcClient.IsConnected) {
                ortcClient.Disconnect();
                WriteLog("Disconnecting...");
            } else {
                ortcClient.ConnectionMetadata = ConnectionMetadata;
                if (IsCluster)
                    ortcClient.ClusterUrl = Url;
                else
                    ortcClient.Url = Url;
                ortcClient.Connect(ApplicationKey, AuthenticationToken);
                WriteLog("Connecting...");
            } 
        }

        public void DoConnect(object sender, RoutedEventArgs e) {
            ortcClient.ConnectionMetadata = ConnectionMetadata;
            if (IsCluster)
                ortcClient.ClusterUrl = Url;
            else
                ortcClient.Url = Url;
            ortcClient.Connect(ApplicationKey, AuthenticationToken);
            WriteLog("Connecting...");
        }

        public void DoDisconnect(object sender, RoutedEventArgs e) {
            ortcClient.Disconnect();
            WriteLog("Disconnecting...");
        }

        public void DoSendMessage(object sender, RoutedEventArgs e) {
            ortcClient.Send(Channel, Message);
        }

        public void DoSubscribe(object sender, RoutedEventArgs e) {
            ortcClient.Subscribe(Channel, true, OnMessageCallback);
        }

        private void OnMessageCallback(object sender, string channel, string message) {
            WriteLog("Received (at " + channel + "): " + message);
        }

        public void DoUnsubscribe(object sender, RoutedEventArgs e) {
            ortcClient.Unsubscribe(Channel);
        }

        public void DoClearLog(object sender, RoutedEventArgs e) {
            Log = "";
            NotifyPropertyChanged("Log");
        }

        public void DoGetPresence(object sender, RoutedEventArgs e) {
            Ortc.Presence(Url, IsCluster, ApplicationKey, AuthenticationToken, Channel, (error, presence) => {
                if (error != null) {
                    WriteLog("Error retrieving presence: " + error.Message);
                } else {
                    WriteLog("Presence data:\n-Subscriptions: "+presence.Subscriptions+"\n-Metadata: " + string.Join("; ", presence.Metadata));
                }
                
            });
        }

        public void DoEnablePresence(object sender, RoutedEventArgs e) {
            Ortc.EnablePresence(Url, IsCluster, ApplicationKey, PrivateKey, Channel, Metadata, (error, result) => {
                if (error != null) {
                    WriteLog("Enable Presence Error: " + error.Message);
                } else {
                    WriteLog("Enable Presence: " + result);
                }
            });
        }

        public void DoDisablePresence(object sender, RoutedEventArgs e) {
            Ortc.DisablePresence(Url, IsCluster, ApplicationKey, PrivateKey, Channel, (error, result) => {
                if (error != null) {
                    WriteLog("Disable Presence Error: " + error.Message);
                } else {
                    WriteLog("Disable Presence: " + result);
                }
            });
        }

        public void DoSaveAuthentication(object sender, RoutedEventArgs e) {
            Dictionary<string, Ortc.ChannelPermissions> permissions = new Dictionary<string, Ortc.ChannelPermissions>();

            if (PermisionType.Equals("Read")) {
                permissions.Add(Channel, Ortc.ChannelPermissions.Read);
            } else if (PermisionType.Equals("Write")) {
                permissions.Add(Channel, Ortc.ChannelPermissions.Write);
            } else {
                permissions.Add(Channel, Ortc.ChannelPermissions.Presence);
            }
            try {
                if (Ortc.SaveAuthentication(Url, IsCluster, AuthenticationToken, IsPrivate, ApplicationKey, Ttl, PrivateKey, permissions)) {
                    WriteLog("Token authenticated");
                } else {
                    WriteLog("Authentication failed");
                }
            } catch (Exception exc) {
                WriteLog("Exception: " + exc.Message);
            }
        }

        private async void NotifyPropertyChanged(string propertyName) {
            if (PropertyChanged != null) {
                await ExecuteOnUIThread(() => {
                    PropertyChanged(this,
                        new PropertyChangedEventArgs(propertyName));
                });
            }
        }       

        private Windows.Foundation.IAsyncAction ExecuteOnUIThread(Windows.UI.Core.DispatchedHandler action) {
            return Windows.ApplicationModel.Core.CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(Windows.UI.Core.CoreDispatcherPriority.Normal, action);
        }
    }
}
