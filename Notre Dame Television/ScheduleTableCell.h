//
//  ScheduleTableCell.h
//  Notre Dame Television
//
//  Created by Kevin Li on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleTableCell : UITableViewCell {
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *showTitle;
    IBOutlet UILabel *programDesc;
    IBOutlet UIImageView *showLogo;
    IBOutlet UIImageView *nowBadge;
}

@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *showTitle;
@property (retain, nonatomic) IBOutlet UILabel *programDesc;
@property (retain, nonatomic) IBOutlet UIImageView *showLogo;
@property (retain, nonatomic) IBOutlet UIImageView *nowBadge;

@end
