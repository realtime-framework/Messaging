//
//  RootViewController.m
//  RTMChat
//
//  Created by iOSdev on 10/3/13.
//  Copyright (c) 2013 Realtime. All rights reserved.
//

#import "RootViewController.h"
#import "ChatViewController.h"

#warning SET CONSTANTS WITH YOUR REALTIME.CO APPLICATION DATA

#define SERVER @"http://ortc-developers.realtime.co/server/2.1"
#define AUTH_TOKEN @"__AUTH_TOKEN__"
#define APP_KEY @"__YOUR_APPLICATION_KEY__"
#define CONNECTION_METADATA @"__CONNECTION_METADATA__"
#define ISCLUSTER 1


@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"RTM Chat";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification object:nil];
    
    _internetReachable = [Reachability reachabilityWithHostname:@"www.realtime.co"];
    [_internetReachable startNotifier];
    
    _statusLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.75];
    _statusLabel.layer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.75].CGColor;
    _statusLabel.layer.borderColor = [UIColor blackColor].CGColor;
    _statusLabel.layer.borderWidth = 1.0;
    _statusLabel.layer.cornerRadius = 8.0;
    
    _dataModel = [[DataModelChat alloc] initWithUserData];
    
    if (_dataModel.nickName != nil && [_dataModel.nickName length] > 0) {
        
        _nickNameTextField.alpha = 0.0;
        _welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@!", _dataModel.nickName];
    }
    else {
        _dataModel.nickName = @"";
        _welcomeLabel.alpha = 0.0;
        _createChannelBtt.enabled = NO;
    }
    
    _nickNameTextField.delegate = self;
    _ortcClient = [OrtcClient ortcClientWithConfig:self];
    
	_roomsTableViewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    _roomsTableViewController.delegate = self;
    _roomsTableViewController.dataModel = _dataModel;
	
    [self configureView];
}


