<h1>Cordova Push Notifications for iOS</h1>
<h2> (using Realtime Messaging)</h2>


<h2>Description</h2>

This Cordova plugin should be used with the iOS platform together with the Realtime Messaging library (ORTC) for Push Notifications support.  

<h3>Important</h3>
Push Notifications only work in real devices (not on simulator).

<hr/>
<h3>Contents</h3>

<ul>
	<li><a ref='pc'>Project configuration</a></li>
	<li><a ref='Mi'>Manual instalation</a></li>
	<li><a ref='api'>API reference</a></li>
	<li><a ref='ue'>Usage examples</a></li>
	<li><a ref='te'>Testing the custom push notifications delivery</a></li>
</ul> 

<hr/>
<h2 id='pc'>Project configuration</h2>
<h3 id='pd'>Plugin dependencies</h3>
<ul>
	<li>iOS Realtime Messaging (ORTC) SDK: <a href='http://messaging-public.realtime.co/api/download/ios/2.1.0/ApiiOS.zip'>download</a></li>
	<li>SocketRocket library: <a href='https://github.com/square/SocketRocket'>GitHub repo</a></li>
</ul>

<h3 id='pd'>Step by step</h3>
<ol>

	<li><h5>Add the plugin using the Cordova CLI</h5>
	<pre><code>cordova plugin add co.realtime.plugins.cordovapush</code></pre>
	</li>
	<p></p>

	<li><h5>Add libOrtcClient.a to your project</h5>
	After downloading the iOS ORTC SDK, move the folder ApiiOS to your project root folder and drag the libOrtcClient.a to your project framework group.</li>
	<p></p>

	<li><h5>Add SocketRocket to your project</h5>
	After downloading the SocketRocket from GitHub, move the folder to your project root folder and drag it to your project framework group.</li>
	<p></p>

	<li><h5>Link binary libraries</h5>
	Link the following binary libraries into your XCODE project build phases</li>
	<ul>
		<li>libicucore.dylib</li>
		<li>CFNetwork.framework</li>
		<li>Security.framework</li>
	</ul>
	<p></p>

	<li><h5>Set libraries headers path</h5>
	On your XCODE project you need to set the path to the libraries headers. On XCODE project build settings look for the section "Header search paths" and add the following paths:</li>
	<p></p>

	<ul>
		<li>"$(PROJECT_DIR)/ApiiOS/include"</li>
		<li>"$(PROJECT_DIR)/CordovaLib/Classes"</li>
	</ul>
	<p></p>

	<li><h5>Configure the AppDelegate in your Cordova application</h5>
		<ul>
			<li>Add the RealtimeCordovaDelegate import and make sure that AppDelegate extends this class. 
<pre><code>#import "RealtimeCordovaDelegate.h"
@interface AppDelegate : RealtimeCordovaDelegate <UIApplicationDelegate>{}
</code></pre>
			</li>

			<li>Now you must call super from AppDelegate override methods. 
<pre><code>- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    <b>[super application:application didFinishLaunchingWithOptions:launchOptions];</b>
	/*
	.
	.
	*/    
}


- (void) application:(UIApplication *)application
   didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    <b>[super application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];</b>
	/*
	.
	.
	*/
}

- (void) application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    <b>[super application:application didFailToRegisterForRemoteNotificationsWithError:error];</b>
    	/*
	.
	.
	*/
}
</code></pre>
			</li>

			<li><h5>Generate the APNS certificates for push notification on the Apple Developer Center</h5>
			<a href='http://messaging-public.realtime.co/documentation/starting-guide/mobilePushAPNS.html'>Follow the iOS Push Notifications tutorial</a>
			</li>
			<p></p>

			<li><h5>Build and run the app in an iOS device</h5>
			NOTE: The Push Notifications won't work on the simulators, only on actual devices.
			</li>
			
		</ul>
	</li>
	<ul>
</ol>



<hr/>
<h2 id='Mi'>Manual plugin instalation</h2>
<p>Copy the following files to your project</p>

<pre><code>RealtimeCordovaDelegate.h
RealtimeCordovaDelegate.m
OrtcPushPlugin.h
OrtcPushPlugin.m
</code></pre>

<p>Add a reference for this plugin to the plugins section in config.xml:</p>

<pre><span class="nt">&lt;feature</span> <span class="na">name=</span><span class="s">"OrtcPushPlugin"</span><span class="nt">&gt;</span>
  <span class="nt">&lt;param</span> <span class="na">name=</span><span class="s">"ios-package"</span> <span class="na">value=</span><span class="s">"OrtcPushPlugin"</span> <span class="nt">/&gt;</span>
<span class="nt">&lt;/feature&gt;</span>
</pre>

<p>Add the OrtcPlugin.js script to your assets/www folder (or javascripts folder, wherever you want really) and reference it in your main index.html file.</p>

<pre><span class="nt">&lt;script </span><span class="na">type=</span><span class="s">"text/javascript"</span> <span class="na">charset=</span><span class="s">"utf-8"</span> <span class="na">src=</span><span class="s">"OrtcPlugin.js"</span><span class="nt">&gt;&lt;/script&gt;</span>
</pre>

