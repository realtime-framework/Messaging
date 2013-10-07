#!/usr/bin/python

import ortc

application_key = 'YOUR_APPLICATION_KEY'
authentication_token = 'YourAuthenticationToken'
private_key = 'YOUR_APPLICATION_PRIVATE_KEY'
cluster_url = "http://ortc-developers.realtime.co/server/2.1"

ortc_client = ortc.OrtcClient()

def on_exception(sender, exception):
    print 'ORTC Exception: '+exception

def on_connected(sender):
    print 'ORTC Connected'

def on_disconnected(sender):
    print 'ORTC Disconnected'

def on_message(sender, channel, message):
    print r'ORTC Message ('+channel+'): ' + message
              
def on_subscribed(sender, channel):
    print 'ORTC Subscribed to: '+channel
        
def on_unsubscribed(sender, channel):
    print 'ORTC Unsubscribed from: '+channel

def on_reconnecting(sender):
    print 'ORTC Reconnecting'

def on_reconnected(sender):
    print 'ORTC Reconnected'

def presence_callback(error, result):
    if not error == None:
        print 'ORTC Presence error: ' + error
    else:
        print result


ortc_client.set_on_exception_callback(on_exception)
ortc_client.set_on_connected_callback(on_connected)
ortc_client.set_on_disconnected_callback(on_disconnected)
ortc_client.set_on_subscribed_callback(on_subscribed)
ortc_client.set_on_unsubscribed_callback(on_unsubscribed)
ortc_client.set_on_reconnecting_callback(on_reconnecting)
ortc_client.set_on_reconnected_callback(on_reconnected)

ortc_client.cluster_url = cluster_url
ortc_client.connection_metadata = 'pythonExample'

key = ''
print 'q-quit, 1-Connect, 2-Disconnect, 3-Subscribe, 4-Unsubscribe, 5-Send message, 6-Save authentication, 7-Enable presence, 8-Disable presence, 9-Presence\n'
while not key == 'q':
    key = raw_input('')
    if key == '1':
        ortc_client.connect(application_key, authentication_token)
    if key == '2':
        ortc_client.disconnect()
    if key == '3':
        channel = raw_input('Channel name to subscribe: ')
        ortc_client.subscribe(channel, True, on_message)
    if key == '4':
        channel = raw_input('Channel name to unsubscribe: ')
        ortc_client.unsubscribe(channel)
    if key == '5':
        channel = raw_input('Channel name: ')
        message = raw_input('Message: ')
        ortc_client.send(channel, message)
    if key == '6':
        authentication_token = raw_input('Authentication token: ')
        is_private = raw_input('Is private? (y/n)')
        time_to_live = raw_input('Time to live (sec): ')
        ttl = int(time_to_live)
        private_key = raw_input('Private key: ')
        channels_permissions = {}
        add_channel = 'y'
        while add_channel == 'y':
            channel = raw_input('Channel name: ')
            permission = raw_input('Permission (r/w/p): ')
            channels_permissions[channel] = permission
            add_channel = raw_input('Do you want to add more channels? (y/n): ')
        ret = ortc.save_authentication(cluster_url, True, authentication_token, True if is_private=='y' else False, application_key, ttl, private_key, channels_permissions)
        print 'Success' if ret==True else 'Failed'
    if key == '7':
        channel = raw_input('Channel name: ')
        ortc.enable_presence(cluster_url, True, application_key, private_key, channel, True, presence_callback)
    if key == '8':
        channel = raw_input('Channel name: ')
        ortc.disable_presence(cluster_url, True, application_key, private_key, channel, presence_callback)
    if key == '9':
        channel = raw_input('Channel name: ')
        ortc.presence(cluster_url, True, application_key, authentication_token, channel, presence_callback)

