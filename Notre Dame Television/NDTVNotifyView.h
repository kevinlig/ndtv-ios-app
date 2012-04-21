//
//  NDTVNotifyView.h
//  Notre Dame Television
//
//  Created by Kevin Li on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderCell.h"
#import "MessageCenter.h"

@interface NDTVNotifyView : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *remindTable;
    IBOutlet UILabel *noReminders;
    MessageCenter *messageCenter;
    int showMessage;
}

@property (retain, nonatomic) IBOutlet UITableView *remindTable;
@property (retain, nonatomic) IBOutlet UILabel *noReminders;
@property (retain, nonatomic) MessageCenter *messageCenter;
@property int showMessage;

- (void)cancelButton:(id)sender event:(id)event;
- (void)displayUpdateMessage;

- (void)becameActive:(NSNotification *)pNotification;

@end
