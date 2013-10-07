## The Realtime Framework Pub/Sub messaging system
Part of the [The Realtime® Framework](http://www.realtime.co/solutions/realtimeframework), ORTC (Open Realtime Connectivity) is a secure, fast and highly scalable cloud-hosted Pub/Sub real-time messaging system for web and mobile apps.

If your website or mobile app has data that needs to be updated in the user’s interface as it changes (e.g. real-time stock quotes or ever changing social news feed) ORTC is the reliable, easy, unbelievably fast, “works everywhere” solution.

## The .NET website sample app
This sample app (a .NET website application) uses the Realtime® Framework Pub/Sub .NET library to connect, send and receive messages through a Realtime® Server in the cloud.

When developing an ASP.NET application that uses a Realtime® Framework client in server side, you want that client to live during the application lifetime and not just the request lifetime.

In order to achieve this goal you need to instantiate the client in `Global.asax` at the `Application Start` event handler.

After the client is instantiated you must add the client to the application context,
so you can access it in every request. 

In order to test the application, you can run the JavaScript sample app ([https://github.com/RTWWorld/pubsub-examples/tree/master/Javascript](https://github.com/RTWWorld/pubsub-examples/tree/master/Javascript)), subscribe the channel `MyChannel` and see messages arriving in real-time whenever you change the tab in the web application.

### A few deploy notes:

- Ensure the DLL's are not blocked. In order to unblock it go to file properties in windows explorer and press the unblock button in the tab General;

- Ensure your application has access to the plugins folder;

- The only assemblies you need to add as reference to your project are `Ibt.Ortc.Api.dll` and `Ibt.Ortc.Api.Extensibility.dll`

----------


> NOTE: For simplicity these samples assume you're using a Realtime® Framework developers' application key with the authentication service disabled (every connection will have permission to publish and subscribe to any channel). For security guidelines please refer to the [Security Guide](http://docs.xrtml.org/pubsub/overview/2-1-0/security.htm). 
> 
> **Don't forget to replace `YOUR_APPLICATION_KEY` and `YOUR_APPLICATION_PRIVATE_KEY` with your own application key. If you don't already own a free Realtime® Framework application key, [get one now](https://app.realtime.co/developers/getlicense).**


## Documentation
The complete Realtime® Framework Pub/Sub reference documentation is available [here](http://docs.xrtml.org/pubsub/library/2-1-0/welcome.htm)