//
//  ImageDownload.h
//  Notre Dame Television
//
//  Created by Kevin Li on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageDownloadDelegate;

@interface ImageDownload : NSObject {
    NSIndexPath *indexPath;
    UIImage *showLogo;
    id <ImageDownloadDelegate> delegate;
}

@property (retain, nonatomic) NSIndexPath *indexPath;
@property (retain, nonatomic) UIImage *showLogo;
@property (retain, nonatomic) id <ImageDownloadDelegate> delegate;

- (void)downloadURL:(NSString *)url;

@end

@protocol ImageDownloadDelegate <NSObject>

- (void)showLogoDidLoad:(NSIndexPath *)indexPath;

@end