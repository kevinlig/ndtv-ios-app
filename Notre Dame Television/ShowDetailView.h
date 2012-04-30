//
//  ShowDetailView.h
//  Notre Dame Television
//
//  Created by Kevin Li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownload.h"
#import "MBProgressHUD.h"

@interface ShowDetailView : UIViewController <ImageDownloadDelegate, MBProgressHUDDelegate> {
    IBOutlet UINavigationBar *titleBar;
    IBOutlet UILabel *showName;
    IBOutlet UILabel *broadcastTime;
    IBOutlet UIImageView *showLogo;
    IBOutlet UITextView *showDetails;
    IBOutlet UIImageView *nowBadge;
    IBOutlet UIButton *remindButton;
    NSString *imageURL;
    NSMutableDictionary *downloadQueue;
    int remindTime;
    int reminderExists;
    NSString *shortCode;
    NSString *airTime;
    
    MBProgressHUD *HUD;
    
}

@property (retain, nonatomic) IBOutlet UINavigationBar *titleBar;
@property (retain, nonatomic) IBOutlet UILabel *showName;
@property (retain, nonatomic) IBOutlet UILabel *broadcastTime;
@property (retain, nonatomic) IBOutlet UIImageView *showLogo;
@property (retain, nonatomic) IBOutlet UITextView *showDetails;
@property (retain, nonatomic) IBOutlet UIImageView *nowBadge;
@property (retain, nonatomic) IBOutlet UIButton *remindButton;
@property (retain, nonatomic) NSString *imageURL;
@property (retain, nonatomic) NSMutableDictionary *downloadQueue;
@property int remindTime;
@property int reminderExists;
@property (retain, nonatomic) NSString *shortCode;
@property (retain, nonatomic) NSString *airTime;
@property (retain, nonatomic) MBProgressHUD *HUD;

- (IBAction)closeWindow:(id)sender;
- (IBAction)scheduleReminder:(id)sender;
- (int)checkIfReminding:(int)timeStamp;
- (void)setUpRemindButton;

@end
