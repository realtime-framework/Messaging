// -------------------------------------
//  Domain	: Realtime.co
//  Author	: Nicholas Ventimiglia
//  Product	: Messaging and Storage
//  Copyright (c) 2014 IBT  All rights reserved.
//  -------------------------------------
using System;
using System.Collections;
using RealtimeDemos.TerminalConsole;
using RealtimeMessaging;
using RealtimeMessaging.Ibt.Ortc;
using UnityEngine;

namespace RealtimeDemos
{
    /// <summary>
    /// Demo Client using the Realtime Client
    /// </summary>
    public class RealtimeTest : MonoBehaviour
    {
        /// <summary>
        /// Identifies the client.
        /// </summary>
        public string ClientMetaData = "UnityClient1";

        /// <summary>
        /// Send / Subscribe channel
        /// </summary>
        public string Channel = "myChannel";

        /// <summary>
        /// Message Content
        /// </summary>
        public string Message = "This is my message";

        // Note : this section should really be handled on a webserver you control. It is here only as education.

        /// <summary>
        /// The token that the client uses to access the Pub/Sub network
        /// </summary>
        public string AuthToken = "UnityClient1";

        /// <summary>
        /// Permissions used if authenticating
        /// </summary>
        public RealtimePermission[] Permissions =
        {
            new RealtimePermission("myChannel", ChannelPermissions.Read), 
            new RealtimePermission("myChannel", ChannelPermissions.Write), 
            new RealtimePermission("myChannel", ChannelPermissions.Presence), 

        };

        private RealtimeMessenger Messenger { get; set; }

        protected void Awake()
        {
            Messenger = new RealtimeMessenger();
            Messenger.OnMessage += OnMessage;
            Messenger.ConnectionMetadata = ClientMetaData = Application.platform + "-" + UnityEngine.Random.Range(0, 20);

            Message = string.Format("{0} : {1}", ClientMetaData, "Hello World");

            Terminal.LogInput("Start with a dot to change name ie : '.myname'");
            Terminal.LogInput("Any other text (once connected) to message");
            Terminal.LogInput("Current Id : " + ClientMetaData);
            Terminal.LogInput("RealtimeMessenger Test");

            LoadCommands();
        }

        void OnMessage(string channel, string message)
        {
            Terminal.Log(String.Format("[{0}] > {1}", channel, message));
        }

        void ReadText(string text)
        {
            if (text.StartsWith("."))
            {
                Messenger.ConnectionMetadata = ClientMetaData = text.Replace(".", "");
                Terminal.LogImportant("Name set to " + ClientMetaData);
            }
            else
            {
                if (!Messenger.IsConnected)
                {
                    Debug.LogError("Not Connected");
                }
                else
                {
                    Message = string.Format("{0} : {1}", ClientMetaData, text);
                    StartCoroutine(Send());
                }
            }
        }

        void LoadCommands()
        {
            Terminal.Add(new TerminalInterpreter
            {
                Label = "Chat",
                Method = ReadText
            });

            //

            Terminal.Add(new TerminalCommand
            {
                Label = "Connect",
                Method = () => StartCoroutine(Connect())
            });

            Terminal.Add(new TerminalCommand
            {
                Label = "Disconnect",
                Method = () => StartCoroutine(Disconnect())
            });

            //

            Terminal.Add(new TerminalCommand
            {
                Label = "Subscribe",
                Method = () => StartCoroutine(Subscribe())
            });

            Terminal.Add(new TerminalCommand
            {
                Label = "Unsubscribe",
                Method = () => StartCoroutine(Unsubscribe())
            });
            Terminal.Add(new TerminalCommand
            {
                Label = "Send",
                Method = () => StartCoroutine(Send())
            });

            //
            Terminal.Add(new TerminalCommand
            {
                Label = "Pause",
                Method = () => StartCoroutine(Pause())
            });

            Terminal.Add(new TerminalCommand
            {
                Label = "Resume",
                Method = () => StartCoroutine(Resume())
            });

            //

            Terminal.Add(new TerminalCommand
            {
                Label = "Auth",
                Method = () => StartCoroutine(Auth())
            });

            //

            Terminal.Add(new TerminalCommand
            {
                Label = "EnablePresence",
                Method = () => StartCoroutine(EnablePresence())
            });


            Terminal.Add(new TerminalCommand
            {
                Label = "DisablePresense",
                Method = () => StartCoroutine(DisablePresence())
            });

            Terminal.Add(new TerminalCommand
            {
                Label = "Presence",
                Method = () => StartCoroutine(RequestPresence())
            });

            //


        }

        protected void OnApplicationPause(bool isPaused)
        {
            if (isPaused)
            {

                if (Messenger.IsConnected)
                    Messenger.Pause();
            }
            else
            {
                if (Messenger.IsPaused)
                    Messenger.Resume();
            }
        }


