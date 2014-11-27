using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;

// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=234238

namespace OrtcConsole
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MainPage : Page
    {
        enum ConsoleState { Connection, Authentication, Presence }

        OrtcExample ortcExample;

        Brush blackBrush = new SolidColorBrush(Windows.UI.Colors.Black);
        Brush grayBrush = new SolidColorBrush(Windows.UI.Colors.Gray);

        public MainPage()
        {
            this.InitializeComponent();

            SetControls(ConsoleState.Connection);

            ortcExample = new OrtcExample();

            ConsoleGrid.DataContext = ortcExample;

            BtConnect.Click += ortcExample.DoConnect;
            BtDisconnect.Click += ortcExample.DoDisconnect;
            BtSend.Click += ortcExample.DoSendMessage;
            BtSubscribe.Click += ortcExample.DoSubscribe;
            BtUnsubscribe.Click += ortcExample.DoUnsubscribe;
            BtGetPresence.Click += ortcExample.DoGetPresence;
            BtEnablePresence.Click += ortcExample.DoEnablePresence;
            BtDisablePresence.Click += ortcExample.DoDisablePresence;
            BtAuthenticate.Click += ortcExample.DoSaveAuthentication;

            BtConnection.Click += BtConnection_Click;
            BtAuthentication.Click += BtAuthentication_Click;
            BtPresence.Click += BtPresence_Click;
        }

        void BtPresence_Click(object sender, RoutedEventArgs e) {
            SetControls(ConsoleState.Presence);
        }

        void BtAuthentication_Click(object sender, RoutedEventArgs e) {
            SetControls(ConsoleState.Authentication);
        }

        void BtConnection_Click(object sender, RoutedEventArgs e) {
            SetControls(ConsoleState.Connection);
        }


        private void SetControls(ConsoleState consoleState) {
            BtConnection.Foreground = consoleState == ConsoleState.Connection ? blackBrush : grayBrush;
            BtAuthentication.Foreground = consoleState == ConsoleState.Authentication ? blackBrush : grayBrush;
            BtPresence.Foreground = consoleState == ConsoleState.Presence ? blackBrush : grayBrush;

            TbPrivateKey.IsEnabled = consoleState != ConsoleState.Connection;
            TbMessage.IsEnabled = consoleState == ConsoleState.Connection;
            BtConnect.IsEnabled = consoleState == ConsoleState.Connection;
            BtDisconnect.IsEnabled = consoleState == ConsoleState.Connection;
            BtSend.IsEnabled = consoleState == ConsoleState.Connection;
            BtSubscribe.IsEnabled = consoleState == ConsoleState.Connection;
            BtUnsubscribe.IsEnabled = consoleState == ConsoleState.Connection;
            BtGetPresence.IsEnabled = consoleState == ConsoleState.Connection;

            CbMetadata.IsEnabled = consoleState == ConsoleState.Presence;
            BtEnablePresence.IsEnabled = consoleState == ConsoleState.Presence;
            BtDisablePresence.IsEnabled = consoleState == ConsoleState.Presence;

            CbIsPrivate.IsEnabled = consoleState == ConsoleState.Authentication;
            TbTTL.IsEnabled = consoleState == ConsoleState.Authentication;
            CbPermissions.IsEnabled = consoleState == ConsoleState.Authentication;
            BtAuthenticate.IsEnabled = consoleState == ConsoleState.Authentication;
        }

    }
}
