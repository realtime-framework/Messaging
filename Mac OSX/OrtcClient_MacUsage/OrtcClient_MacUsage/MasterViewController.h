//
//  MasterViewController.h
//  OrtcClient_MacUsage
//
//  Created by iOSdev on 11/25/13.
//  Copyright (c) 2013 Realtime.co. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OrtcClient.h"

@interface MasterViewController : NSViewController <OrtcClientDelegate> {
	
	void (^onMessage)(OrtcClient* ortc, NSString* channel, NSString* message);
}


@property (strong, nonatomic) OrtcClient *ortcClient;
@property (weak) IBOutlet NSTextField *serverTxtField;
@property (weak) IBOutlet NSButton *isClusterCheck;

@property (weak) IBOutlet NSTextField *authenticationTxtField;
@property (weak) IBOutlet NSTextField *appKeyTxtField;
@property (weak) IBOutlet NSTextField *connMetaDataTxtField;
@property (weak) IBOutlet NSTextField *channelTxtField;

@property (weak) IBOutlet NSTextField *isChannelSubTxtField;

@property (unsafe_unretained) IBOutlet NSTextView *messageTxtView;
@property (unsafe_unretained) IBOutlet NSTextView *logTxtView;



- (IBAction)checkSubscription:(id)sender;
- (IBAction)connect:(id)sender;
- (IBAction)subscribe:(id)sender;
- (IBAction)sendMessage:(id)sender;
- (IBAction)disconnect:(id)sender;
- (IBAction)unsubscribe:(id)sender;
- (IBAction)clearLog:(id)sender;



@end
