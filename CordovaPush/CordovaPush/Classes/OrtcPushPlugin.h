//
//  OrtcPlugin.h
//  babblr
//
//  Created by Joao Caixinha on 12/09/14.
//
//

#import <Foundation/Foundation.h>
#import <CDV.h>
#import <OrtcClient.h>

@interface OrtcPushPlugin : CDVPlugin<OrtcClientDelegate>


@property(retain, nonatomic)OrtcClient *ortc;
@property(retain, nonatomic)id message;
@property(retain, nonatomic)NSMutableDictionary *connectCommand;

- (void)checkForNotifications:(CDVInvokedUrlCommand*)command;
- (void)connect:(CDVInvokedUrlCommand*)command;
- (void)disconnect:(CDVInvokedUrlCommand*)command;
- (void)subscribe:(CDVInvokedUrlCommand*)command;
- (void)unsubscribe:(CDVInvokedUrlCommand*)command;
- (void)setApplicationIconBadgeNumber:(CDVInvokedUrlCommand*)command;
- (void)cancelAllLocalNotifications:(CDVInvokedUrlCommand*)command;
- (void)log:(CDVInvokedUrlCommand*)command;

@end
