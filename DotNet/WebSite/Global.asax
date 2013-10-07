<%@ Application Language="C#" %>

<script runat="server">    
    
    void Application_Start(object sender, EventArgs e) 
    {
        string appKey = "YOUR_APPLICATION_KEY";
        string authToken = "AUTHENTICATION_TOKEN";
        string connectionUrl = "http://ortc-developers.realtime.co/server/2.1";
        
        var api = new Ibt.Ortc.Api.Ortc("[REPLACE WITH THE ABSOLUTE PATH TO THE REALTIME PLUGINS FOLDER]");

        Ibt.Ortc.Api.Extensibility.IOrtcFactory factory = api.LoadOrtcFactory("IbtRealTimeSJ");

        if (factory != null)
        {
            // Create ORTC client
            var ortcClient = factory.CreateClient();

            if (ortcClient != null)
            {
                ortcClient.ClusterUrl = connectionUrl;
                ortcClient.ConnectionMetadata = "UserConnectionMetadata";

                // Ortc client handlers
                ortcClient.OnConnected += new Ibt.Ortc.Api.Extensibility.OnConnectedDelegate(ortcClient_OnConnected);
                ortcClient.OnDisconnected += new Ibt.Ortc.Api.Extensibility.OnDisconnectedDelegate(ortcClient_OnDisconnected);
                ortcClient.OnReconnecting += new Ibt.Ortc.Api.Extensibility.OnReconnectingDelegate(ortcClient_OnReconnecting);
                ortcClient.OnReconnected += new Ibt.Ortc.Api.Extensibility.OnReconnectedDelegate(ortcClient_OnReconnected);
                ortcClient.OnSubscribed += new Ibt.Ortc.Api.Extensibility.OnSubscribedDelegate(ortcClient_OnSubscribed);
                ortcClient.OnUnsubscribed += new Ibt.Ortc.Api.Extensibility.OnUnsubscribedDelegate(ortcClient_OnUnsubscribed);
                ortcClient.OnException += new Ibt.Ortc.Api.Extensibility.OnExceptionDelegate(ortcClient_OnException);
                
                // Add the realtime client to your application context
                Application.Add("RealtimeClient", ortcClient);
                ortcClient.Connect(appKey, authToken);
            }
            else
            {
                // Error creating client
            }
        }
        else
        {
            // Error loading factory
        }

    }

    void ortcClient_OnException(object sender, Exception ex)
    {
        System.Diagnostics.Trace.WriteLine(String.Format("Realtime exception {1}", ex));
    }

    void ortcClient_OnUnsubscribed(object sender, string channel)
    {
        System.Diagnostics.Trace.WriteLine(String.Format("Realtime unsubscribed {1}", channel));
    }

    void ortcClient_OnSubscribed(object sender, string channel)
    {
        System.Diagnostics.Trace.WriteLine(String.Format("Realtime subscribed {1}", channel));
        
        // Get the realtime client from your application context
        var ortcClient = (Ibt.Ortc.Api.Extensibility.OrtcClient)Application["RealtimeClient"];
        
        ortcClient.Send(channel, "Server subscribed");        
    }

    void ortcClient_OnReconnected(object sender)
    {
        System.Diagnostics.Trace.WriteLine("Realtime reconnected");
    }

    void ortcClient_OnReconnecting(object sender)
    {
        System.Diagnostics.Trace.WriteLine("Realtime reconnecting");
    }

    void ortcClient_OnDisconnected(object sender)
    {
        System.Diagnostics.Trace.WriteLine("Realtime disconnected");
    }

    void ortcClient_OnConnected(object sender)
    {
        System.Diagnostics.Trace.WriteLine("Realtime connected");

        // Get the realtime client from your application context
        var ortcClient = (Ibt.Ortc.Api.Extensibility.OrtcClient)Application["RealtimeClient"];

        ortcClient.Subscribe("MyChannel", true, (s, channel, message) =>
        {
            System.Diagnostics.Trace.WriteLine(String.Format("Realtime Message received {1} : {2}",channel,message));
        });
    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  Code that runs on application shutdown

    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e) 
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e) 
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }
       
</script>
