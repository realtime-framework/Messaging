//
//  MasterViewController.m
//  OrtcClient_MacUsage
//
//  Created by iOSdev on 11/25/13.
//  Copyright (c) 2013 Realtime.co. All rights reserved.
//

#import "MasterViewController.h"


#warning SET CONSTANTS

#define SERVER @"http://ortc-developers.realtime.co/server/2.1"
#define AUTH_TOKEN @"__AUTH_TOKEN__"
#define APP_KEY @"__YOUR_APP_KEY__"
#define CONNECTION_METADATA @"__CONNECTION_METADATA__"
#define ISCLUSTER 1


@interface MasterViewController ()

@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void) loadView {
	
	[super loadView];
	
	[_logTxtView setEditable:NO];
	
	_serverTxtField.stringValue = SERVER;
	_authenticationTxtField.stringValue = AUTH_TOKEN;
	_connMetaDataTxtField.stringValue = CONNECTION_METADATA;
	_appKeyTxtField.stringValue = APP_KEY;
	
	_channelTxtField.stringValue = @"yellow";
	_isChannelSubTxtField.stringValue = @"yellow";
	_messageTxtView.string = @"This is a Message from Mac App";
	
	// Instantiate OrtcClient
	_ortcClient = [OrtcClient ortcClientWithConfig:self];
	
}


- (IBAction)checkSubscription:(id)sender {
	NSLog(@"checkSubscription");
	NSNumber* result = [_ortcClient isSubscribed:_isChannelSubTxtField.stringValue];
    
    if (result == [NSNumber numberWithBool:YES]) {
        [self log:[NSString stringWithFormat:@"YES, subscribed to: %@", _isChannelSubTxtField.stringValue]];
    }
    else if (result == [NSNumber numberWithBool:NO]) {
        [self log:[NSString stringWithFormat:@"NOT subscribed to:  %@", _isChannelSubTxtField.stringValue]];
    }
}

- (IBAction)connect:(id)sender {
	NSLog(@"connect");
	
	[_ortcClient setConnectionMetadata:_connMetaDataTxtField.stringValue];
    //[ortcClient setConnectionTimeout:10];
    
    if ([_isClusterCheck state]==NSOnState) {
        [_ortcClient setClusterUrl:_serverTxtField.stringValue];
    }
    else {
        [_ortcClient setUrl:_serverTxtField.stringValue];
    }
    
    [self log:[NSString stringWithFormat:@"Connecting to: %@", _serverTxtField.stringValue]];
    
    [_ortcClient connect:_appKeyTxtField.stringValue authenticationToken:_authenticationTxtField.stringValue];
}

- (IBAction)subscribe:(id)sender {
	
	[self log:[NSString stringWithFormat:@"Subscribing to: %@...", _channelTxtField.stringValue]];
    
    MasterViewController* weakSelf = self;
    
    onMessage = ^(OrtcClient* ortc, NSString* channel, NSString* message) {
        [weakSelf log:[NSString stringWithFormat:@"Received at %@: %@", channel, message]];
    };
    
    [_ortcClient subscribe:_channelTxtField.stringValue subscribeOnReconnected:YES onMessage:onMessage];
}

- (IBAction)sendMessage:(id)sender {
	
	[self log:[NSString stringWithFormat:@"Send: %@ to %@", _messageTxtView.string, _channelTxtField.stringValue]];
    
    [_ortcClient send:_channelTxtField.stringValue message:_messageTxtView.string];
}

- (IBAction)disconnect:(id)sender {
	
    [self log:[NSString stringWithFormat:@"Disconnecting..."]];
    [_ortcClient disconnect];
}

- (IBAction)unsubscribe:(id)sender {
	
	[self log:[NSString stringWithFormat:@"Unsubscribing from: %@...", _channelTxtField.stringValue]];
    [_ortcClient unsubscribe:_channelTxtField.stringValue];
}

- (IBAction)clearLog:(id)sender {
	_logTxtView.string = @"";
}



#pragma mark ORTC callbacks

- (void) onConnected:(OrtcClient*) ortc
{
    [self log:[NSString stringWithFormat:@"Connected to: %@", ortc.url]];
    [self log:[NSString stringWithFormat:@"Session Id: %@", ortc.sessionId]];
}

- (void) onDisconnected:(OrtcClient*) ortc
{
    [self log:@"Disconnected"];
}

- (void) onReconnecting:(OrtcClient*) ortc
{
    [self log:[NSString stringWithFormat:@"Reconnecting to: %@", ortc.url]];
}

- (void) onReconnected:(OrtcClient*) ortc
{
    [self log:[NSString stringWithFormat:@"Reconnected to: %@", ortc.url]];
}

- (void) onSubscribed:(OrtcClient*) ortc channel:(NSString*) channel
{
    [self log:[NSString stringWithFormat:@"Subscribed to: %@", channel]];
}

- (void) onUnsubscribed:(OrtcClient*) ortc channel:(NSString*) channel
{
    [self log:[NSString stringWithFormat:@"Unsubscribed from: %@", channel]];
}

- (void) onException:(OrtcClient*) ortc error:(NSError*) error
{
    [self log:[NSString stringWithFormat:@"Exception: %@", error.localizedDescription]];
}


#pragma mark ORTC Private methods

- (NSString*) getHour
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *dateString = [dateFormat stringFromDate:now];
    
    return dateString;
}


- (void) log:(NSString*) text
{
	//NSLog(@"LOG: %@ - %@", [self getHour], text);
	_logTxtView.string = [[self getHour] stringByAppendingString:[@" - " stringByAppendingString:[text stringByAppendingString:[@"\n" stringByAppendingString:_logTxtView.string]]]];
}

@end



