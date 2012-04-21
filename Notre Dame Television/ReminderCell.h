//
//  ReminderCell.h
//  Notre Dame Television
//
//  Created by Kevin Li on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderCell : UITableViewCell {
    IBOutlet UILabel *remindDay;
    IBOutlet UILabel *remindTime;
    IBOutlet UILabel *remindShow;
    IBOutlet UIButton *cancelButton;
}

@property (retain, nonatomic) IBOutlet UILabel *remindDay;
@property (retain, nonatomic) IBOutlet UILabel *remindTime;
@property (retain, nonatomic) IBOutlet UILabel *remindShow;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;


@end
