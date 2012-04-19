//
//  ImageDownload.m
//  Notre Dame Television
//
//  Created by Kevin Li on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageDownload.h"

@implementation ImageDownload

@synthesize indexPath,showLogo,delegate;

- (void)downloadURL:(NSString *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *returnData, NSError *error) {
        if (returnData != nil && error == nil) {
            showLogo = [[UIImage alloc]initWithData:returnData];
            [delegate showLogoDidLoad:self.indexPath];
        }
    }];

}

@end
