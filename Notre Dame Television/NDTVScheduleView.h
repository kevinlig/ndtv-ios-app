//
//  NDTVScheduleView.h
//  Notre Dame Television
//
//  Created by Kevin Li on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleTableCell.h"
#import "ScheduleGrabber.h"
#import "ImageDownload.h"
#import "MBProgressHUD.h"
#import "ShowDetailView.h"
#import "MessageCenter.h"

@interface NDTVScheduleView : UIViewController <UITableViewDelegate, UITableViewDataSource, ImageDownloadDelegate, UIScrollViewDelegate, MBProgressHUDDelegate> {
    IBOutlet UITableView *scheduleTable;
    ScheduleGrabber *grabber;
    NSMutableDictionary *showData;
    NSMutableDictionary *logoCollection;
    NSIndexPath *nowIndex;
    int userSelected;
    IBOutlet UIButton *sunButton;
    IBOutlet UIButton *monButton;
    IBOutlet UIButton *tuesButton;
    IBOutlet UIButton *wedButton;
    IBOutlet UIButton *thursButton;
    IBOutlet UIButton *friButton;
    IBOutlet UIButton *satButton;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UILabel *loadingLabel;
    MBProgressHUD *HUD;
    ShowDetailView *detailView;
    MessageCenter *messageCenter;
    int errorInt;
    int showingToday;
    int loading;
    int currentDay;
    int firstLoad;
}

@property (retain, nonatomic) IBOutlet UITableView *scheduleTable;
@property (retain, nonatomic) ScheduleGrabber *grabber;
@property (retain, nonatomic) NSMutableDictionary *showData;
@property (retain, nonatomic) NSMutableDictionary *logoCollection;
@property (retain, nonatomic) NSIndexPath *nowIndex;
@property (retain, nonatomic) IBOutlet UIButton *sunButton;
@property (retain, nonatomic) IBOutlet UIButton *monButton;
@property (retain, nonatomic) IBOutlet UIButton *tuesButton;
@property (retain, nonatomic) IBOutlet UIButton *wedButton;
@property (retain, nonatomic) IBOutlet UIButton *thursButton;
@property (retain, nonatomic) IBOutlet UIButton *friButton;
@property (retain, nonatomic) IBOutlet UIButton *satButton;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (retain, nonatomic) IBOutlet UILabel *loadingLabel;
@property (retain, nonatomic) MBProgressHUD *HUD;
@property (retain, nonatomic) ShowDetailView *detailView;
@property (retain, nonatomic) MessageCenter *messageCenter;
@property int userSelected;
@property int errorInt;
@property int showingToday;
@property int loading;
@property int currentDay;
@property int firstLoad;
@property int showMessage;

- (void) updateSchedule:(int)dayNumber;
- (void)scrollToNow;
- (void)colorTodayButton;
- (int)returnDayNumber;
- (NSString *)lookupDayNumber:(int)dayNumber;
- (int)alertTime:(NSString *)inputTime;
- (int)currentTime;
- (IBAction)selectDate:(id)sender;
- (void)displayUpdateMessage;

- (void)receivedUpdate:(NSNotification *)pNotification;
- (void)becameActive:(NSNotification *)pNotification;
- (void)showError:(NSNotification *)pNotification;

@end
