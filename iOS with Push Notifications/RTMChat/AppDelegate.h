//
//  AppDelegate.h
//  RTMChat
//
//  Created by iOSdev on 10/3/13.
//  Copyright (c) 2013 Realtime. All rights reserved.
//


#import "RealtimePushAppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate : RealtimePushAppDelegate

@property (readonly, strong, nonatomic) RootViewController *viewController;
@property (readonly, strong, nonatomic) UINavigationController *navigationController;


@end
