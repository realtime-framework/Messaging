## The Realtime Framework Pub/Sub messaging system
Part of the [The Realtime® Framework](http://framework.realtime.co), Realtime Cloud Messaging (aka ORTC) is a secure, fast and highly scalable cloud-hosted Pub/Sub real-time message broker for web and mobile apps.

If your website or mobile app has data that needs to be updated in the user’s interface as it changes (e.g. real-time stock quotes or ever changing social news feed) Realtime Cloud Messaging is the reliable, easy, unbelievably fast, “works everywhere” solution.

## The Lua sample app
This sample app uses the Realtime® Framework Pub/Sub Lua library to connect, send and receive messages through a Realtime® Server in the cloud.

This library requires Lua 5.1 and a small set of modules. 

To install them in a Linux machine simply run:

```
apt-get install lua5.1 liblua5.1-socket-dev liblua5.1-socket2 luasocket lua5.1-filesystem
```

> NOTE: For simplicity these samples assume you're using a Realtime® Framework developers' application key with the authentication service disabled (every connection will have permission to publish and subscribe to any channel). For security guidelines please refer to the [Security Guide](http://messaging-public.realtime.co/documentation/starting-guide/security.html). 
> 
> **Don't forget to replace `YOUR_APPLICATION_KEY` and `YOUR_APPLICATION_PRIVATE_KEY` with your own application key. If you don't already own a free Realtime® Framework application key, [get one now](https://accounts.realtime.co/signup/).**


## Documentation
The complete Realtime® Cloud Messaging reference documentation is available [here](http://framework.realtime.co/messaging/#documentation)