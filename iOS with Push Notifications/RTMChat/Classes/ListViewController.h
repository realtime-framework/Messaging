//
//  ListViewController.h
//  RTMChat
//
//  Created by iOSdev on 10/15/13.
//  Copyright (c) 2013 Realtime.Frade. All rights reserved.
//


#import "DataModelChat.h"
#import "OrtcClient.h"

// The delegate protocol for the Compose screen
@protocol ChatRoomDelegate <NSObject>

- (OrtcClient *) OrtcClient;
- (void) subscribeChannelWithName:(NSString *) channelName;
- (void) unSubscribeChannelWithName:(NSString *) channelName;
@end


@interface ListViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, assign) id<ChatRoomDelegate> delegate;
@property (strong, nonatomic) DataModelChat *dataModel;

@property (strong, nonatomic) UITextField *myNewChannelTextField;

- (void) addChannel:(NSString *) channel;
- (void) removeChannel:(NSString *) channel;


@end