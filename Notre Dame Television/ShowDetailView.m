//
//  ShowDetailView.m
//  Notre Dame Television
//
//  Created by Kevin Li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowDetailView.h"

@implementation ShowDetailView

@synthesize titleBar, showName, broadcastTime, showLogo, showDetails, nowBadge, imageURL, downloadQueue, remindButton, remindTime, shortCode, airTime, reminderExists;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    showDetails.backgroundColor = [UIColor clearColor];
    reminderExists = 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewDidAppear:(BOOL)animated {
    // download the show logo
    downloadQueue = [NSMutableDictionary dictionary];
    ImageDownload *downloader = [downloadQueue objectForKey:0];
    downloader = [[ImageDownload alloc]init];
    downloader.delegate = self;
    // we need to pass an index path because this object was originally designed to download
    // images for table views
    // in the absence of table views, we'll manually set the equivalent to the first cell
    downloader.indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [downloadQueue setObject:downloader forKey:[NSIndexPath indexPathForRow:0 inSection:1]];
    [downloader downloadURL:imageURL];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Image download delegate
- (void)showLogoDidLoad:(NSIndexPath *)indexPath {
    ImageDownload *downloader = [downloadQueue objectForKey:[NSIndexPath indexPathForRow:0 inSection:1]];
    showLogo.image = downloader.showLogo;
}

#pragma mark - Methods
- (IBAction)closeWindow:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)scheduleReminder:(id)sender {
    if (reminderExists > 0) {
        // cancel the reminder
        for (UILocalNotification *reminder in [[UIApplication sharedApplication]scheduledLocalNotifications]) {
            NSDictionary *reminderMeta = [reminder.userInfo valueForKey:@"metadata"];
            if ([[reminderMeta objectForKey:@"timestamp"]intValue] == remindTime) {
                // reminder is set to occur at this time
                [[UIApplication sharedApplication]cancelLocalNotification:reminder];
                break;
            }
        }
    }
    else {       
        // create notification
        UILocalNotification *showReminder = [[UILocalNotification alloc]init];
        // set the reminder to occur 5 minutes before broadcast
        showReminder.fireDate = [NSDate dateWithTimeIntervalSince1970:(remindTime-300)];
        showReminder.timeZone = [NSTimeZone localTimeZone];
        showReminder.alertAction = @"view schedule";
        showReminder.alertBody = [NSString stringWithFormat:@"Reminder: %@ will air at %@ on Notre Dame Television - channel 53.", showName.text, airTime];
        showReminder.soundName = UILocalNotificationDefaultSoundName;
        // pass some metadata for later along
        NSString *remindString = [NSString stringWithFormat:@"%i",remindTime];
        NSMutableDictionary *metadata = [NSMutableDictionary dictionaryWithObject:remindString forKey:@"timestamp"];
        [metadata setObject:shortCode forKey:@"shortCode"];
        [metadata setObject:showName.text forKey:@"showName"];
        showReminder.userInfo = [NSDictionary dictionaryWithObject:metadata forKey:@"metadata"];
        
        // schedule the reminder
        [[UIApplication sharedApplication]scheduleLocalNotification:showReminder]; 
    }
    [self setUpRemindButton];
}

- (int)checkIfReminding:(int)timeStamp {
    int found = 0;
    // loop through all scheduled reminders
    for (UILocalNotification *reminder in [[UIApplication sharedApplication]scheduledLocalNotifications]) {
        NSDictionary *reminderMeta = [reminder.userInfo valueForKey:@"metadata"];
        if ([[reminderMeta objectForKey:@"timestamp"]intValue] == timeStamp) {
            // reminder is set to occur at this time
            found = 1;
            break;
        }
    }
    return found;
}

- (void)setUpRemindButton {
    // determine whether show set reminder or cancel reminder button
    int reminderSet = [self checkIfReminding:remindTime];
    if (reminderSet > 0) {
        // reminder has been set
        [remindButton setBackgroundImage:[UIImage imageNamed:@"cancel_remind"] forState:UIControlStateNormal];
        [remindButton setTitle:@"Cancel" forState:UIControlStateNormal];
    }
    else {
        // no reminder set
        [remindButton setBackgroundImage:[UIImage imageNamed:@"remind"] forState:UIControlStateNormal];
        [remindButton setTitle:@"Remind Me" forState:UIControlStateNormal];
    }
    reminderExists = reminderSet;
}

@end
