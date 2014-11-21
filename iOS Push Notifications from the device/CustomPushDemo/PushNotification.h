//
//  PushNotification.h
//  CustomPushDemo
//
//  Created by Joao Caixinha on 18/09/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REST.h"

@interface PushNotification : NSObject<RESTProtocol>

#pragma model
@property(retain, nonatomic)NSString *applicationKey;
@property(retain, nonatomic)NSString *privateKey;
@property(retain, nonatomic)NSString *channel;
@property(retain, nonatomic)NSString *message;
@property(retain, nonatomic)NSString *payload;

#pragma actions
-(id)initWithApplicationKey:(NSString*)appkey privateKey:(NSString*)privateK channel:(NSString*)ch message:(NSString*)msg andPayload:(NSDictionary*)pl;
- (void)sendPushNotification;

@end
