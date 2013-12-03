//
//  ComposeViewController.m
//  RTMChat
//
//  Created by iOSdev on 10/8/13.
//  Copyright (c) 2013 Realtime. All rights reserved.
//

#import "ComposeViewController.h"

#define MaxMessageLength 260

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    _messageTextView.delegate = self;
    [self updateBytesRemaining:@""];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        _contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    else {
        _contentView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [super viewWillAppear:animated];
	[_messageTextView becomeFirstResponder];
}

#pragma mark -
#pragma mark Actions

- (void)userDidCompose:(NSString *)text
{
    // Add a row for the Message to ChatViewController's table view.
	// Of course, ComposeViewController doesn't really know that the
	// delegate is the RootViewController.
    
	[self.delegate didSaveMessage:text ToChannel:_channel];
    
	// Close the Compose screen
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveAction
{
    [self userDidCompose:_messageTextView.text];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)updateBytesRemaining:(NSString*)text
{
	// Calculate how many bytes long the text is. We will send the text as
	// UTF-8 characters to the server. Most common UTF-8 characters can be
	// encoded as a single byte, but multiple bytes as possible as well.
	const char *s = [text UTF8String];
	size_t numberOfBytes = strlen(s);
    
	// Calculate how many bytes are left
	int remaining = MaxMessageLength - numberOfBytes;
    
	// Show the number of remaining bytes in the navigation bar's title
	if (remaining >= 0)
		_navigationBar.topItem.title = [NSString stringWithFormat:NSLocalizedString(@"%d Remaining", nil), remaining];
	else
		_navigationBar.topItem.title = NSLocalizedString(@"Text Too Long", nil);
    
	// Disable the Save button if no text is entered, or if it is too long
	_saveItem.enabled = (remaining >= 0) && (text.length != 0);
}

- (BOOL)textView:(UITextView*)theTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
	NSString* newText = [theTextView.text stringByReplacingCharactersInRange:range withString:text];
	[self updateBytesRemaining:newText];
	return YES;
}
@end
