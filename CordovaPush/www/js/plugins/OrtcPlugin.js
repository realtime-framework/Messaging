(function(cordova) {
 
 function OrtcPushPlugin() {}
 
 
 OrtcPushPlugin.prototype.checkForNotifications = function(success) {
 cordova.exec(success, success, "OrtcPushPlugin", "checkForNotifications", []);
 };
 
 
 OrtcPushPlugin.prototype.connect = function(config, success, error) {
 cordova.exec(success, error, "OrtcPushPlugin", "connect", config ? [config] : []);
 };
 
 OrtcPushPlugin.prototype.disconnect = function(success) {
 cordova.exec(success, success, "OrtcPushPlugin", "disconnect", []);
 };
 
 OrtcPushPlugin.prototype.subscribe = function(config, success) {
 cordova.exec(success, success, "OrtcPushPlugin", "subscribe", config ? [config] : []);
 };
 
 
 OrtcPushPlugin.prototype.unsubscribe = function(config, success) {
 cordova.exec(success, success, "OrtcPushPlugin", "unsubscribe", config ? [config] : []);
 };
 
 OrtcPushPlugin.prototype.setApplicationIconBadgeNumber = function(badge, callback) {
 cordova.exec(callback, callback, "OrtcPushPlugin", "setApplicationIconBadgeNumber", [badge]);
 };
 
 // Call this to clear all notifications from the notification center
 OrtcPushPlugin.prototype.cancelAllLocalNotifications = function(callback) {
 cordova.exec(callback, callback, "OrtcPushPlugin", "cancelAllLocalNotifications", []);
 };
 
 OrtcPushPlugin.prototype.log = function(log) {
 cordova.exec(null, null, "OrtcPushPlugin", "log", log ? [log] : []);
 };
 
 OrtcPushPlugin.prototype.receiveRemoteNotification = function(channel, payload) {
 var ev = document.createEvent('HTMLEvents');
 ev.channel = channel;
 ev.payload = payload;
 ev.initEvent('push-notification', true, true, arguments);
 document.dispatchEvent(ev);
 };
 
 cordova.addConstructor(function() {
                        if(!window.plugins) window.plugins = {};
                        window.plugins.OrtcPushPlugin = new OrtcPushPlugin();
                        });
 
 })(window.cordova || window.Cordova || window.PhoneGap);
 
 
 // call when device is ready
 document.addEventListener("deviceready", function () {
                           if(window.plugins && window.plugins.OrtcPushPlugin){
                           var OrtcPushPlugin = window.plugins.OrtcPushPlugin;
                           OrtcPushPlugin.checkForNotifications();

                           }
                           });
 
 
 // call when app resumes
 document.addEventListener("resume", function () {
                           if(window.plugins && window.plugins.OrtcPushPlugin){
                           var OrtcPushPlugin = window.plugins.OrtcPushPlugin;
                           OrtcPushPlugin.checkForNotifications();
                           }
                           });
