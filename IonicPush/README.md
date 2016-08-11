# Realtime Messaging Ionic example for Push Notifications (iOS and Android)

This Ionic example using the CordovaPush plugin should be used with the iOS/Android platforms together with the Realtime Messaging library (ORTC) for Push Notifications support.

How to build and run this sample using the Ionic CLI:


   	1. ionic start [project-name] [project-template]
	2. cd [project-directory]
	3. ionic platform add ios
	4. ionic platform add android
	5. cordova plugin add cordovapush
	6. [replace index.html on the main www folder]
	7. [copy css/style.css to the main www/css folder]
	8. [copy the images in folder icons to your project resources/android/ folder]
	7. ionic build ios
	8. ionic build android
	9. ionic emulate ios
	10. ionic emulate android
    
Have fun pushing!

## Plugin documentation: ##

[https://www.npmjs.com/package/cordovapush](https://www.npmjs.com/package/cordovapush)

> NOTE: For simplicity these samples assume you're using a Realtime® Framework developers' application key with the authentication service disabled (every connection will have permission to publish and subscribe to any channel). For security guidelines please refer to the [Security Guide](http://messaging-public.realtime.co/documentation/starting-guide/security.html). 
> 
> **Don't forget to replace `YOUR_APPLICATION_KEY` and `YOUR_APPLICATION_PRIVATE_KEY` with your own application key. If you don't already own a free Realtime® Framework application key, [get one now](https://accounts.realtime.co/signup/).**


## License
Copyright 2016, Realtime.co.

Licensed under the MIT license: [http://www.opensource.org/licenses/mit-license.php](http://www.opensource.org/licenses/mit-license.php)
