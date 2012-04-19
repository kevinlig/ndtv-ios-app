//
//  ScheduleGrabber.h
//  Notre Dame Television
//
//  Created by Kevin Li on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleGrabber : NSObject {
    NSArray *scheduleItems;    
}

@property (retain, nonatomic) NSArray *scheduleItems;

- (void)downloadSchedulefor:(NSInteger)dayID;

@end
