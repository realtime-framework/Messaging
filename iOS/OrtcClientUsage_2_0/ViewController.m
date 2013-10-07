//
//  ViewController.m
//  OrtcClientUsage_2_0
//
//  Created by Rafael Cabral on 5/18/12.
//  Copyright (c) 2012 IBT. All rights reserved.
//

#import "ViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize txtServer;
@synthesize txtChannel;
@synthesize txtMessage;
@synthesize txtAuthToken;
@synthesize txtAppKey;
@synthesize txtConnMeta;
@synthesize txtChannelIsSubscribed;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Log
    tvwLog.editable = NO;
    
    // Scroll View
    mainScrollView.layer.borderColor = [UIColor blackColor].CGColor;
    mainScrollView.layer.borderWidth = 1.0;
    [mainScrollView setScrollEnabled:YES];
    [mainScrollView setContentSize:CGSizeMake(320, 355)];
    
    // Scroll View Tap
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.cancelsTouchesInView = NO;
    [mainScrollView addGestureRecognizer:singleTap];
    
    // CheckBox
    chxIsCluster = [[MICheckBox alloc] initWithFrame:CGRectMake(225, 3, 150, 25)];
	chxIsCluster.titleLabel.font = [UIFont systemFontOfSize:13];
    chxIsCluster.isChecked = YES;
    [chxIsCluster setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[chxIsCluster setTitle:@"Is Cluster" forState:UIControlStateNormal];
	[mainScrollView addSubview:chxIsCluster];
    
    utils = [Utils alloc];
    
    // Instantiate OrtcClient
    ortcClient = [OrtcClient ortcClientWithConfig:self];
}

- (void)viewDidUnload
{
    tvwLog = nil;
    txtServer = nil;
    txtChannel = nil;
    txtMessage = nil;
    txtAuthToken = nil;
    txtAppKey = nil;
    txtConnMeta = nil;
    mainScrollView = nil;
    
    [self setTxtChannelIsSubscribed:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark Hide keyboard

- (IBAction)txtReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender
{
    [self resignResponders];
}

- (IBAction)btnGoToAuthentication:(id)sender {
    // Clear previous connection (User changed ViewController and was connected)
    if ([ortcClient isConnected]) {
        [ortcClient disconnect];
    }
}

- (IBAction)btnIsSubscribed:(id)sender {
    NSNumber* result = [ortcClient isSubscribed:txtChannelIsSubscribed.text];
    
    if (result == [NSNumber numberWithBool:YES]) {
        [self log:[NSString stringWithFormat:@"YES", txtChannel.text]];
    }
    else if (result == [NSNumber numberWithBool:NO]) {
        [self log:[NSString stringWithFormat:@"NO", txtChannel.text]];
    }
}

- (void) handleSingleTap:(id*)sender
{
    [self resignResponders];
}

- (void) resignResponders
{
    [txtServer resignFirstResponder];
    [txtAppKey resignFirstResponder];
    [txtAuthToken resignFirstResponder];
    [txtChannel resignFirstResponder];
    [txtConnMeta resignFirstResponder];
    [txtMessage resignFirstResponder];
}

#pragma mark Buttons events

- (IBAction)btnConnect:(id)sender {
    [ortcClient setConnectionMetadata:txtConnMeta.text];
    //[ortcClient setConnectionTimeout:10];
    
    if (chxIsCluster.isChecked) {
        [ortcClient setClusterUrl:txtServer.text];
    }
    else {
        [ortcClient setUrl:txtServer.text];
    }
    
    [self log:[NSString stringWithFormat:@"Connecting to: %@", txtServer.text]];
    
    [ortcClient connect:txtAppKey.text authenticationToken:txtAuthToken.text];
}

- (IBAction)btnSubscribe:(id)sender {
    [self log:[NSString stringWithFormat:@"Subscribing to: %@...", txtChannel.text]];
    
    ViewController* weakSelf = self;
    
    onMessage = ^(OrtcClient* ortc, NSString* channel, NSString* message) {
        [weakSelf log:[NSString stringWithFormat:@"Received at %@: %@", channel, message]];
    };
    
    [ortcClient subscribe:txtChannel.text subscribeOnReconnected:YES onMessage:onMessage];
}

- (IBAction)btnUnsubscribe:(id)sender {
    [self log:[NSString stringWithFormat:@"Unsubscribing from: %@...", txtChannel.text]];
    
    [ortcClient unsubscribe:txtChannel.text];
}

- (IBAction)btnSend:(id)sender {
    [self log:[NSString stringWithFormat:@"Send: %@ to %@", txtMessage.text, txtChannel.text]];
    
    [ortcClient send:txtChannel.text message:txtMessage.text];
}

- (IBAction)btnClearLog:(id)sender {
    tvwLog.text = @"";
}

- (IBAction)btnDisconnect:(id)sender {
    [self log:[NSString stringWithFormat:@"Disconnecting..."]];
    
    [ortcClient disconnect];
}

- (IBAction)btnPresence:(id)sender {
    [self log:[NSString stringWithFormat:@"Presence at channel %@...", txtChannel.text]];
    ViewController* weakSelf = self;
    presenceDictionary = ^(NSError* error, NSDictionary* result){
        if (error == nil){
            [weakSelf log:[NSString stringWithFormat:@"Presence result: %@", result]];
        } else {
            [weakSelf log:[NSString stringWithFormat:@"Presence error: %@", error.domain]];
        }
    };
    [ortcClient presence:txtServer.text isCLuster:chxIsCluster.isChecked applicationKey:txtAppKey.text authenticationToken:txtAuthToken.text channel:txtChannel.text callback:presenceDictionary];
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

#pragma mark Private methods

- (void) log:(NSString*) text
{
    tvwLog.text = [[utils getHour] stringByAppendingString:[@" - " stringByAppendingString:[text stringByAppendingString:[@"\n" stringByAppendingString:tvwLog.text]]]];
}

@end
