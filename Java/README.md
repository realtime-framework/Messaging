## The Realtime Framework Pub/Sub messaging system
Part of the [The Realtime® Framework](http://www.realtime.co/solutions/realtimeframework), ORTC (Open Realtime Connectivity) is a secure, fast and highly scalable cloud-hosted Pub/Sub real-time messaging system for web and mobile apps.

If your website or mobile app has data that needs to be updated in the user’s interface as it changes (e.g. real-time stock quotes or ever changing social news feed) ORTC is the reliable, easy, unbelievably fast, “works everywhere” solution.

## The Java sample app
This sample app uses the Realtime® Framework Pub/Sub Java library to connect, send and receive messages through a Realtime® Server in the cloud.

![ScreenShot](http://ortc.xrtml.org/screenshots/2.1.0/Java/Screen.jpg)

## Running the sample

	mkdir bin
    javac -d ./bin ./src/JavaTest/integration/IntegrationTest.java -cp ./libs/ortc-java-2.1.20.jar
    java -cp ./libs/ortc-java-2.1.20.jar:./bin/ JavaTest.integration.IntegrationTest

> NOTE: For simplicity these samples assume you're using a Realtime® Framework developers' application key with the authentication service disabled (every connection will have permission to publish and subscribe to any channel). For security guidelines please refer to the [Security Guide](http://messaging-public.realtime.co/documentation/starting-guide/security.html). 
> 
> **Don't forget to replace `YOUR_APPLICATION_KEY` and `YOUR_APPLICATION_PRIVATE_KEY` with your own application key. If you don't already own a free Realtime® Framework application key, [get one now](https://app.realtime.co/developers/getlicense).**


## Documentation
The complete Realtime® Framework Pub/Sub reference documentation is available [here](http://framework.realtime.co/messaging/#documentation)