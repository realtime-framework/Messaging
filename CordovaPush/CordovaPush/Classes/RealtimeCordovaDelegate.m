//
//  RealtimeCordovaDelegate.m
//  babblr
//
//  Created by Joao Caixinha on 15/09/14.
//
//

#import "RealtimeCordovaDelegate.h"

@implementation RealtimeCordovaDelegate


- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes: UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge];
    }
#else
    [application registerForRemoteNotificationTypes: UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge];
#endif

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePushNotifications)
                                                 name:@"checkForNotifications"
                                               object:nil];
    return YES;
}



- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n\n - didRegisterForRemoteNotificationsWithDeviceToken:\n%@\n", deviceToken);
    
    [OrtcClient performSelector:@selector(setDEVICE_TOKEN:) withObject:[[NSString alloc] initWithString:newToken]];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    UIApplicationState appState = UIApplicationStateActive;
    if ([application respondsToSelector:@selector(applicationState)]) {
        appState = application.applicationState;
    }
    
    if (appState == UIApplicationStateActive) {
        [self processPush:userInfo];
    } else {
        //save it for later
        _pushInfo = userInfo;
    }
}

- (void)processPush:(NSDictionary *)userInfo
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[userInfo objectForKey:@"aps"]
                                                       options:(NSJSONWritingOptions)    (NSJSONWritingPrettyPrinted)
                                                         error:&error];
    
    
    NSString *jsonstring = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *channel = [userInfo objectForKey:@"C"];
    
    
    NSString * jsCallBack = [NSString stringWithFormat:@"window.plugins.OrtcPushPlugin.receiveRemoteNotification('%@',%@);",channel, jsonstring];
    
    
    [self.viewController.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
    
}


- (void)handlePushNotifications
{
    if (_pushInfo != nil) {
        [self processPush:_pushInfo];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self handlePushNotifications];
    
}


- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}


@end
