//
//  ChatViewController.h
//  RTMChat
//
//  Created by iOSdev on 10/8/13.
//  Copyright (c) 2013 Realtime. All rights reserved.
//

#import "ComposeViewController.h"


@interface ChatViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *items;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;


- (id)initWithNibNameAndItems:(NSArray *) items;
- (void) didReceiveMessage:(NSDictionary *) messageDict OnChannel:(NSString *) channel;

@end
