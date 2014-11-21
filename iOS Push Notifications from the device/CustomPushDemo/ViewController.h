//
//  ViewController.h
//  CustomPushDemo
//
//  Created by Joao Caixinha on 18/09/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textAppKey;
@property (weak, nonatomic) IBOutlet UITextField *textPrivateKey;
@property (weak, nonatomic) IBOutlet UITextField *textChannel;
@property (weak, nonatomic) IBOutlet UITextField *textMessage;

@property (weak, nonatomic) IBOutlet UITextField *textBadge;
@property (weak, nonatomic) IBOutlet UITextField *textSound;
@property (weak, nonatomic) IBOutlet UITextField *textExtra;


- (IBAction)actionSendPushNotification:(id)sender;

@end