<hr/>
<h2 id='api'>API reference</h2>
<h3>Plugin</h3>
<hr/>
<ul>
	<li><h4>checkForNotifications(callback())</h4><p>This method is used to verify push notifications on buffer on the native code from the javascript interface.
	<ul>
		<li>callback() - is triggered after iOS native finishes processing.</li>
	</ul>
	</p></li>
	<li><h4>connect(config, successCallback(), errorCallback())</h4><p>This method is used to establish the ORTC connection.
	<ul>
		<li>config - is an array to specify ['APP_KEY', 'TOKEN', 'METADATA', 'SERVER URL']</li>
		<li>successCallback() - this function is call when connection is establih.</li>
		<li>errorCallback() - this function is call when connection error exist.</li>
	</ul>
	</p></li>
	<li><p><h4>disconnect(callback())</h4><p>This method is used to disconnect the ORTC connection.</p>
		<ul>
			<li>callback() - is triggered after connection is disconnected.</li>
		</ul>
	</p></li>
	<li><h4>subscribe(channel, callback())</h4>
	<p>
		Subscribe a channel.
		<ul>
			<li>channel - is the channel name to subscribe.</li>
			<li>callback() - is triggered after channel is subscribed.</li>
		</ul>
	</p></li>
	<li><p><h4>unsubscribe(channel,callback())</h4><p>This method is used to unsubscribe a channel previously subcribed.</p>
		<ul>
			<li>channel - is the channel name to unsubscribe.</li>
			<li>callback() - is triggered after channel is unsubscribed.</li>
		</ul>
	</p></li>
	<li><p><h4>setApplicationIconBadgeNumber(badge,callback())</h4><p>This method is used to set the application badge number.</p>
		<ul>
			<li>badge - the number to appear on the bage.</li>
			<li>callback() - is triggered after iOS native code finishes.</li>
		</ul>
	</p></li>
	<li><p><h4>cancelAllLocalNotifications(callback())</h4><p>This method is used to clear notifications from notification center.</p>
		<ul>
			<li>callback() - is triggered after iOS native code finishes.</li>
		</ul>
	</p></li>
	<li><p><h4>log(logString)</h4><p>This is a handy method to log data into XCODE console from the javascript code.</p>
		<ul>
			<li>logString - is the string to be logged into the console.</li>
		</ul>
	</p></li>
</ul> 
<h2 id='ue'>Usage example</h2>
<hr/>

<pre><code>

//Establish connection with ORTC server and subscribe the channel entered in the input text box on the HTML interface.

function subscribe()
{
	if(window.plugins && window.plugins.OrtcPushPlugin)
	{
    	var OrtcPushPlugin = window.plugins.OrtcPushPlugin;
        OrtcPushPlugin.log("OnConnect");                     
        OrtcPushPlugin.connect(['INSERT YOUR APP KEY', 'token', 'metadata', 'https://ortc-developers.realtime.co/server/ssl/2.1/'], 
        	function ()
        	{
            	OrtcPushPlugin.log("Connected: ");
                var channel = document.getElementById('channel');
                OrtcPushPlugin.log("Trying to subscribed: " + channel.value);
                OrtcPushPlugin.subscribe(channel.value, 
                	function ()
                	{
                    	var subcribed = document.getElementById('subcribed');
                       subcribed.innerHTML = "subscribed: " + channel.value;
                       OrtcPushPlugin.log("subscribed: " + channel.value);
                       window.plugins.OrtcPushPlugin.disconnect(
                       		function()
                       		{
                       			alert('disconnect')
                       		});
                       	clear();
                   });
             });
        }
};


//Catch the push-notification event when a new notification is received (or tapped by the user)
//Shows the extra property of push notification payload (can be customized using the Realtime Custom Push REST endpoint)

document.addEventListener("push-notification", 
	function(notification)
	{
		window.plugins.OrtcPushPlugin.log("Push-Received  channel: " + notification.channel + " extra: " + notification.payload.extra);
		var payload = document.getElementById('payload');
		payload.innerHTML = "payload: " + notification.payload.extra;
		payload.value = "payload: " + notification.payload.extra;
	}, false);
        
</code></pre>

<h2 id='te'>Testing the custom push notifications delivery</h2>

<p>To test your Push Notifications you need to go through the setup process (see the iOS Push Notifications Starting Guide) and use the Realtime REST API to send a custom push with the following POST to https://ortc-mobilepush.realtime.co/mp/publish</p>

<pre><code>{
   "applicationKey": "[INSERT YOUR APP KEY]",
   "privateKey": "[INSERT YOUR APP PRIVATE KEY]",
   "channel" : "[INSERT CHANNEL TO SEND PUSH]",
   "message" : "[INSERT ALERT TEXT]",
    "payload" : "{
     \"sound\" : \"default\",
     \"badge\" : \"1\",
     \"extra\" : \"[INSERT CUSTOMIZED PAYLOAD]\"
    }"
}
</code></pre>

Have fun pushing!