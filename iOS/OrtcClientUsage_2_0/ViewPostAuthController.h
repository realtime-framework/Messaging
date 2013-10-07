//
//  ViewPostAuthController.h
//  OrtcClientUsage_2_0
//
//  Created by Rafael Cabral on 5/18/12.
//  Copyright (c) 2012 IBT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrtcClient.h"
#import "Utils.h"
#import "MICheckBox.h"

@interface ViewPostAuthController : UIViewController
{
@private
    OrtcClient* ortcClient;
    Utils* utils;
    
    IBOutlet UITextView *tvwLog;
    IBOutlet UIScrollView *mainScrollView;
    
    UITextField *txtServer;
    UITextField *txtAuthToken;
    UITextField *txtAppKey;
    UITextField *txtPrivateKey;
    UITextField *txtTtl;
    
    UITextView *txtChannels;
    UITextView *txtPermissions;
    
    MICheckBox* chxIsCluster;
    MICheckBox* chxIsPrivate;
}
@property (nonatomic, retain) IBOutlet UITextField *txtServer;
@property (nonatomic, retain) IBOutlet UITextField *txtAuthToken;
@property (nonatomic, retain) IBOutlet UITextField *txtAppKey;
@property (nonatomic, retain) IBOutlet UITextField *txtPrivateKey;
@property (nonatomic, retain) IBOutlet UITextField *txtTtl;

@property (nonatomic, retain) IBOutlet UITextView *txtChannels;
@property (nonatomic, retain) IBOutlet UITextView *txtPermissions;

- (IBAction)btnPost:(id)sender;
- (IBAction)btnClearLog:(id)sender;
- (IBAction)txtReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;

- (void)handleSingleTap:(id*)sender;
- (void)resignResponders;

@end