        #region methods
        
        IEnumerator Auth()
        {
            Terminal.Log("Posting Authentication Token");

            Messenger.AuthenticationToken = AuthToken;
            var task = Messenger.PostAuthentication(Permissions);

            yield return StartCoroutine(task.WaitRoutine());

            if (task.IsFaulted)
                Terminal.LogError(task.Exception);
            else
            {
                Terminal.LogSuccess("Authentication Posted");
            }

        }

        IEnumerator RequestPresence()
        {
            // Authenticate
            Terminal.Log("Getting Presence : " + Channel);

            var task = Messenger.GetPresence(AuthToken, Channel);

            yield return StartCoroutine(task.WaitRoutine());

            if (task.IsFaulted)
                Terminal.LogError(task.Exception.Message);
            else
            {
                Terminal.LogSuccess("Presence Got");

                Terminal.Log(String.Format("Subscriptions {0}", task.Result.Subscriptions));
                Terminal.Log(String.Format("Metadatas {0}", task.Result.Metadata.Count));

                if (task.Result.Metadata != null)
                {
                    foreach (var metadata in task.Result.Metadata)
                    {
                        Terminal.Log(metadata.Key + " - " + metadata.Value);
                    }
                }
            }
        }

        IEnumerator EnablePresence()
        {
            Terminal.Log("Enabling Presence : " + Channel);

            var task = Messenger.EnablePresence(Channel, true);

            yield return StartCoroutine(task.WaitRoutine());

            if (task.IsFaulted)
                Terminal.LogError(task.Exception);
            else
            {
                Terminal.LogSuccess("Presence Enabled");
                Terminal.Log(task.Result);
            }
        }

        IEnumerator DisablePresence()
        {
            Terminal.Log("Disabling Presence : " + Channel);

            var task = Messenger.DisabledPresence(Channel);

            yield return StartCoroutine(task.WaitRoutine());

            if (task.IsFaulted)
                Terminal.LogError(task.Exception);
            else
            {
                Terminal.LogSuccess("Presence Disabled");
                Terminal.Log(task.Result);
            }

        }

        IEnumerator Connect()
        {
            yield return 1;
            Terminal.Log("Connect...");

            Messenger.ConnectionMetadata = ClientMetaData;
            Messenger.AuthenticationToken = AuthToken;
            var task = Messenger.Connect();

            yield return StartCoroutine(task.WaitRoutine());

            if (task.IsFaulted)
                Terminal.LogError(task.Exception.Message);
            else
                Terminal.LogSuccess("Connected !");
        }

        IEnumerator Disconnect()
        {
            yield return 1;
            Terminal.Log("Disconnect...");

            var task = Messenger.Disconnect();

            yield return StartCoroutine(task.WaitRoutine());

            if (task.IsFaulted)
                Terminal.LogError(task.Exception.Message);
            else
                Terminal.LogSuccess("Disconnected !");
        }


        IEnumerator Resume()
        {
            yield return 1;
            Terminal.Log("Resume...");
            
            var task = Messenger.Resume();

            yield return StartCoroutine(task.WaitRoutine());

            if (task.IsFaulted)
                Terminal.LogError(task.Exception.Message);
            else
                Terminal.LogSuccess("Resumed !");
        }

        IEnumerator Pause()
        {
            yield return 1;
            Terminal.Log("Pause...");

            var task = Messenger.Pause();

            yield return StartCoroutine(task.WaitRoutine());

            if (task.IsFaulted)
                Terminal.LogError(task.Exception.Message);
            else
                Terminal.LogSuccess("Paused !");
        }

        IEnumerator Subscribe()
        {
            yield return 1;
            Terminal.Log(String.Format("Subscribe to: {0}...", Channel));

            var task = Messenger.Subscribe(Channel);

            yield return StartCoroutine(task.WaitRoutine());

            if (task.IsFaulted)
                Terminal.LogError(task.Exception.Message);
            else
                Terminal.LogSuccess("Subscribed !");
        }

        IEnumerator Unsubscribe()
        {
            yield return 1;
            Terminal.Log(String.Format("Unsubscribe from: {0}...", Channel));

            var task = Messenger.Unsubscribe(Channel);

            yield return StartCoroutine(task.WaitRoutine());

            if (task.IsFaulted)
                Terminal.LogError(task.Exception.Message);
            else
                Terminal.LogSuccess("Unsubscribed !");
        }

        IEnumerator Send()
        {
            yield return 1;
            // Parallel Task: Send
            //Terminal.Log(string.Format(">> [{0}] {1}",Channel, Message));

            var task = Messenger.Send(Channel, Message);

            yield return StartCoroutine(task.WaitRoutine());

            if (task.IsFaulted)
                Terminal.LogError(task.Exception.Message);
            //else
            //    Terminal.LogSuccess("Sent !");
        }
        #endregion
    }
}
