//
//  ChatViewController.m
//  RTMChat
//
//  Created by iOSdev on 10/8/13.
//  Copyright (c) 2013 Realtime. All rights reserved.
//

#import "ChatViewController.h"
#import "RootViewController.h"
#import "MessageTableViewCell.h"
#import "SpeechBubbleView.h"


@interface ChatViewController ()

@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibNameAndItems:(NSArray *) items
{
    self = [super initWithNibName:@"ChatViewController" bundle:nil];
    if (self) {
        // Custom initialization
        
        _items = [[NSMutableArray alloc] initWithArray:items];
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeAction:)];
    [[self navigationItem] setRightBarButtonItem:composeButton];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor clearColor];
    _myTableView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    imageView.contentMode = UIViewContentModeBottom;
    _myTableView.backgroundView = imageView;
}


- (void) viewDidUnload {
    
    [self setMyTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)viewWillAppear:(BOOL)animated
{
    // Show a label in the table's footer if there are no messages
	if ([_items count] == 0)
	{
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
		label.text = @"You have no messages";
		label.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
		label.textAlignment = NSTextAlignmentCenter;
		//label.textColor = [UIColor colorWithRed:76.0f/255.0f green:86.0f/255.0f blue:108.0f/255.0f alpha:1.0f];
        label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		_myTableView.tableFooterView = label;
	}
	else
	{
		[self scrollToNewestMessage];
	}
    [super viewWillAppear:animated];
}


/*
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
*/

#pragma mark - Actions

- (void) composeAction:(id)sender
{
	// Show the Compose screen
	ComposeViewController* composeController = [[ComposeViewController alloc] initWithNibName:@"ComposeViewController" bundle:nil];
    RootViewController *rootViewController = (RootViewController *)[[self.navigationController viewControllers] objectAtIndex:0];
    
    composeController.delegate = rootViewController;
    composeController.channel = self.title;
	[self.navigationController presentViewController:composeController animated:YES completion:nil];
}


- (void) scrollToNewestMessage
{
	// The newest message is at the bottom of the table
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:([_items count] - 1) inSection:0];
    
	[_myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (int)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"MessageCellIdentifier";
    
	MessageTableViewCell* cell = (MessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *message = [_items objectAtIndex:indexPath.row];
    [cell setMessage:message];
    
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	// This function is called before cellForRowAtIndexPath, once for each cell.
	// We calculate the size of the speech bubble here and then cache it in the
	// Message object, so we don't have to repeat those calculations every time
	// we draw the cell. We add 16px for the label that sits under the bubble.
    
	NSDictionary *message = [_items objectAtIndex:[indexPath row]];
    CGSize bubbleSize = [SpeechBubbleView sizeForText:[message objectForKey:@"Message"]];
    
	return bubbleSize.height + 16;
}


- (void) didReceiveMessage:(NSDictionary *) messageDict OnChannel:(NSString *) channel
{
	// This method is called when the user presses Save in the Compose screen,
	// but also when a push notification is received. We remove the "There are
	// no messages" label from the table view's footer if it is present, and
	// add a new row to the table view with a nice animation.
    
    //NSDictionary *msgDictionary = [[NSDictionary alloc] initWithObjectsAndKeys: myNickName, @"NickName", message, @"Message", [NSDate date], @"Date", [NSNumber numberWithBool:YES], @"isFromUser", nil];
    
    [_items addObject:messageDict];
    
    if ([self isViewLoaded])
    {
        _myTableView.tableFooterView = nil;
        [_myTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:([_items count] - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [self scrollToNewestMessage];
    }
}


@end
