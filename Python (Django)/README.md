## The Realtime Framework Cloud Messaging
Part of the [The Realtime® Framework](http://framework.realtime.co/messaging), Realtime Cloud Messaging is a secure, fast and highly scalable cloud-hosted Pub/Sub real-time messaging system for web and mobile apps.

If your website or mobile app has data that needs to be updated in the user’s interface as it changes (e.g. real-time stock quotes or ever changing social news feed) Realtime Cloud Messaging is the reliable, easy, unbelievably fast, “works everywhere” solution.

## The Django example
This example uses the Realtime Cloud Messaging Python SDK to connect, send and receive messages through a Realtime® Server in the cloud.

This example follows the Django [tutorial](https://www.google.com/url?q=https%3A%2F%2Fdocs.djangoproject.com%2Fen%2F1.6%2Fintro%2Ftutorial01%2F&sa=D&sntz=1&usg=AFQjCNFEqS20_DlAT2OH5hpOnHLxg-9Ufg) for a poll application. 

Each time a user votes, a notification is issued from the server and all users watching that specific poll result page will see the votes being updated.

The Realtime Cloud Messaging Python SDK was use on the server side and the JavaScript SDK for the client side. The server Messaging code is found in the file polls/models.py and polls/views. The client code is in polls/templates/polls/results.html.


> NOTE: For simplicity these samples assume you're using a Realtime® Framework developers' application key with the authentication service disabled (every connection will have permission to publish and subscribe to any channel). For security guidelines please refer to the [Security Guide](http://messaging-public.realtime.co/documentation/starting-guide/security.html). 
> 
> **Don't forget to replace `YOUR_APPLICATION_KEY` and `YOUR_APPLICATION_PRIVATE_KEY` with your own application key. If you don't already own a free Realtime® Framework application key, [get one now](https://app.realtime.co/developers/getlicense).**


## Documentation
The complete Realtime Cloud Messaging reference documentation is available [here](http://framework.realtime.co/messaging/#documentation)