//
//  ShowDetailView.h
//  Notre Dame Television
//
//  Created by Kevin Li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownload.h"

@interface ShowDetailView : UIViewController <ImageDownloadDelegate> {
    IBOutlet UINavigationBar *titleBar;
    IBOutlet UILabel *showName;
    IBOutlet UILabel *broadcastTime;
    IBOutlet UIImageView *showLogo;
    IBOutlet UITextView *showDetails;
    IBOutlet UIImageView *nowBadge;
    NSString *imageURL;
    NSMutableDictionary *downloadQueue;
    
}

@property (retain, nonatomic) IBOutlet UINavigationBar *titleBar;
@property (retain, nonatomic) IBOutlet UILabel *showName;
@property (retain, nonatomic) IBOutlet UILabel *broadcastTime;
@property (retain, nonatomic) IBOutlet UIImageView *showLogo;
@property (retain, nonatomic) IBOutlet UITextView *showDetails;
@property (retain, nonatomic) IBOutlet UIImageView *nowBadge;
@property (retain, nonatomic) NSString *imageURL;
@property (retain, nonatomic) NSMutableDictionary *downloadQueue;

- (IBAction)closeWindow:(id)sender;

@end