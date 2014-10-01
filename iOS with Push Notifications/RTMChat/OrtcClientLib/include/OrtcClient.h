
//
//  OrtcClient.h
//  OrtcClient
//
//  Created by Rafael Cabral on 2/2/12.
//  Copyright (c) 2012 IBT. All rights reserved.
//

#ifndef OrtcClient_OrtcClient_h
#define OrtcClient_OrtcClient_h

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

#define heartbeatDefaultTime 15 // Heartbeat default interval time
#define heartbeatDefaultFails 3 // Heartbeat default max fails

#define heartbeatMaxTime 60
#define heartbeatMinTime 10

#define heartbeatMaxFails 6
#define heartbeatMinFails 1

@class OrtcClient;

@protocol OrtcClientDelegate <NSObject>

///---------------------------------------------------------------------------------------
/// @name Instance Methods
///--------------------------------------------------------------------------------------
/**
 * Occurs when the client connects.
 *
 * @param ortc The ORTC object.
 */
- (void)onConnected:(OrtcClient*) ortc;
/**
 * Occurs when the client disconnects.
 *
 * @param ortc The ORTC object.
 */
- (void)onDisconnected:(OrtcClient*) ortc;
/**
 * Occurs when the client subscribes to a channel.
 *
 * @param ortc The ORTC object.
 * @param channel The channel name.
 */
- (void)onSubscribed:(OrtcClient*) ortc channel:(NSString*) channel;
/**
 * Occurs when the client unsubscribes from a channel.
 *
 * @param ortc The ORTC object.
 * @param channel The channel name.
 */
- (void)onUnsubscribed:(OrtcClient*) ortc channel:(NSString*) channel;
/**
 * Occurs when there is an exception.
 *
 * @param ortc The ORTC object.
 * @param error The occurred exception.
 */
- (void)onException:(OrtcClient*) ortc error:(NSError*) error;
/**
 * Occurs when the client attempts to reconnect.
 *
 * @param ortc The ORTC object.
 */
- (void)onReconnecting:(OrtcClient*) ortc;
/**
 * Occurs when the client reconnects.
 *
 * @param ortc The ORTC object.
 */
- (void)onReconnected:(OrtcClient*) ortc;
/**
 * Occurs when the client enables presence.
 *
 * @param error Description of error if occurs.
 * @param result Result of enablePresence
 */
//- (void)onEnablePresence:(NSError*) error result:(NSString*) result;


@end

/**
 
 OrtcClient Usage - Code Example
 
 - ViewController.h
 <pre><code>
 #import "OrtcClient.h"
 @interface ViewController : UIViewController <OrtcClientDelegate>
 {
 @private
 
    OrtcClient* ortcClient;
    void (^onMessage)(OrtcClient* ortc, NSString* channel, NSString* message);
    // ...
 }
 // ...
 @end
 
 </pre></code>

 
 
- ViewController.m
 
 <pre><code>
 #import "ViewController.h"
 @implementation ViewController
 
 - (void)viewDidLoad
 {
    [super viewDidLoad];
    
    // Instantiate OrtcClient
    ortcClient = [OrtcClient ortcClientWithConfig:self];
    
    // Post permissions
    @try {
        NSMutableDictionary* myPermissions = [[NSMutableDictionary alloc] init];
        
        [myPermissions setObject:@"w" forKey:@"channel1"];
        [myPermissions setObject:@"w" forKey:@"channel2"];
        [myPermissions setObject:@"r" forKey:@"channelread"];
        
        BOOL postResult = [ortcClient saveAuthentication:@"http://ortc_server"
                            isCLuster:YES authenticationToken:@"myAuthenticationToken"
                            authenticationTokenIsPrivate:NO applicationKey:@"myApplicationKey"
                            timeToLive:1800 privateKey:@"myPrivateKey" permissions:myPermissions];
        
        if (postResult) {
            // Permissions correctly posted
        }
        else {
            // Unable to post permissions
        }
    }
    @catch (NSException* exception) {
        // Exception posting permissions
    }
    
    // Set connection properties
    [ortcClient setConnectionMetadata:@"clientConnMeta"];
    [ortcClient setClusterUrl:@"http://ortc_server"];
    
    // Connect
    [ortcClient connect:@"myApplicationKey" authenticationToken:@"myAuthenticationToken"];
 }
 
 - (void) onConnected:(OrtcClient*) ortc
 {
    // Connected
    onMessage = ^(OrtcClient* ortc, NSString* channel, NSString* message) {
    // Received message 'message' at channel 'channel'
        [ortcClient unsubscribe:channel];
    };
    
    [ortcClient subscribe:@"channel1" subscribeOnReconnected:YES onMessage:onMessage];
    [ortcClient subscribe:@"channel2" subscribeOnReconnected:NO onMessage:onMessage];
    [ortcClient subscribeWithNotifications:@"channel3" subscribeOnReconnected:YES onMessage:onMessage];
}

 - (void) onDisconnected:(OrtcClient*) ortc
 {
    // Disconnected
 }

 - (void) onReconnecting:(OrtcClient*) ortc
 {
    // Trying to reconnect
 }
 
 - (void) onReconnected:(OrtcClient*) ortc
 {
    // Reconnected
 }
 
 - (void) onSubscribed:(OrtcClient*) ortc channel:(NSString*) channel
 {
    // Subscribed to the channel 'channel'
    [ortcClient send:channel message:@"Message to the channel"];
 }

 - (void) onUnsubscribed:(OrtcClient*) ortc channel:(NSString*) channel
 {
    // Unsubscribed from the channel 'channel'
    [ortcClient disconnect];
 }

 - (void) onException:(OrtcClient*) ortc error:(NSError*) error
 {
    // Exception occurred
 }

 @end
 </pre></code>
*/



