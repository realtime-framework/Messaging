//
//  ViewPostAuthController.m
//  OrtcClientUsage_2_0
//
//  Created by Rafael Cabral on 5/18/12.
//  Copyright (c) 2012 IBT. All rights reserved.
//

#import "ViewPostAuthController.h"
#import "QuartzCore/QuartzCore.h"

@interface ViewPostAuthController ()

@end

@implementation ViewPostAuthController

@synthesize txtServer;
@synthesize txtAuthToken;
@synthesize txtAppKey;
@synthesize txtPrivateKey;
@synthesize txtTtl;
@synthesize txtChannels;
@synthesize txtPermissions;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Log
    tvwLog.editable = NO;
    
    // Scroll View
    mainScrollView.layer.borderColor = [UIColor blackColor].CGColor;
    mainScrollView.layer.borderWidth = 1.0;
    [mainScrollView setScrollEnabled:YES];
    [mainScrollView setContentSize:CGSizeMake(320, 385)];
    
    // Scroll View Tap
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.cancelsTouchesInView = NO;
    [mainScrollView addGestureRecognizer:singleTap];
    
    // CheckBox Is Cluster
    chxIsCluster = [[MICheckBox alloc] initWithFrame:CGRectMake(225, 3, 150, 25)];
	chxIsCluster.titleLabel.font = [UIFont systemFontOfSize:13];
    chxIsCluster.isChecked = YES;
    [chxIsCluster setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[chxIsCluster setTitle:@"Is Cluster" forState:UIControlStateNormal];
	[mainScrollView addSubview:chxIsCluster];
    
    // CheckBox Is Private
    chxIsPrivate = [[MICheckBox alloc] initWithFrame:CGRectMake(225, 85, 150, 25)];
	chxIsPrivate.titleLabel.font = [UIFont systemFontOfSize:13];
    chxIsPrivate.isChecked = YES;
    [chxIsPrivate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[chxIsPrivate setTitle:@"Is Private" forState:UIControlStateNormal];
	[mainScrollView addSubview:chxIsPrivate];
    
    // Permissions
    txtChannels.text = @"yellow\nyellow:*\nblue\nblue:sub";
    txtPermissions.text = @"w\nw\nr\nw";
    
    // Instantiate OrtcClient
    ortcClient = [OrtcClient alloc];
    
    utils = [Utils alloc];
}

- (void)viewDidUnload {
    tvwLog = nil;
    mainScrollView = nil;
    txtServer = nil;
    txtAuthToken = nil;
    txtAppKey = nil;
    txtPrivateKey = nil;
    txtTtl = nil;
    txtChannels = nil;
    txtPermissions = nil;
    
    mainScrollView = nil;
    mainScrollView = nil;
    mainScrollView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Hide keyboard

- (IBAction)txtReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender
{
    [self resignResponders];
}

- (void) handleSingleTap:(id*)sender
{
    [self resignResponders];
}

- (void) resignResponders
{
    [txtServer resignFirstResponder];
    [txtAppKey resignFirstResponder];
    [txtAuthToken resignFirstResponder];
    [txtPrivateKey resignFirstResponder];
    [txtTtl resignFirstResponder];
    [txtChannels resignFirstResponder];
    [txtPermissions resignFirstResponder];
}

#pragma mark Buttons events

- (IBAction)btnPost:(id)sender {
    tvwLog.text = [[utils getHour] stringByAppendingString:[@" - Posting permissions...\n" stringByAppendingString:tvwLog.text]];
    
    @try {
        NSMutableArray* userChannels = [[NSMutableArray alloc] init];
        NSMutableArray* userPermissions = [[NSMutableArray alloc] init];
        NSMutableDictionary* permissions = [[NSMutableDictionary alloc] init];
        
        [userChannels setArray:[txtChannels.text componentsSeparatedByString:@"\n"]];
        [userPermissions setArray:[txtPermissions.text componentsSeparatedByString:@"\n"]];
        
        int i = 0;
        for (NSString* channel in userChannels) {
            [permissions setObject:[[userPermissions objectAtIndex:i] lowercaseString] forKey:channel];
            i++;
        }
        
        if ([ortcClient saveAuthentication:txtServer.text isCLuster:chxIsCluster.isChecked authenticationToken:txtAuthToken.text authenticationTokenIsPrivate:chxIsPrivate.isChecked applicationKey:txtAppKey.text timeToLive:[txtTtl.text intValue] privateKey:txtPrivateKey.text permissions:permissions]) {
            tvwLog.text = [[utils getHour] stringByAppendingString:[@" - Permissions correctly posted\n" stringByAppendingString:tvwLog.text]];
        }
        else {
            tvwLog.text = [[utils getHour] stringByAppendingString:[@" - Unable to post permissions\n" stringByAppendingString:tvwLog.text]];
        }
    }
    @catch (NSException* exception) {
        tvwLog.text = [[utils getHour] stringByAppendingString:[[NSString stringWithFormat:@" - %@\n", exception] stringByAppendingString:tvwLog.text]];
    }
}

- (IBAction)btnClearLog:(id)sender {
    tvwLog.text = @"";
}

@end
