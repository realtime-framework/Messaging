## The Realtime Framework Pub/Sub messaging system
Part of the [The Realtime® Framework](http://framework.realtime.co), Realtime Cloud Messaging (aka ORTC) is a secure, fast and highly scalable cloud-hosted Pub/Sub real-time message broker for web and mobile apps.

If your website or mobile app has data that needs to be updated in the user’s interface as it changes (e.g. real-time stock quotes or ever changing social news feed) Realtime Cloud Messaging is the reliable, easy, unbelievably fast, “works everywhere” solution.

## The Node.js sample app
This sample app uses the Realtime® Framework Pub/Sub Node.js library to connect, send and receive messages through a Realtime® Server in the cloud.

Before running this sample install the Realtime® Framework Pub/Sub client for Node.js using the following command:

```
npm install ibtrealtimesjnode
```

![ScreenShot](http://messaging-public.realtime.co/screenshots/2.1.0/NodeJs/Screen.jpg)

This sample will subscribe MyChannel and sent a Hello World message every second. 15 seconds after the sample start a presence request will be issued for MyChannel.

You might want to use this sample in conjunction with the JavaScript sample and subscribe MyChannel. You should see the messages sent by the Node.js sample being delivered to the JavaScript sample every 5 seconds.

> NOTE: For simplicity these samples assume you're using a Realtime® Framework developers' application key with the authentication service disabled (every connection will have permission to publish and subscribe to any channel). For security guidelines please refer to the [Security Guide](http://messaging-public.realtime.co/documentation/starting-guide/security.html). 
> 
> **Don't forget to replace `YOUR_APPLICATION_KEY` and `YOUR_APPLICATION_PRIVATE_KEY` with your own application key. If you don't already own a free Realtime® Framework application key, [get one now](https://accounts.realtime.co/signup/).**


## Documentation
The complete Realtime® Cloud Messaging reference documentation is available [here](http://framework.realtime.co/messaging/#documentation)