@interface OrtcClient : NSObject <SRWebSocketDelegate>

///---------------------------------------------------------------------------------------
/// @name Properties
///---------------------------------------------------------------------------------------
@property (nonatomic, retain) NSString* id;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* clusterUrl;
@property (nonatomic, retain) NSString* connectionMetadata;
@property (nonatomic, retain) NSString* announcementSubChannel;
@property (nonatomic, retain) NSString* sessionId;
@property (assign) int connectionTimeout;
@property (assign) BOOL isConnected;


///---------------------------------------------------------------------------------------
/// @name Class Methods
///---------------------------------------------------------------------------------------
/**
 * Initializes a new instance of the ORTC class.
 *
 * @param delegate The object holding the ORTC callbacks, usually 'self'.
 *
 * @return New instance of the ORTC class.
 */

+ (id)ortcClientWithConfig:(id<OrtcClientDelegate>) delegate;


///---------------------------------------------------------------------------------------
/// @name Instance Methods
///---------------------------------------------------------------------------------------
/**
 * Connects with the application key and authentication token.
 *
 * @param applicationKey The application key.
 * @param authenticationToken The authentication token.
 */
- (void)connect:(NSString*) applicationKey authenticationToken:(NSString*) authenticationToken;
/**
 * Sends a message to a channel.
 *
 * @param channel The channel name.
 * @param message The message to send.
 */
- (void)send:(NSString*) channel message:(NSString*) message;
/**
 * Subscribes to a channel to receive messages sent to it.
 *
 * @param channel The channel name.
 * @param subscribeOnReconnected Indicates whether the client should subscribe to the channel when reconnected (if it was previously subscribed when connected).
 * @param onMessage The callback called when a message arrives at the channel.
 */
- (void)subscribe:(NSString*) channel subscribeOnReconnected:(BOOL) aSubscribeOnReconnected onMessage:(void (^)(OrtcClient* ortc, NSString* channel, NSString* message)) onMessage;

/**
 * Subscribes to a channel, with Push Notifications Service, to receive messages sent to it.
 *
 * @param channel The channel name. Only channels with alphanumeric name and the following characters: "_" "-" ":" are allowed.
 * @param subscribeOnReconnected Indicates whether the client should subscribe to the channel when reconnected (if it was previously subscribed when connected).
 * @param onMessage The callback called when a message or a Push Notification arrives at the channel.
 */
- (void)subscribeWithNotifications:(NSString*) channel subscribeOnReconnected:(BOOL) aSubscribeOnReconnected onMessage:(void (^)(OrtcClient* ortc, NSString* channel, NSString* message)) onMessage;

/**
 * Unsubscribes from a channel to stop receiving messages sent to it.
 *
 * @param channel The channel name.
 */
- (void)unsubscribe:(NSString*) channel;
/**
 * Disconnects.
 */
- (void)disconnect;
/**
 * Indicates whether is subscribed to a channel or not.
 *
 * @param channel The channel name.
 *
 * @return TRUE if subscribed to the channel or FALSE if not.
 */
