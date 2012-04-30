//
//  NDTVNotifyView.h
//  Notre Dame Television
//
//  Created by Kevin Li on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderCell.h"
#import "LegalInfoView.h"
#import "MessageCenter.h"
#import "MBProgressHUD.h"

@interface NDTVNotifyView : UIViewController <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate> {
    IBOutlet UITableView *remindTable;
    IBOutlet UILabel *noReminders;
    MessageCenter *messageCenter;
    LegalInfoView *legalView;
    MBProgressHUD *HUD;
    int showMessage;
}

@property (retain, nonatomic) IBOutlet UITableView *remindTable;
@property (retain, nonatomic) IBOutlet UILabel *noReminders;
@property (retain, nonatomic) MessageCenter *messageCenter;
@property (retain, nonatomic) LegalInfoView *legalView;
@property (retain, nonatomic) MBProgressHUD *HUD;
@property int showMessage;

- (void)cancelButton:(id)sender event:(id)event;
- (void)displayUpdateMessage;

- (IBAction)showLegal:(id)sender;

- (void)becameActive:(NSNotification *)pNotification;

@end
