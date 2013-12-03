//
//  MessageTableViewCell.m
//  RTMChat
//
//  Created by iOSdev on 10/8/13.
//  Copyright (c) 2013 Realtime. All rights reserved.
//

#import "MessageTableViewCell.h"

static UIColor* color = nil;

@interface MessageTableViewCell()

@end

@implementation MessageTableViewCell

+ (void)initialize
{
	if (self == [MessageTableViewCell class])
	{
		color = [UIColor colorWithRed:220/255.0 green:225/255.0 blue:240/255.0 alpha:1.0];
	}
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;

		// Create the speech bubble view
		_bubbleView = [[SpeechBubbleView alloc] initWithFrame:CGRectZero];
		//_bubbleView.backgroundColor = color;
        _bubbleView.backgroundColor = [UIColor clearColor];
		_bubbleView.opaque = YES;
		_bubbleView.clearsContextBeforeDrawing = NO;
		_bubbleView.contentMode = UIViewContentModeRedraw;
		_bubbleView.autoresizingMask = 0;
		[self.contentView addSubview:_bubbleView];

		// Create the label
		_label = [[UILabel alloc] initWithFrame:CGRectZero];
		//_label.backgroundColor = color;
        _label.backgroundColor = [UIColor clearColor];
		_label.opaque = YES;
		_label.clearsContextBeforeDrawing = NO;
		_label.contentMode = UIViewContentModeRedraw;
		_label.autoresizingMask = 0;
		_label.font = [UIFont systemFontOfSize:13];
		_label.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
		[self.contentView addSubview:_label];
	}
	return self;
}

- (void)layoutSubviews
{
	// This is a little trick to set the background color of a table view cell.
	[super layoutSubviews];
	//self.backgroundColor = color;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setMessage:(NSDictionary *) message
{
    //NSLog(@"\nDate: %@ | From: %@ | %@ | %d", [message objectForKey:@"Date"], [message objectForKey:@"NickName"], [message objectForKey:@"Message"], [[message objectForKey:@"isFromUser"] boolValue]);
    
	CGPoint point = CGPointZero;

	// We display messages that are sent by the user on the left-hand side of
	// the screen. Incoming messages are displayed on the right-hand side.
	NSString* senderName;
	BubbleType bubbleType;
    CGSize bubbleSize = [SpeechBubbleView sizeForText:[message objectForKey:@"Message"]];
    
	if ([[message objectForKey:@"isFromUser"] boolValue])
	{
        bubbleType = BubbleTypeLefthand;
		senderName = [message objectForKey:@"NickName"];
        _label.textAlignment = NSTextAlignmentLeft;
	}
	else
	{
        bubbleType = BubbleTypeRighthand;
		senderName = [message objectForKey:@"NickName"];
		
        point.x = self.bounds.size.width - bubbleSize.width;
        _label.textAlignment = NSTextAlignmentRight;
    }
    
    // Resize the bubble view and tell it to display the message text
	CGRect rect;
	rect.origin = point;
	rect.size = bubbleSize;
	_bubbleView.frame = rect;
	[_bubbleView setText:[message objectForKey:@"Message"] bubbleType:bubbleType];

	// Format the message date
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"EEE, dd MMM yyyy, HH:mm"];
	NSString* dateString = [formatter stringFromDate:[message objectForKey:@"Date"]];

	// Set the sender's name and date on the label
	_label.text = [NSString stringWithFormat:@"%@ @ %@", senderName, dateString];
    _label.textColor = [UIColor whiteColor];
	[_label sizeToFit];
	_label.frame = CGRectMake(8, bubbleSize.height, self.contentView.bounds.size.width - 16, 16);
}

@end
