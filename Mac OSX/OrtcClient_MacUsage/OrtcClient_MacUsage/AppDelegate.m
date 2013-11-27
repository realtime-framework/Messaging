//
//  AppDelegate.m
//  OrtcClient_MacUsage
//
//  Created by iOSdev on 11/25/13.
//  Copyright (c) 2013 Realtime.co. All rights reserved.
//

#import "AppDelegate.h"
#include "MasterViewController.h"


@interface  AppDelegate()
@property (nonatomic,strong) IBOutlet MasterViewController *masterViewController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // 1. Create the master View Controller
    self.masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
	
	// 2. Add the view controller to the Window's content view
    [self.window.contentView addSubview:self.masterViewController.view];
    self.masterViewController.view.frame = ((NSView*)self.window.contentView).bounds;
}

@end
