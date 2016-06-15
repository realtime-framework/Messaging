# Realtime Messaging Cordova example for Push Notifications (iOS and Android)

This Cordova example and plugin should be used with the iOS/Android platforms together with the Realtime Messaging library (ORTC) for Push Notifications support.

How to build and run this sample using the Cordova CLI:


    1. cordova create [project-directory] [project-identifier] [project-name]
    2. cd [project-directory]
    3. cordova platform add android
    4. cordova platform add ios
    5. cordova plugin add cordovapush
    6. [replace index.html on the main www folder]
    7. cordova build
    8. cordova run android
    9. cordova run ios
    
Have fun pushing!

## Plugin documentation: ##

[https://www.npmjs.com/package/cordovapush](https://www.npmjs.com/package/cordovapush)

> NOTE: For simplicity these samples assume you're using a Realtime® Framework developers' application key with the authentication service disabled (every connection will have permission to publish and subscribe to any channel). For security guidelines please refer to the [Security Guide](http://messaging-public.realtime.co/documentation/starting-guide/security.html). 
> 
> **Don't forget to replace `YOUR_APPLICATION_KEY` and `YOUR_APPLICATION_PRIVATE_KEY` with your own application key. If you don't already own a free Realtime® Framework application key, [get one now](https://accounts.realtime.co/signup/).**


## License
Copyright 2016, Realtime.co.

Licensed under the MIT license: [http://www.opensource.org/licenses/mit-license.php](http://www.opensource.org/licenses/mit-license.php)
