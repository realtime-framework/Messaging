//
//  AppDelegate.h
//  OrtcClient
//
//  Created by iOSdev on 9/20/13.
//  Copyright (c) 2013 Realtime.co All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 This class manages the Apple Push Notifications Service
 
 __Discussion__
 
 This Class inherits from the UIResponder class. UIResponder defines an interface for objects that respond to and handle events, is the superclass of UIApplication.
 
 RealtimePushAppDelegate implements UIApplicationDelegate protocol.
 
 In order to use OrtcClient with Apple Push Notifications Service, your Application Delegate must inherit from RealtimePushAppDelegate, you will also  need in `application:didFinishLaunchingWithOptions:` implementation call his super.
 
 This class enables use of push notifications as well as forwards your messages to OrtcClient.
 
 Just chek the example code:
 
 - in your Application delegate (interface)

 <pre><code>
 @interface YOUR_APPLICATION_DELEGATE : RealtimePushAppDelegate
 ...
 @end
 
 </pre></code>
 

  - in your Application delegate (implementation)
 <pre><code>
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 {
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    // the following code is standard template code
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
 }

 </pre></code>
 
 
 
If for some reason, in your Application delegate, You implement:
 
 ``- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo``
 
 You must implement his super in order to get OrtcClient functionalities.
 
 
 
 
 __See Also:__

 [_UIApplication Documentaion_](http://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplication\_Class/index.html)

 [_UIApplicationDelegate Documentaion_](https://developer.apple.com/library/ios/documentation/uikit/reference/UIApplication\_Class/Reference/Reference.html)
 
 */

@interface RealtimePushAppDelegate : UIResponder <UIApplicationDelegate>

///---------------------------------------------------------------------------------------
/// @name Properties
///---------------------------------------------------------------------------------------
/**
 The window to use when presenting a storyboard.
 
 This property contains the window used to present the app’s visual content on the device’s main screen.
*/
@property (strong, nonatomic) UIWindow *window;

@end

