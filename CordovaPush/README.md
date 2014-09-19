<h1>Ortc push notifications plugin for iOS</h1>
<hr/>
<h2>Desciption</h2>

This plugion is for use with Cordova in iOs platform together with realtime ortc messagin library, it provides communication between javascript and Objective-C.  

<h3>Important</h3>
Push notifications only work in real devices (iPhones, iPads).

<hr/>
<h3>Contents</h3>

<ul>
	<li><a ref='Mi'>Manual instalation</a></li>
	<li><a ref='api'>API reference</a></li>
	<li><a ref='ue'>Usage examples</a></li>
</ul> 


<hr/>
<h2 id='Mi'>Manual instalation</h2>
<p>Copy the following files to your project's</p>

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
	<li><h4>checkForNotifications(callback())</h4><p>This method is used to verify push notifications on buffer on the native code from de the javascript interface.
	<ul>
		<li>callback() - is trigger afether iOS native finish processing.</li>
	</ul>
	</p></li>
	<li><h4>connect(config, successCallback(), errorCallback())</h4><p>This method is used to establish the ortc connection.
	<ul>
		<li>config - is an array to specify ['APP_KEY', 'TOKEN', 'METADATA', 'SERVER URL']</li>
		<li>successCallback() - this function is call when connection is establih.</li>
		<li>errorCallback() - this function is call when connection error exist.</li>
	</ul>
	</p></li>
	<li><p><h4>disconnect(callback())</h4><p>This method is used to kill ortc connection.</p>
		<ul>
			<li>callback() - is trigger afether connection is disconnect.</li>
		</ul>
	</p></li>
	<li><h4>subscribe(channel, callback())</h4>
	<p>
		Subscribe a channel.
		<ul>
			<li>channel - is the channel name to subscribe.</li>
			<li>callback() - is trigger afether channel is subscibed.</li>
		</ul>
	</p></li>
	<li><p><h4>unsubscribe(channel,callback())</h4><p>This method is used to unsubscribe a channel previous subcribed.</p>
		<ul>
			<li>channel - is the channel name to subscribe.</li>
			<li>callback() - is trigger afether channel is unsubscibed.</li>
		</ul>
	</p></li>
	<li><p><h4>setApplicationIconBadgeNumber(badge,callback())</h4><p>This method is used to set application bage number.</p>
		<ul>
			<li>badge - is the number to appear on the bage.</li>
			<li>callback() - is trigger afether iOS native code finish.</li>
		</ul>
	</p></li>
	<li><p><h4>cancelAllLocalNotifications(callback())</h4><p>This method is used to clear notifications from notification center.</p>
		<ul>
			<li>callback() - is trigger afether iOS native code finish.</li>
		</ul>
	</p></li>
	<li><p><h4>log(logString)</h4><p>This method is used to log data in XCODE console from the javascript code.</p>
		<ul>
			<li>logString - is the string to be loged in the console.</li>
		</ul>
	</p></li>
</ul> 
<h2 id='ue'>Usage example</h2>
<hr/>

<pre><code>

//Establish connection with ortc and subscribe channel in input text box on the HTML interface.
function subscribe()
{
	if(window.plugins && window.plugins.OrtcPushPlugin)
	{
    	var OrtcPushPlugin = window.plugins.OrtcPushPlugin;
        OrtcPushPlugin.log("OnConnect");                     
        OrtcPushPlugin.connect(['INSERT APP KEY', 'token', 'metadata', 'https://ortc-developers.realtime.co/server/ssl/2.1/'], 
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


//Catch push-notification trigger from iOS native code.
document.addEventListener("push-notification", 
	function(notification)
	{
		window.plugins.OrtcPushPlugin.log("Push-Received  channel: " + notification.channel + " extra: " + notification.payload.extra);
		var payload = document.getElementById('payload');
		payload.innerHTML = "payload: " + notification.payload.extra;
		payload.value = "payload: " + notification.payload.extra;
	}, false);
        
</code></pre>
