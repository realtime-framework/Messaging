package 
{	
	import ibt.ortc.plugin.OrtcClient;
	
	import fl.controls.TextInput;
	import fl.controls.TextArea;
	import fl.controls.CheckBox;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class ApiUsageFlash {
		
		var ortcClient:OrtcClient = null;
		
		var txtServer:TextInput;
		var txtAppKey:TextInput;
		var txtAuthToken:TextInput;
		var txtConnMeta:TextInput;
		var txtChannel:TextInput;
		var txtMessage:TextInput;
		var txtLog:TextArea;
		var chkIsCluster:CheckBox;
		
		var txtPostServer:TextInput;
		var txtPostAuthToken:TextInput;
		var txtPostAppKey:TextInput;
		var txtPostPrivateKey:TextInput;
		var txtPostTtl:TextInput;
		var txtPostChannels:TextArea;
		var txtPostPermissions:TextArea;
		var chkPostIsCluster:CheckBox;
		var chkPostAuthTokenIsPrivate:CheckBox;
		
		public function ApiUsageFlash(txtLogInterface:TextArea) {
			txtLog = txtLogInterface;
			
			ortcClient = new OrtcClient();
			
			ortcClient.onConnected = function (ortc:OrtcClient):void
			{
				log("Connected to: " + ortc.url + "...");
			};
			
			ortcClient.onDisconnected = function (ortc:OrtcClient):void
			{
				log("Disconnected");
			};
			
			ortcClient.onSubscribed = function (ortc:OrtcClient, channel:String):void
			{
				log("Subscribed to: " + channel);
			};
			
			ortcClient.onUnsubscribed = function (ortc:OrtcClient, channel:String):void
			{
				log("Unsubscribed from: " + channel);
			};
			
			ortcClient.onException = function (ortc:OrtcClient, error:String):void
			{
				log("Exception: " + error);
			};
			
			ortcClient.onReconnecting = function (ortc:OrtcClient):void
			{
				log("Reconnecting to: " + txtServer.text + "...");
			};
			
			ortcClient.onReconnected = function (ortc:OrtcClient):void
			{
				log("Reconnected to: " + ortc.url + "...");
			};
		}
		
		public function setConnectionFields(txtServerInterface:TextInput, txtAppKeyInterface:TextInput, txtAuthTokenInterface:TextInput, txtConnMetaInterface:TextInput, txtChannelInterface:TextInput, txtMessageInterface:TextInput, chkIsClusterInterface:CheckBox):void
		{
			txtServer = txtServerInterface;
			txtAppKey = txtAppKeyInterface;
			txtAuthToken = txtAuthTokenInterface;
			txtConnMeta = txtConnMetaInterface;
			txtChannel = txtChannelInterface;
			txtMessage = txtMessageInterface;
			chkIsCluster = chkIsClusterInterface;
		}
		
		public function setPostAuthFields(txtPostServerInterface:TextInput, txtPostAuthTokenInterface:TextInput, txtPostAppKeyInterface:TextInput, txtPostPrivateKeyInterface:TextInput, txtPostTtlInterface:TextInput, txtPostChannelsInterface:TextArea, txtPostPermissionsInterface:TextArea, chkPostIsClusterInterface:CheckBox, chkPostAuthTokenIsPrivateInterface:CheckBox):void
		{
			txtPostServer = txtPostServerInterface;
			txtPostAuthToken = txtPostAuthTokenInterface;
			txtPostAppKey = txtPostAppKeyInterface;
			txtPostPrivateKey = txtPostPrivateKeyInterface;
			txtPostTtl = txtPostTtlInterface;
			txtPostChannels = txtPostChannelsInterface;
			txtPostPermissions = txtPostPermissionsInterface;
			chkPostIsCluster = chkPostIsClusterInterface;
			chkPostAuthTokenIsPrivate = chkPostAuthTokenIsPrivateInterface;
		}
		
		public function populatePermissions():void
		{
			txtPostChannels.text = "MyChannel";
			
			txtPostPermissions.text += "w";
		}
		
		public function postPermissions(event:MouseEvent):void
		{
			log("Posting permissions...");
			
			var channelPermissions:Dictionary = new Dictionary();
			
			// Get permissions
			var channels:Array = txtPostChannels.text.split("\r");
			var permissions:Array = txtPostPermissions.text.split("\r");
			
			for (var i:int = 0; i < channels.length; i++) {
				if (channelPermissions[channels[i]] == null) {
					try {
						channelPermissions[channels[i]] = permissions[i];
					}
					catch (ex:Error) {
						channelPermissions[channels[i]] = "r";
					}
				}
			}
			
			try {
				ortcClient.saveAuthentication(txtPostServer.text, chkPostIsCluster.selected, txtPostAuthToken.text, chkPostAuthTokenIsPrivate.selected, txtPostAppKey.text, int(txtPostTtl.text), txtPostPrivateKey.text, channelPermissions, function (result:Boolean):void
				{
					if (result) {
						log("Permissions correctly posted");
					}
					else {
						log("Error posting permissions");
					}
				});
			}
			catch (ex:Error) {
				log("Post permissions exception: " + ex.message);
			}
		}
		
		public function connect(event:MouseEvent):void
		{
			if (chkIsCluster.selected) {
				ortcClient.clusterUrl = txtServer.text;
			}
			else {
				ortcClient.url = txtServer.text;
			}
			
			ortcClient.connectionMetadata = txtConnMeta.text;
			
			log("Connecting to: " + txtServer.text + "...");
			
			ortcClient.connect(txtAppKey.text, txtAuthToken.text);
		}
		
		public function presence(event:MouseEvent):void
		{
			log("Getting presence data...");
			
			ortcClient.presence(txtServer.text,chkIsCluster.selected,txtAppKey.text,txtAuthToken.text,txtChannel.text,function(error:String,data:Object):void {
				if(error != null)
				{
					log("Error getting presence data : " + error);	
				}
				else
				{
					if(data == null)
					{
						log("Unable to get presence data");
					}
					else
					{							
						for(var metadataIndex:String in data["metadata"]){
							log(metadataIndex + " - " + data["metadata"][metadataIndex]);	
						}
						log("Subscriptions : " + data["subscriptions"]);	
					}
				}
			});
		}
		
		public function enablePresence(event:MouseEvent):void
		{
			log("Enabling presence data...");
			
			ortcClient.enablePresence(txtServer.text,chkIsCluster.selected,txtAppKey.text,txtPostPrivateKey.text,txtChannel.text,false,function(error:String,result:String):void {
				if(error != null)
				{
					log("Error enabling presence data : " + error);	
				}
				else
				{
					log(result);	
				}
			});
		}
		
		public function disablePresence(event:MouseEvent):void
		{
			log("Disabling presence data...");
			
			ortcClient.disablePresence(txtServer.text,chkIsCluster.selected,txtAppKey.text,txtPostPrivateKey.text,txtChannel.text,function(error:String,result:String):void {
				if(error != null)
				{
					log("Error disabling presence data : " + error);	
				}
				else
				{
					log(result);	
				}
			});
		}
		
		public function disconnect(event:MouseEvent):void
		{
			log("Disconnecting...");
			
			ortcClient.disconnect();
		}
		
		public function subscribe(event:MouseEvent):void
		{
			log("Subscribing...");
			
			ortcClient.subscribe(txtChannel.text, true, function (ortc:OrtcClient, channel:String, message:String):void
			{
				log("Received at: " + channel + ": " + message);
			});
		}
		
		public function unsubscribe(event:MouseEvent):void
		{
			log("Unsubscribing...");
			
			ortcClient.unsubscribe(txtChannel.text);
		}
		
		public function send(event:MouseEvent):void
		{
			log("Sending: " + txtMessage.text + " to channel " + txtChannel.text);
			
			ortcClient.send(txtChannel.text, txtMessage.text);
		}
		
		public function clearLog(event:MouseEvent):void
		{
			txtLog.text = "";
		}
		
		private function log(text:String):void 
		{
			var dateNow:Date = new Date();
			var hr:Number = dateNow.getHours();
			var mnt:Number = dateNow.getMinutes();
			var sec:Number = dateNow.getSeconds();
			
			txtLog.text = (hr < 10 ? "0" + hr : hr) + ':' + (mnt < 10 ? "0" + mnt : mnt) + ':' + (sec < 10 ? "0" + sec : sec) + ' - ' + text + (txtLog.text != "" ? "\n" : "") + txtLog.text;
		}
	}
}
