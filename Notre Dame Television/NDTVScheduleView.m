//
//  NDTVScheduleView.m
//  Notre Dame Television
//
//  Created by Kevin Li on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NDTVScheduleView.h"

@implementation NDTVScheduleView

@synthesize scheduleTable, grabber, showData, logoCollection, nowIndex, userSelected;

@synthesize sunButton, monButton, tuesButton, wedButton, thursButton, friButton, satButton;

@synthesize HUD, errorInt, showingToday, loading, currentDay, firstLoad;

@synthesize spinner, loadingLabel;

@synthesize messageCenter, showMessage;

@synthesize detailView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Schedule", @"Schedule");
        self.tabBarItem.image = [UIImage imageNamed:@"calendar"];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedUpdate:) name:@"parseCompleted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becameActive:) name:@"applicationActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showError:) name:@"HUDError" object:nil];
    
    scheduleTable.backgroundColor = [UIColor clearColor];
    [self colorTodayButton];
    currentDay = [self returnDayNumber];
    firstLoad = 1;
    showMessage = 0;

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
    if (loading == 1) {
        // show loading spinner and label
        spinner.hidden = FALSE;
        [spinner startAnimating];
        loadingLabel.hidden = FALSE;
        return 0;
    }
    else if (grabber.scheduleItems == nil) {
        // hide loading spinner and label
        spinner.hidden = TRUE;
        [spinner stopAnimating];
        loadingLabel.hidden = TRUE;
        return 0;
    }
    else {
        // hide loading spinner and label
        spinner.hidden = TRUE;
        [spinner stopAnimating];
        loadingLabel.hidden = TRUE;
        return [grabber.scheduleItems count];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ScheduleCell";
    ScheduleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        // grab the cell view from within ScheduleTableCell
        // create an array of views in ScheduleTableCell
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"ScheduleTableCell_iPhone" owner:nil options:nil];
        // loop through the views looking for UITableViewCell
        for (UIView *view in views) {
            if ([view isKindOfClass:[UITableViewCell class]]) {
                // found it
                cell = (ScheduleTableCell *)view;
            }
        }
    }
    if (grabber.scheduleItems != nil) {
        showData = [NSMutableDictionary dictionary];
        showData = [grabber.scheduleItems objectAtIndex:[indexPath row]];
        // calculate the time
        NSDate *showTime = [NSDate dateWithTimeIntervalSince1970:[[showData objectForKey:@"comptime"]intValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // get the GMT offset
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [formatter setDateFormat:@"h:mm a"];
        [formatter setTimeZone:gmt];
        cell.timeLabel.text = [formatter stringFromDate:showTime];
        cell.nowBadge.hidden = TRUE;
        cell.showTitle.text = [showData objectForKey:@"program"];
        cell.programDesc.text = [showData objectForKey:@"description"];
        
        
        // display a temporary generic logo
        cell.showLogo.image = [UIImage imageNamed:@"generic_logo"];
        
        // download the actual show logo
        ImageDownload *downloader = [[ImageDownload alloc]init];
        downloader.delegate = self;
        downloader.indexPath = indexPath;
        [logoCollection setObject:downloader forKey:indexPath];
        [downloader downloadURL:[showData objectForKey:@"logo"]];        
    }
    else {
        cell.timeLabel.text = @"";
        cell.showLogo.image = nil;
        cell.showTitle.text = @"Loading...";
        cell.programDesc.text = @"";
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (grabber.scheduleItems != nil) {
        ShowDetailView *detailViewNib = [[ShowDetailView alloc]initWithNibName:@"ShowDetailView" bundle:nil];
        self.detailView = detailViewNib;
        // set up the detail view
        NSDictionary *showInformation = [NSDictionary dictionary];
        showInformation = [grabber.scheduleItems objectAtIndex:[indexPath row]];
        [self presentModalViewController:detailView animated:YES];
        detailView.titleBar.topItem.title = [showInformation objectForKey:@"program"];
        detailView.showName.text = [showInformation objectForKey:@"program"];
        detailView.showDetails.text = [showInformation objectForKey:@"description"];
        
        // calculate and show the time
        NSDate *showTime = [NSDate dateWithTimeIntervalSince1970:[[showInformation objectForKey:@"comptime"]intValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // get the GMT offset
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [formatter setDateFormat:@"h:mm a"];
        [formatter setTimeZone:gmt];
        NSString *timeString = [formatter stringFromDate:showTime];
        if (showingToday == 1) {
            detailView.broadcastTime.text = [NSString stringWithFormat:@"Today at %@",timeString];
        }
        else {
            detailView.broadcastTime.text = [NSString stringWithFormat:@"%@ at %@",[self lookupDayNumber:currentDay],timeString];
        }
        detailView.imageURL = [showInformation objectForKey:@"logo"];
        if (showingToday == 1 && [nowIndex row] == [indexPath row]) {
            // this is the currently playing show
            detailView.nowBadge.hidden = FALSE;
        }
        else {
            detailView.nowBadge.hidden = TRUE;
        }
        // get the scheduled time in Unix timestamp form, for the appropriate day
        int scheduleTime = [self alertTime:timeString];
        // only show Remind button if event occurs in next 48 hours and is more than 1 minute from the show
        if ((scheduleTime - [self currentTime]) > 300 && (scheduleTime - [self currentTime]) < 172800) {
            // show Remind button
            detailView.remindButton.hidden = FALSE;
            detailView.remindTime = scheduleTime;
            detailView.shortCode = [showInformation objectForKey:@"showid"];
            detailView.airTime = timeString;
        }
        else {
            detailView.remindButton.hidden = TRUE;
        }
        [detailView setUpRemindButton];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - Image Download delegate method
- (void)showLogoDidLoad:(NSIndexPath *)indexPath {
    ImageDownload *imageData = [logoCollection objectForKey:indexPath];
    // get the cell and convert to a ScheduleTableCell type
    ScheduleTableCell *cell = (ScheduleTableCell *)[self.scheduleTable cellForRowAtIndexPath:imageData.indexPath];
    cell.showLogo.image = imageData.showLogo;
}

#pragma mark - Scroll delegate methods 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // load images after scroll is done, if scrolled to a new area
    NSArray *visibleRows = [scheduleTable indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visibleRows) {
        ImageDownload *imageData = [logoCollection objectForKey:indexPath];
        // get the cell and convert to a ScheduleTableCell type
        ScheduleTableCell *cell = (ScheduleTableCell *)[scheduleTable cellForRowAtIndexPath:imageData.indexPath];
        cell.showLogo.image = imageData.showLogo;
        // show the "now" badge if applicable
        if ([indexPath row] == [nowIndex row] && showingToday == 1) {
            ScheduleTableCell *currentCell = (ScheduleTableCell *)[scheduleTable cellForRowAtIndexPath:indexPath];
            currentCell.nowBadge.hidden = FALSE;
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // scroll animation has ended, check if visible rows are the currently playing show
    NSArray *visibleRows = [scheduleTable indexPathsForVisibleRows];
    int counter = 0;
    while (counter < [visibleRows count]) {
        if ([[visibleRows objectAtIndex:counter]row] == [nowIndex row] && showingToday == 1) {
            // the current row matches the row of the current program
            // show the "now" badge
            ScheduleTableCell *cell = (ScheduleTableCell *)[scheduleTable cellForRowAtIndexPath:[visibleRows objectAtIndex:counter]];
            cell.nowBadge.hidden = FALSE;
            // exit the loop
            counter = [visibleRows count];
        }
        counter++;
    }
}

#pragma mark - Methods
- (void)updateSchedule:(int)dayNumber {
    // don't reload if it's the same date as what is being shown
    // in that case, scroll to top or current show (if today is displayed)
    if (dayNumber == currentDay && firstLoad < 1) {
        [self scrollToNow];
    }
    else {
        if (firstLoad == 1) {
            showMessage = 1;
        }
        firstLoad = 0;
        // show a blank screen while reloading occurs
        loading = 1;
        [scheduleTable reloadData];
        if (dayNumber == [self returnDayNumber]) {
            showingToday = 1;
        }
        currentDay = dayNumber;
        errorInt = 0;
        grabber = [[ScheduleGrabber alloc]init];
        // get day ID
        [grabber downloadSchedulefor:dayNumber];
        // reload dictionary for downloading logos
        self.logoCollection = [NSMutableDictionary dictionary];
    }
}

- (void)scrollToNow {
    if (errorInt == 0 && showingToday == 1) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        NSTimeZone *localTime = [NSTimeZone localTimeZone];
        [formatter setDateFormat:@"h:mm a"];
        [formatter setTimeZone:localTime];
        NSString *currentStringTime = [formatter stringFromDate:[NSDate date]];
        int currentTime = (int) [[formatter dateFromString:currentStringTime] timeIntervalSince1970];
        // get local timezone offset
        //int offset = [localTime secondsFromGMT];
        // loop through the table and compare times
        if (grabber.scheduleItems != nil) {
            int counter = 0;
            int matchedRow = 0;
            int possibilityRank = 0;
            while (counter < [grabber.scheduleItems count]) {

                // create the dictionary with the contents of the schedule item
                NSDictionary *informationDictionary = [NSDictionary dictionary];
                informationDictionary = [grabber.scheduleItems objectAtIndex:counter];
                // get the timestamp object and compare the times
                // calculate the time
                NSDate *showTime = [NSDate dateWithTimeIntervalSince1970:[[informationDictionary objectForKey:@"comptime"]intValue]];
                [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
                NSString *stringTime = [formatter stringFromDate:showTime];
                [formatter setTimeZone:localTime];
                int dataTime = (int)[[formatter dateFromString:stringTime]timeIntervalSince1970];
                // dataTime = dataTime + offset;
                if (currentTime == dataTime) {
                    // exact match, this is what is happening now
                    matchedRow = counter;
                    // found, so exit the loop
                    counter = [grabber.scheduleItems count];
                }
                else if (currentTime > dataTime) {
                    // it is currently after the time listed in the JSON object
                    // it is possible, though not certain that this is the current show
                    possibilityRank = 1;
                    // if this is the last entry, this is the current show
                    if (counter == ([grabber.scheduleItems count]-1)) {
                        matchedRow = counter;
                        counter = [grabber.scheduleItems count];
                    }
                }
                else if (currentTime < dataTime) {
                    // it is currently before the time listed in the JSON object
                    // however, if the previously examined show entry had a time that started after the current time AND this show has not yet started,
                    // then the previous entry must be the current show
                    if (possibilityRank > 0) {
                        matchedRow = counter - 1;
                        // if this was a match, exit the loop
                        counter = [grabber.scheduleItems count];
                    }
                    else {
                        possibilityRank = 0;
                    }
                }
                counter++;
            }
            // create an index path from the matched row
            NSIndexPath *currentItem = [NSIndexPath indexPathForRow:matchedRow inSection:0];
            // scroll to the cell
            [scheduleTable scrollToRowAtIndexPath:currentItem atScrollPosition:UITableViewScrollPositionTop animated:YES];
            // save the indexpath for the current cell so that the "now" badge can be displayed
            // see scroll view delegates for that
            nowIndex = currentItem;
            // make the "now" badge appear, just in case the current show is already in view
            if (showingToday == 1) {
                ScheduleTableCell *cell = (ScheduleTableCell *)[scheduleTable cellForRowAtIndexPath:currentItem];
                cell.nowBadge.hidden = FALSE;
            }
            
        }
    }
    else {
        [scheduleTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

- (void)colorTodayButton {
    int dayNumber = [self returnDayNumber];
    NSArray *buttonArray = [NSArray arrayWithObjects:sunButton, monButton, tuesButton, wedButton, thursButton, friButton, satButton, nil];
    int counter = 0;
    while (counter < [buttonArray count]) {
        UIButton *currentButton = [buttonArray objectAtIndex:counter];
        if (counter == dayNumber) {
            NSString *buttonImage = [NSString stringWithFormat:@"button_today_sel"];
            [currentButton setBackgroundImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
        }
        else {
            NSString *buttonImage = [NSString stringWithFormat:@"button"];
            [currentButton setBackgroundImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
        }
        counter++;
    }
}

- (int)returnDayNumber {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int dayNumber = [components weekday]-1;
    return dayNumber;
}

- (NSString *)lookupDayNumber:(int)dayNumber {
    NSArray *weekDays = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    if (dayNumber < 7) {
        return [weekDays objectAtIndex:dayNumber];
    }
    else {
        NSString *emptyString = [NSString stringWithFormat:@""];
        return emptyString;
    }
}

- (int)alertTime:(NSString *)inputTime {
    int alertTime;
    // calculate how many days away the scheduled item is
    // current date code
    int today = [self returnDayNumber];
    int futureTimestamp;
    if (today == currentDay) {
        // showing an item on today's schedule
        futureTimestamp = [self currentTime];
    }
    else if (today < currentDay) {
        // showing a day in the future
        // increase the current timestamp by 24 hours times the difference in days
        futureTimestamp = [self currentTime] + (86400 * (currentDay - today));
    }
    else if (today > currentDay) {
        // date exists earlier in the week than the current day
        // this means it happens in the next week
        // increment the scheduled date by 7 and then perform above process
        futureTimestamp = [self currentTime] + (86400 * ((currentDay + 7) - today));
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    // display the date for the show
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString *dayString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:futureTimestamp]];
    // let's append the time, from the schedule
    NSString *completeString = [NSString stringWithFormat:@"%@ %@",dayString, inputTime];
    // convert it back to a unix timestamp
    [formatter setDateFormat:@"MM/dd/yyyy h:mm a"];
    alertTime = (int)[[formatter dateFromString:completeString]timeIntervalSince1970];
    return alertTime;
}

- (int)currentTime {
    int currentTime = (int) [[NSDate date]timeIntervalSince1970];
    return currentTime;
}

- (IBAction)selectDate:(id)sender {
    int counter = 0;
    NSArray *arrayButtons = [NSArray arrayWithObjects:sunButton, monButton, tuesButton, wedButton, thursButton, friButton, satButton, nil];
    while (counter < 7) {
        UIButton *currentButton = [arrayButtons objectAtIndex:counter];
        if ([sender isEqual:currentButton]) {
            // this is the current button
            if (counter == [self returnDayNumber]) {
                // the selected button is today
                showingToday = 1;
            }
            else {
                showingToday = 0;
            }
            [self updateSchedule:counter];
            NSString *today = @"";
            if (showingToday == 1) {
                today = @"_today";
            }
            NSString *buttonImage = [NSString stringWithFormat:@"button%@_sel",today];
            if (counter == 6) {
                buttonImage = [NSString stringWithFormat:@"button%@_sel", today];
            }
            [currentButton setBackgroundImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
        }
        else {
            NSString *today = @"";
            if (counter == [self returnDayNumber]) {
                today = @"_today";
            }
            NSString *buttonImage = [NSString stringWithFormat:@"button%@",today];
            if (counter == 6) {
                buttonImage = [NSString stringWithFormat:@"button%@",today];
            }
            [currentButton setBackgroundImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
        }
        counter++;
    }
}

- (void)displayUpdateMessage {
    if (grabber != nil) {
        MessageCenter *msgCtrNib = [[MessageCenter alloc]initWithNibName:@"MessageCenter" bundle:nil];
        messageCenter = msgCtrNib;
        // display the date the schedule was published
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MMMM dd, YYYY"];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString *updateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:grabber.lastUpdate]];
        [self.view addSubview:messageCenter.view];
        messageCenter.messageLabel.text = [NSString stringWithFormat:@"Schedule posted on %@.",updateString];
        messageCenter.messageIcon.image = [UIImage imageNamed:@"updated"];
    }
}

#pragma mark - Internal Notifications
- (void)receivedUpdate:(NSNotification *)pNotification {
    loading = 0;
    [scheduleTable reloadData];
    [self scrollToNow];
    if (showMessage == 1) {
        [self displayUpdateMessage];
        showMessage = 0;
    }
}
- (void)becameActive:(NSNotification *)pNotification {
    showMessage = 1;
    [self updateSchedule:[self returnDayNumber]];
    [self colorTodayButton];
}
- (void)showError:(NSNotification *)pNotification {
    HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hud_X.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = @"An error has occurred.";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
    errorInt = 1;
}

@end
