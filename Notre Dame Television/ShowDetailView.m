//
//  ShowDetailView.m
//  Notre Dame Television
//
//  Created by Kevin Li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowDetailView.h"

@implementation ShowDetailView

@synthesize titleBar, showName, broadcastTime, showLogo, showDetails, nowBadge, imageURL, downloadQueue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    showDetails.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    // download the show logo
    downloadQueue = [NSMutableDictionary dictionary];
    ImageDownload *downloader = [downloadQueue objectForKey:0];
    downloader = [[ImageDownload alloc]init];
    downloader.delegate = self;
    // we need to pass an index path because this object was originally designed to download
    // images for table views
    // in the absence of table views, we'll manually set the equivalent to the first cell
    downloader.indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [downloadQueue setObject:downloader forKey:[NSIndexPath indexPathForRow:0 inSection:1]];
    [downloader downloadURL:imageURL];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Image download delegate
- (void)showLogoDidLoad:(NSIndexPath *)indexPath {
    ImageDownload *downloader = [downloadQueue objectForKey:[NSIndexPath indexPathForRow:0 inSection:1]];
    showLogo.image = downloader.showLogo;
}

#pragma mark - Methods
- (IBAction)closeWindow:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
