//
//  ScheduleGrabber.m
//  Notre Dame Television
//
//  Created by Kevin Li on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduleGrabber.h"

@implementation ScheduleGrabber

@synthesize scheduleItems;

- (void)downloadSchedulefor:(NSInteger)dayID {
    // grab the JSON schedule data for the day provided
    NSString *urlString = [NSString stringWithFormat:@"http://ndtv.nfshost.com/antenna/schedule.php?day=%i",dayID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    // start the network activity spinner
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    // send the request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *returnData, NSError *error) {
        // handle the resulting data
        if (response != nil && error == nil && returnData != nil) {
            // received a response, parse the JSON
            NSError *jsonError = nil;
            NSDictionary *jsonReturn = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:&jsonError];
            if (jsonReturn != nil && jsonError == nil) {
                // received JSON
                // set the scheduleItems array to the "data" array in the JSON
                scheduleItems = [jsonReturn objectForKey:@"data"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"parseCompleted" object:NULL];
                // stop the network activity spinner
                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
            }
            else {
                // JSON error occurred
                // stop the network activity spinner
                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HUDError" object:NULL];
            }
        }
        else {
            // no response, show error message
            // stop the network activity spinner
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HUDError" object:NULL];
        }
        
        
    }];
}

@end
