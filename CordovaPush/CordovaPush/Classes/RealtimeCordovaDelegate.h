//
//  RealtimeCordovaDelegate.h
//  babblr
//
//  Created by Joao Caixinha on 15/09/14.
//
//

#import <RealtimePushAppDelegate.h>
#import <Cordova/CDVViewController.h>
#import <OrtcClient.h>

@interface RealtimeCordovaDelegate : NSObject<UIWebViewDelegate>


@property(retain, nonatomic)CDVViewController *viewController;
@property(retain, nonatomic)NSDictionary *pushInfo;

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

@end
