//
//  ComposeViewController.h
//  RTMChat
//
//  Created by iOSdev on 10/8/13.
//  Copyright (c) 2013 Realtime. All rights reserved.
//


// The delegate protocol for the Compose screen
@protocol ComposeDelegate <NSObject>
- (void) didSaveMessage:(NSString *)message ToChannel:(NSString *) channel;
@end

// The Compose screen lets the user write a new message
@interface ComposeViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, assign) id<ComposeDelegate> delegate;

@property (nonatomic, strong) NSString *channel;
@property (nonatomic, weak) IBOutlet UITextView *messageTextView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *saveItem;
@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;

@property (weak, nonatomic) IBOutlet UIView *contentView;


- (void)updateBytesRemaining:(NSString*)text;

@end
