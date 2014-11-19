//
//  ViewController.h
//  OrtcClientUsage_2_0
//
//  Created by Rafael Cabral on 5/18/12.
//  Copyright (c) 2012 IBT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrtcClient.h"
#import "Utils.h"
#import "MICheckBox.h"

@interface ViewController : UIViewController<OrtcClientDelegate>
{
@private
    OrtcClient* ortcClient;
    Utils* utils;
    
    IBOutlet UITextView *tvwLog;
    IBOutlet UIScrollView *mainScrollView;
    
    UITextField *txtServer;
    UITextField *txtMessage;
    UITextField *txtChannel;
    UITextField *txtAuthToken;
    UITextField *txtAppKey;
    UITextField *txtConnMeta;
    
    MICheckBox* chxIsCluster;
    
    void (^onMessage)(OrtcClient* ortc, NSString* channel, NSString* message);
    void (^presenceCallback)(NSError* error, NSString* result);
    void (^presenceDictionary)(NSError* error, NSDictionary* result);
}
@property (nonatomic, retain) IBOutlet UITextField *txtServer;
@property (nonatomic, retain) IBOutlet UITextField *txtMessage;
@property (nonatomic, retain) IBOutlet UITextField *txtChannel;
@property (nonatomic, retain) IBOutlet UITextField *txtAuthToken;
@property (nonatomic, retain) IBOutlet UITextField *txtAppKey;
@property (nonatomic, retain) IBOutlet UITextField *txtConnMeta;
@property (nonatomic, retain) IBOutlet UITextField *txtChannelIsSubscribed;
@property (nonatomic, retain) IBOutlet UITextField *txtPrivateKey;

- (IBAction)btnConnect:(id)sender;
- (IBAction)btnDisconnect:(id)sender;
- (IBAction)btnSubscribe:(id)sender;
- (IBAction)btnUnsubscribe:(id)sender;
- (IBAction)btnSend:(id)sender;
- (IBAction)btnClearLog:(id)sender;
- (IBAction)txtReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
- (IBAction)btnIsSubscribed:(id)sender;
- (IBAction)btnPresence:(id)sender;

- (void)handleSingleTap:(id*)sender;
- (void)resignResponders;

@end
