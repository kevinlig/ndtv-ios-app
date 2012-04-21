//
//  MessageCenter.h
//  Notre Dame Television
//
//  Created by Kevin Li on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenter : UIViewController {
    IBOutlet UIImageView *messageIcon;
    IBOutlet UILabel *messageLabel;
}

@property (retain, nonatomic) IBOutlet UIImageView *messageIcon;
@property (retain, nonatomic) IBOutlet UILabel *messageLabel;

- (void)fadeIn;
- (void)fadeOut;
- (void)removeView;

@end
