//
//  PushNotification.m
//  CustomPushDemo
//
//  Created by Joao Caixinha on 18/09/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

#import "PushNotification.h"


@implementation PushNotification


-(id)initWithApplicationKey:(NSString*)appkey privateKey:(NSString*)privateK channel:(NSString*)ch message:(NSString*)msg andPayload:(NSDictionary*)pl
{
    self = [super init];
    if (self) {
        _applicationKey = appkey;
        _privateKey = privateK;
        _channel = ch;
        _message = msg;
        
        [REST jsonStringFromDictionary:pl OnCompletion:^(NSString *jsonString, NSError *error) {
            _payload = jsonString;
        }];
    }
    return self;
}

- (void)sendPushNotification
{
    REST *rest = [[REST alloc] initWithData:[self toDictionary] forURL:@"https://ortc-mobilepush.realtime.co/mp/publish" withMethod:@"POST" andDelegate:self];
#pragma unused (rest)
}


-(NSDictionary*)toDictionary
{
    return @{
             @"applicationKey": _applicationKey,
             @"privateKey": _privateKey,
             @"channel" : _channel,
             @"message" : _message,
             @"payload" : _payload
             };
}

- (void)didReciveHTTPsData:(NSDictionary*)data
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sucess"
                                                    message:@"PushNotification send"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"%@", [data description]);
}

- (void)didReciveHTTPsError:(NSDictionary*)data
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[data objectForKey:@"message"]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

    NSLog(@"%@", [data description]);
}



@end