- (void) viewDidUnload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setStatusLabel:nil];
    [self setCreateChannelBtt:nil];
    [self setNickNameTextField:nil];
    [self setWelcomeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Action

- (void) configureView {
    
    if (_isInternetActive) {
        _statusLabel.text = @"We got Connection";
        
        if (!_ortcClient.isConnected) {
            [self connectORTC];
        }
        
        if (_dataModel.nickName != nil && [_dataModel.nickName length] > 0 && _ortcClient.isConnected) {
            
            _createChannelBtt.enabled = YES;
        }
        else {
            _createChannelBtt.enabled = NO;
        }
    }
    else {
        _createChannelBtt.enabled = NO;
        _statusLabel.text = @"No Internet Connection Available!";
    }
}


- (void) connectORTC {
    
    [_ortcClient setConnectionMetadata:CONNECTION_METADATA];
    [_ortcClient setConnectionTimeout:10];
    
    if (ISCLUSTER) {
        [_ortcClient setClusterUrl:SERVER];
    }
    else {
        [_ortcClient setUrl:SERVER];
    }
    
    [self log:[NSString stringWithFormat:@"Connecting to: %@", SERVER]];
    [_ortcClient connect:APP_KEY authenticationToken:AUTH_TOKEN];
}


- (void) sendMessage:(NSString *)msg ToChannel:(NSString *) channel
{
    msg = [NSString stringWithFormat:@"%@:%@", _dataModel.nickName,msg];
    [_ortcClient send:channel message:msg];
}


- (IBAction) showChannels:(id)sender
{
	[self.navigationController pushViewController:_roomsTableViewController animated:YES];
    
    if ([_dataModel.channels count] < 1) {
        [_roomsTableViewController setEditing:YES animated:YES];
    }
}


#pragma mark ORTC Delegation

- (void) onConnected:(OrtcClient*) ortc
{
    [self log:[NSString stringWithFormat:@"Connected to: %@", ortc.url]];
    [self log:[NSString stringWithFormat:@"Session Id: %@", ortc.sessionId]];
    
    [self configureView];
    _statusLabel.text = @"We got Connected";
    
    for (NSString *channel in _dataModel.channels) {
        [self subscribeChannelWithName:channel];
    }
}

- (void) onDisconnected:(OrtcClient*) ortc
{
    _createChannelBtt.enabled = NO;
    [self log:@"Disconnected"];
}

- (void) onReconnecting:(OrtcClient*) ortc
{
    [self log:[NSString stringWithFormat:@"Reconnecting to: %@", ortc.url]];
}

- (void) onReconnected:(OrtcClient*) ortc
{
    [self configureView];
    [self log:[NSString stringWithFormat:@"Reconnected to: %@", ortc.url]];
}

- (void) onSubscribed:(OrtcClient*) ortc channel:(NSString*) channel
{
    [self log:[NSString stringWithFormat:@"Subscribed to: %@", channel]];
    
    [_roomsTableViewController addChannel:channel];
}

- (void) onUnsubscribed:(OrtcClient*) ortc channel:(NSString*) channel
{
    [self log:[NSString stringWithFormat:@"Unsubscribed from: %@", channel]];
    
    [_roomsTableViewController removeChannel:channel];
}

- (void) onException:(OrtcClient*) ortc error:(NSError*) error
{
    [self log:[NSString stringWithFormat:@"Exception [Code:%d]: %@", [error code], error.localizedDescription]];
    
    if ([error code] != 1) {
        
        NSString *msg = [NSString stringWithFormat:@"It has occurred a problem!\nException: %@", error.localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark ORTC Private methods

- (void) log:(NSString*) text
{
    Utils *utils = [[Utils alloc] init];
    NSLog(@"LOG: %@ - %@", [utils getHour], text);
}

- (void) receivedMSG:(NSString *) message onChannel:(NSString *) channel {
    
    NSUInteger nickEndPosition = [message rangeOfString:@":"].location;
    NSString *msgNickName = @"";
    NSString *msg = @"";
    
    if (nickEndPosition == NSNotFound) {
        
        msgNickName = @"Unknown";
        msg = message;
    }
    else if (nickEndPosition == 0) {
        
        msgNickName = @"Unknown";
        msg = [message substringFromIndex:nickEndPosition + 1];
    }
    else if (nickEndPosition != NSNotFound) {
        NSRange range = NSMakeRange(0, nickEndPosition);
        msgNickName = [message substringWithRange:range];
        msg = [message substringFromIndex:nickEndPosition + 1];
    }
    
    BOOL isFromUser = NO;
    if ([msgNickName isEqualToString:_dataModel.nickName]) {
        isFromUser = YES;
    }
    
    NSDictionary *msgDictionary = [[NSDictionary alloc] initWithObjectsAndKeys: msgNickName, @"NickName", msg, @"Message", [NSDate date], @"Date", [NSNumber numberWithBool:isFromUser], @"isFromUser", nil];
    
    NSMutableArray *channelArray = [[NSMutableArray alloc] initWithArray:[_dataModel.msgDictionary objectForKey:channel]];
    [channelArray addObject:msgDictionary];
    [_dataModel.msgDictionary setValue:channelArray forKey:channel];
    
    if ([[self.navigationController viewControllers] count] > 2) {
        ChatViewController *chat = (ChatViewController *)[[self.navigationController viewControllers] objectAtIndex:2];
        
        if ([channel isEqualToString:chat.title]) {
            [chat didReceiveMessage:msgDictionary OnChannel:channel];
        }
        else {
            
            int unreadMsgs = [[_dataModel.unreadMsgsToChannel objectForKey:channel] intValue];
            unreadMsgs++;
            [_dataModel.unreadMsgsToChannel setValue:[NSNumber numberWithInt:unreadMsgs] forKey:channel];
            [_roomsTableViewController.tableView reloadData];
			
					}
	}
	else {
		
		int unreadMsgs = [[_dataModel.unreadMsgsToChannel objectForKey:channel] intValue];
        unreadMsgs++;
        [_dataModel.unreadMsgsToChannel setValue:[NSNumber numberWithInt:unreadMsgs] forKey:channel];
        [_roomsTableViewController.tableView reloadData];
	}
}


#pragma mark -
#pragma mark ChatRoomDelegate

- (OrtcClient *) OrtcClient {
    return _ortcClient;
}

- (void) subscribeChannelWithName:(NSString *) channelName {
    
    NSNumber *result = [_ortcClient isSubscribed:channelName];
    if (result == [NSNumber numberWithBool:YES]) {
        
        [self log:[NSString stringWithFormat:@"YES, already subscribed to %@", channelName]];
    }
    else if (result == [NSNumber numberWithBool:NO]) {
        
        [self log:[NSString stringWithFormat:@"NOT subscribed to %@", channelName]];
        
        id weakSelf = self;
        
        onMessage = ^(OrtcClient* ortc, NSString* channel, NSString* message) {
            [weakSelf receivedMSG:message onChannel:channel];
        };
        
        //[_ortcClient subscribe:channelName subscribeOnReconnected:YES onMessage:onMessage];
        [_ortcClient subscribeWithNotifications:channelName subscribeOnReconnected:YES onMessage:onMessage];
    }
}

- (void) unSubscribeChannelWithName:(NSString *) channelName {
    
    [_ortcClient unsubscribe:channelName];
}


#pragma mark -
#pragma mark ComposeDelegate

- (void) didSaveMessage:(NSString *)message ToChannel:(NSString *) channel
{
	// This method is called when the user presses Save in the Compose screen,
	// but also when a push notification is received. We remove the "There are
	// no messages" label from the table view's footer if it is present, and
	// add a new row to the table view with a nice animation.
    
    [self sendMessage:message ToChannel:channel];
}


#pragma mark Reachability NetworkStatus

- (void) reachabilityChanged:(NSNotification*) notification
{
    Reachability *internetReachable = [notification object];
    if ([internetReachable isReachable]) {
        
        NSLog(@"Notification Says Reachable");
        _isInternetActive = YES;
        _statusLabel.text = @"We got Connection";
    }
    else {
        
        NSLog(@"Notification Says UNReachable");
        _isInternetActive = NO;
        _statusLabel.text = @"No Internet Connection Available!";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Lost" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self configureView];
}


#pragma mark - UITextField delegate

- (BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)characters
{
    NSCharacterSet *invalidCharSet = [NSCharacterSet characterSetWithCharactersInString:@""];
    if (field == _nickNameTextField)
    {
        invalidCharSet = [NSCharacterSet characterSetWithCharactersInString:@":"];
    }
    NSString *filtered = [[characters componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    
    return [characters isEqualToString:filtered];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    if (textField == _nickNameTextField) {
        
        if (_nickNameTextField.text != nil && [_nickNameTextField.text length] > 0) {
            
            [_dataModel saveNickName:_nickNameTextField.text];
            _welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@!", _dataModel.nickName];
            
            [UIView animateWithDuration:0.20 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 
                                 _nickNameTextField.alpha = 0.0;
                                 _welcomeLabel.alpha =  1.0;
                             }
                             completion:^(BOOL finished) {
                                 _createChannelBtt.enabled = YES;
                             }];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"NO, that's not your Nickname" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
            return NO;
        }
    }
    return YES;
}


@end