- (NSNumber*)isSubscribed:(NSString*) channel;

/** Saves the channels and its permissions for the authentication token in the ORTC server.
 @warning This function will send your private key over the internet. Make sure to use secure connection.
 @param url ORTC server URL.
 @param isCluster Indicates whether the ORTC server is in a cluster.
 @param authenticationToken The authentication token generated by an application server (for instance: a unique session ID).
 @param authenticationTokenIsPrivate Indicates whether the authentication token is private (1) or not (0).
 @param applicationKey The application key provided together with the ORTC service purchasing.
 @param timeToLive The authentication token time to live (TTL), in other words, the allowed activity time (in seconds).
 @param privateKey The private key provided together with the ORTC service purchasing.
 @param permissions The channels and their permissions (w: write, r: read, p: presence, case sensitive).
 @return TRUE if the authentication was successful or FALSE if it was not.
 */
- (BOOL)saveAuthentication:(NSString*) url isCLuster:(BOOL) isCluster authenticationToken:(NSString*) authenticationToken authenticationTokenIsPrivate:(BOOL) authenticationTokenIsPrivate applicationKey:(NSString*) applicationKey timeToLive:(int) timeToLive privateKey:(NSString*) privateKey permissions:(NSMutableDictionary*) permissions;

/** Enables presence for the specified channel with first 100 unique metadata if true.
 
 @warning This function will send your private key over the internet. Make sure to use secure connection.
 @param url Server containing the presence service.
 @param isCluster Specifies if url is cluster.
 @param applicationKey Application key with access to presence service.
 @param privateKey The private key provided when the ORTC service is purchased.
 @param channel Channel with presence data active.
 @param metadata Defines if to collect first 100 unique metadata.
 @param callback Callback with error (NSError) and result (NSString) parameters
 */
- (void)enablePresence:(NSString*) aUrl isCLuster:(BOOL) aIsCluster applicationKey:(NSString*) aApplicationKey privateKey:(NSString*) aPrivateKey channel:(NSString*) channel metadata:(BOOL) aMetadata callback:(void (^)(NSError* error, NSString* result)) aCallback;

/** Disables presence for the specified channel.
 
 @warning This function will send your private key over the internet. Make sure to use secure connection.
 @param url Server containing the presence service.
 @param isCluster Specifies if url is cluster.
 @param applicationKey Application key with access to presence service.
 @param privateKey The private key provided when the ORTC service is purchased.
 @param channel Channel with presence data active.
 @param callback Callback with error (NSError) and result (NSString) parameters
 */
- (void)disablePresence:(NSString*) aUrl isCLuster:(BOOL) aIsCluster applicationKey:(NSString*) aApplicationKey privateKey:(NSString*) aPrivateKey channel:(NSString*) channel callback:(void (^)(NSError* error, NSString* result)) aCallback;

/**
 * Gets a NSDictionary indicating the subscriptions in the specified channel and if active the first 100 unique metadata.
 *
 * @param url Server containing the presence service.
 * @param isCluster Specifies if url is cluster.
 * @param applicationKey Application key with access to presence service.
 * @param authenticationToken Authentication token with access to presence service.
 * @param channel Channel with presence data active.
 * @param callback Callback with error (NSError) and result (NSDictionary) parameters
 */
- (void)presence:(NSString*) aUrl isCLuster:(BOOL) aIsCluster applicationKey:(NSString*) aApplicationKey authenticationToken:(NSString*) aAuthenticationToken channel:(NSString*) channel callback:(void (^)(NSError* error, NSDictionary* result)) aCallback;

/**
 * Get heartbeat interval.
 */
- (int) getHeartbeatTime;
/**
 * Set heartbeat interval.
 */
- (void) setHeartbeatTime:(int) newHeartbeatTime;
/**
 * Get how many times can the client fail the heartbeat.
 */
- (int) getHeartbeatFails;
/**
 * Set heartbeat fails. Defines how many times can the client fail the heartbeat.
 */
- (void) setHeartbeatFails:(int) newHeartbeatFails;
/**
 * Indicates whether heartbeat is active or not.
 */
- (BOOL) isHeartbeatActive;
/**
 * Enables the client heartbeat
 */
- (void) enableHeartbeat;
/**
 * Disables the client heartbeat
 */
- (void) disableHeartbeat;


+ (void) setDEVICE_TOKEN:(NSString *) deviceToken;
@end


#endif

