//
//  MessageTableViewCell.h
//  RTMChat
//
//  Created by iOSdev on 10/8/13.
//  Copyright (c) 2013 Realtime. All rights reserved.
//

#import "SpeechBubbleView.h"

// Table view cell that displays a Message. The message text appears in a
// speech bubble; the sender name and date are shown in a UILabel below that.
@interface MessageTableViewCell : UITableViewCell {
    
    SpeechBubbleView *_bubbleView;
	UILabel *_label;
}

- (void) setMessage:(NSDictionary *)message;

@end
