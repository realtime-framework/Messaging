//
//  DataModelChat.m
//  RTMChat
//
//  Created by iOSdev on 10/15/13.
//  Copyright (c) 2013 Realtime.Frade. All rights reserved.
//

//    msgDictionary data structure
//
//    {
//        "Channel(Key)(String)" =
//        (
//            {
//                Date = NSDate;
//                Message = String;
//                NickName = String;
//                isFromUser = BOOL;
//            },
//            {
//                Date = NSDate;
//                Message = String;
//                NickName = String;
//                isFromUser = BOOL;
//            }
//         );
//    }


#import "DataModelChat.h"

@implementation DataModelChat

- (id) initWithUserData {
    
    self = [super init];
    if (self) {
        
        _nickName = [[NSString alloc] init];
        _channels = [[NSMutableArray alloc] init];
        _msgDictionary = [[NSMutableDictionary alloc] init];
        _unreadMsgsToChannel = [[NSMutableDictionary alloc] init];
        
        [self setUserData];
    }
    return self;
}


- (void) setUserData {
    
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME_KEY];
    if (nickName != nil) {
        _nickName = [[NSString alloc] initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME_KEY]];
    }
    else {
        _nickName = @"";
    }
    _channels = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:ORTCCHANNELS_KEY]];
}


- (void) saveNickName:(NSString *) nickName {
    
    _nickName = nickName;
    [[NSUserDefaults standardUserDefaults] setObject:_nickName forKey:NICKNAME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void) saveChannels {
    
    [[NSUserDefaults standardUserDefaults] setObject:_channels forKey:ORTCCHANNELS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
