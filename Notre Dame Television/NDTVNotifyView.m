//
//  NDTVNotifyView.m
//  Notre Dame Television
//
//  Created by Kevin Li on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NDTVNotifyView.h"

@implementation NDTVNotifyView

@synthesize remindTable, noReminders, messageCenter, showMessage, HUD, legalView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Reminders", @"Reminders");
        self.tabBarItem.image = [UIImage imageNamed:@"reminder"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    remindTable.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becameActive:) name:@"applicationActive" object:nil];
    showMessage = 1;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [remindTable reloadData];
    if (showMessage == 1) {
        // only show Message Center if it is the first time the view has been displayed this session
        [self displayUpdateMessage];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[[UIApplication sharedApplication]scheduledLocalNotifications]count] > 0) {
        noReminders.hidden = TRUE;
        return [[[UIApplication sharedApplication]scheduledLocalNotifications] count];
    }
    else {
        noReminders.hidden = FALSE;
        return 0;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"RemindCell";
    ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        // grab the cell view from within ReminderCell
        // create an array of views in ReminderCell
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"ReminderCell" owner:nil options:nil];
        // loop through the views looking for UITableViewCell
        for (UIView *view in views) {
            if ([view isKindOfClass:[UITableViewCell class]]) {
                // found it
                cell = (ReminderCell *)view;
            }
        }
    }
    
    // look up reminder
    UILocalNotification *reminder = [[[UIApplication sharedApplication]scheduledLocalNotifications] objectAtIndex:[indexPath row]];
    // get the metadata we stored in the reminder
    NSDictionary *reminderMetadata = [reminder.userInfo objectForKey:@"metadata"];
    // display it in the table
    cell.remindShow.text = [reminderMetadata objectForKey:@"showName"];
    
    // show the scheduled date
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEEE, MMMM dd"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dayString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[reminderMetadata objectForKey:@"timestamp"]intValue]]];
    cell.remindDay.text = dayString;
    
    // show the scheduled time
    [formatter setDateFormat:@"h:mm a"];
    NSString *timeString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[reminderMetadata objectForKey:@"timestamp"]intValue]]];
    cell.remindTime.text = timeString;
    
    // set cancel button action
    [cell.cancelButton addTarget:self action:@selector(cancelButton:event:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 81;
}

#pragma mark - Cancel button
- (void)cancelButton:(id)sender event:(id)event {
    // identify the row that the button is in based on the touch location
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    // get the location in the table
    CGPoint touchLocation = [touch locationInView:self.remindTable];
    int row = [[remindTable indexPathForRowAtPoint:touchLocation]row];
    
    // cancel the reminder
    UILocalNotification *reminder = [[[UIApplication sharedApplication]scheduledLocalNotifications]objectAtIndex:row];
    [[UIApplication sharedApplication]cancelLocalNotification:reminder];
    
    // display a HUD showing confirmation
    HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hud_undo"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = @"Reminder canceled.";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
    
    [remindTable reloadData];
}

#pragma mark - Message Center
- (void)displayUpdateMessage {
    MessageCenter *msgCtrNib = [[MessageCenter alloc]initWithNibName:@"MessageCenter" bundle:nil];
    messageCenter = msgCtrNib;
    [self.view addSubview:messageCenter.view];
    messageCenter.messageLabel.text = [NSString stringWithFormat:@"Note: Schedules are subject to change."];
    messageCenter.messageIcon.image = [UIImage imageNamed:@"note"];
    messageCenter.messageIcon.frame = CGRectMake(15, 5, 26, 19);
    showMessage = 0;
}

#pragma mark - About/Legal button
- (IBAction)showLegal:(id)sender {
    LegalInfoView *legalViewNib = [[LegalInfoView alloc]initWithNibName:@"LegalInfoView" bundle:nil];
    legalView = legalViewNib;
    [self presentModalViewController:legalView animated:YES];
}

#pragma mark - Internal notifications
- (void)becameActive:(NSNotification *)pNotification {
    // the application was previously inactive, so let's consider this a new "session"
    // we should show the Message Center
    showMessage = 1;
}

@end
