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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDismiss:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardAppear:(NSNotification*)notif
{
    if (![_textAppKey isFirstResponder] &&
        ![_textPrivateKey isFirstResponder] &&
        ![_textChannel isFirstResponder] &&
        ![_textMessage isFirstResponder]) {
        
        _btFrame = _button_send.frame;
        _button_send.hidden = YES;
        
    NSDictionary *userInfo = notif.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.view.frame = CGRectMake(0, 0 - keyboardFrameEnd.origin.y / 2, keyboardFrameEnd.size.width, self.view.frame.size.height);
    } completion:nil];
    }
}

- (void)keyboardDismiss:(NSNotification*)notif
{
    NSDictionary *userInfo = notif.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y);
    } completion:^(BOOL finish){
        _button_send.frame = _btFrame;
        _button_send.hidden = NO;
    }];
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
