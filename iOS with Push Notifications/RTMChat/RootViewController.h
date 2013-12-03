//
//  RootViewController.h
//  RTMChat
//
//  Created by iOSdev on 10/3/13.
//  Copyright (c) 2013 Realtime. All rights reserved.
//

#import "OrtcClient.h"
#import "Reachability.h"
#import "Utils.h"

#import "DataModelChat.h"
#import "ListViewController.h"
#import "ChatViewController.h"


@interface RootViewController : UIViewController <OrtcClientDelegate, ChatRoomDelegate, ComposeDelegate, UITextFieldDelegate> {

    void (^onMessage)(OrtcClient* ortc, NSString* channel, NSString* message);
}

@property (strong, nonatomic) OrtcClient *ortcClient;
@property (strong, nonatomic) Reachability *internetReachable;
@property (strong, nonatomic) DataModelChat *dataModel;
@property (strong, nonatomic) ListViewController *roomsTableViewController;

@property (readwrite, nonatomic) BOOL isInternetActive;

@property (weak, nonatomic) IBOutlet UIButton *createChannelBtt;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;


- (void) receivedMSG:(NSString *) message onChannel:(NSString *) channel;

@end
