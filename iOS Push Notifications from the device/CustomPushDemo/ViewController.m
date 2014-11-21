//
//  ViewController.m
//  CustomPushDemo
//
//  Created by Joao Caixinha on 18/09/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

#import "ViewController.h"
#import "PushNotification.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionSendPushNotification:(id)sender {
    PushNotification *pushNotification = [[PushNotification alloc] initWithApplicationKey:[_textAppKey text] privateKey:[_textPrivateKey text] channel:[_textChannel text] message:[_textMessage text] andPayload:@{@"sound":[_textSound text], @"badge":[_textBadge text], @"extra": [_textExtra text]}];
    [pushNotification sendPushNotification];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textAppKey resignFirstResponder];
    [_textPrivateKey resignFirstResponder];
    [_textChannel resignFirstResponder];
    [_textMessage resignFirstResponder];
    
    [_textBadge resignFirstResponder];
    [_textSound resignFirstResponder];
    [_textExtra resignFirstResponder];
}

@end
