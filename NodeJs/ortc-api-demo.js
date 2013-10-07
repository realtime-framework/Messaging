var OrtcNodeclient = require('ibtrealtimesjnode').IbtRealTimeSJNode;

var connectionUrl = 'http://ortc-developers.realtime.co/server/2.1';

var appKey = 'YOUR_APPLICATION_KEY';
var authToken = 'AUTHENTICATION_TOKEN';
var channel = 'MyChannel';
var privateKey = 'YOUR_APPLICATION_PRIVATE_KEY';
var isCluster = true;
var authenticationRequired = false;

var client = new OrtcNodeclient();

var countMsgChannel = 0;

/***********************************************************
* Client sets
***********************************************************/

client.setClusterUrl(connectionUrl);

client.setConnectionMetadata('UserConnectionMetadata');

/***********************************************************
* Client callbacks
***********************************************************/

client.onConnected = clientConnected;
client.onSubscribed = clientSubscribed;
client.onUnsubscribed = clientUnsubscribed;
client.onReconnecting = clientReconnecting;
client.onReconnected = clientReconnected;
client.onDisconnected = clientDisconnected;
client.onException = clientException;

/***********************************************************
* Client methods
***********************************************************/

if(authenticationRequired){
	// Enable presence data for MyChannel
	client.enablePresence({
		applicationKey : appKey,
		channel : channel, 
		privateKey : privateKey, 
		url : connectionUrl,
		isCluster : isCluster,
		metadata : 1
	},
	function(error,result){
		if(error){
			log('Enable presence error: ' + error);  
		}else{
			log('Presence enable: ' + result);              
		}
	});
}	

function clientConnected(ortc) {
    log('Connected to: ' + ortc.getUrl());
    log('Subscribe to channel: ' + channel);


    setTimeout(function(){
		// Get presence data for MyChannel
		log('Retrieving presence data for channel: ' + channel);
        client.presence({
            authenticationToken : authToken,
            applicationKey : appKey,
            channel : channel,  
            url : connectionUrl,
            isCluster : isCluster
        },
        function(error,result){
            if(error){
                console.log('Presence error:',error);
            }else{
                if(result){
                    console.log('Subscriptions',result.subscriptions);  

                    for(var metadata in result.metadata){
                        console.log(metadata,'-',result.metadata[metadata]);                                    
                    }
                }else{
                    console.log('Subscriptions empty'); 
                }                           
            }
        }); 
    },15 * 1000);

    // Subscribe channel
    ortc.subscribe(channel, true, function onMessage(ortc, channel, message) {
        countMsgChannel++;

        log('Received (' + countMsgChannel + '): ' + message + ' at channel: ' + channel);
    });
};

function clientSubscribed(ortc, channel) {
    log('Subscribed to channel: ' + channel);
};

function clientUnsubscribed(ortc, channel) {
    log('Unsubscribed from channel: ' + channel);
};

function clientReconnecting(ortc) {
    log('Reconnecting to ' + connectionUrl);
};

function clientReconnected(ortc) {
    log('Reconnected to: ' + ortc.getUrl());
};

function clientDisconnected(ortc) {
    log('Disconnected');
};

function clientException(ortc, error) {
    log('Error: ' + error);
};

/***********************************************************
* Aux methods
***********************************************************/

function log(text, isSameLine) {
    if (text) {
        var currTime = new Date();

        text = currTime + ' - ' + text;
    }

    if (isSameLine) {
        process.stdout.write(text);
    }
    else {
        console.log(text);
    }
};

if(authenticationRequired){
	log('Authenticating to ' + connectionUrl);
		
	var permissions = {};
	// Give permission to read, write and obtain presence data
	permissions[channel] = 'wrp';

	// Authenticate the user token 
	client.saveAuthentication(connectionUrl,isCluster,authToken,false,appKey,1800,privateKey,permissions,function(error,result){
		if(error){
			log('Authentication Error: ' + error);
		}else{
			log('Authenticated to ' + connectionUrl);
			log('Connecting to ' + connectionUrl);
			// Connect to the Realtime Framework cluster
			client.connect(appKey, authToken);
		}
	});
}else{
	log('Connecting to ' + connectionUrl);
	// Connect to the Realtime Framework cluster
	client.connect(appKey, authToken);
}



// Send a message to the subscribed channel every 5 seconds
var sendInterval = setInterval(function sendMessage() {
    if (client.getIsConnected() == true) {
        var message = 'Hello world!';
		
        client.send(channel, message);
		log('Sending: ' + message + ' to channel: ' + channel);
    }
}, 1000);
