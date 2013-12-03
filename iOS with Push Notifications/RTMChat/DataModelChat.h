//
//  DataModelChat.h
//  RTMChat
//
//  Created by iOSdev on 10/15/13.
//  Copyright (c) 2013 Realtime.Frade. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NICKNAME_KEY @"ORTC_NICKNAME"
#define ORTCCHANNELS_KEY @"ORTCChannels"

@interface DataModelChat : NSObject

@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSMutableArray *channels;
@property (strong, nonatomic) NSMutableDictionary *msgDictionary;
@property (strong, nonatomic) NSMutableDictionary *unreadMsgsToChannel;


- (id) initWithUserData;
- (void) saveNickName:(NSString *) nickName;
- (void) saveChannels;

@end
