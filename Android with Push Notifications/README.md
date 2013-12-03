## The Realtime Framework Pub/Sub messaging system
Part of the [The Realtime® Framework](http://framework.realtime.co), Realtime Cloud Messaging (aka ORTC) is a secure, fast and highly scalable cloud-hosted Pub/Sub real-time message broker for web and mobile apps.

If your website or mobile app has data that needs to be updated in the user’s interface as it changes (e.g. real-time stock quotes or ever changing social news feed) Realtime Cloud Messaging is the reliable, easy, unbelievably fast, “works everywhere” solution.


## The Android sample app with Push Notifications via GCM
This sample app uses the Realtime® Framework Pub/Sub Java library to connect, send and receive messages through a Realtime® Server in the cloud. Through the use of Google Cloud Messaging (GCM) messages are delivered as push notifications when the users are offline.

![ScreenShot](http://messaging-public.realtime.co/screenshots/2.1.0/Android/Screen.jpg)

## Before you begin:

1. Import the ORTCAndroidSample folder into your IDE. In Eclipse, click File, Import, expand the Android folder, click Existing Android Code Into Workspace, click Next, browse to the folder ORTCAndroidSample, click OK, and then click Finish.

2. Add the ortc library to your project build path. The ortc library is located in the subfolder ortclib/ortc-android-x.x.x.jar 
Select 'Properties' of your project, then 'Java Build Path', go to the tab 'Libraries', click the button 'Add JARs...', select your project, navigate to folder 'ortclib' and select the ortc-adroid-x.x.x.jar 
Go to the tab 'Order and Export' and make sure that ortc library is checked.

3. You will need to setup your project to use the Google Play Services library as described here:

http://developer.android.com/google/play-services/setup.html

4. You also need the v4 support library:

http://developer.android.com/training/basics/fragments/support-lib.html

5. To run this application, you must have the Project Number for your Google API project. For details, see:

http://developer.android.com/google/gcm/gs.html

Replace the string "your_google_project_id" with your Google Project Number in file ORTCAndroidSample.java line 59.

6. Register your application key to use GCM notifications (see your Realtime® Developer Account).

> NOTE: For simplicity these samples assume you're using a Realtime® Framework developers' application key with the authentication service disabled (every connection will have permission to publish and subscribe to any channel). For security guidelines please refer to the [Security Guide](http://messaging-public.realtime.co/documentation/starting-guide/security.html). 
> 
> **Don't forget to replace `YOUR_APPLICATION_KEY` and `YOUR_APPLICATION_PRIVATE_KEY` with your own application key. If you don't already own a free Realtime® Framework application key, [get one now](https://accounts.realtime.co/signup/).**


## Documentation
The Mobile Push Notifications Starting Guide can be found [here](http://messaging-public.realtime.co/documentation/starting-guide/mobilepush.html)

The complete Realtime® Cloud Messaging reference documentation is available [here](http://framework.realtime.co/messaging/#documentation)