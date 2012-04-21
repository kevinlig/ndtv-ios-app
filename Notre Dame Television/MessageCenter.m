//
//  MessageCenter.m
//  Notre Dame Television
//
//  Created by Kevin Li on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessageCenter.h"

@implementation MessageCenter

@synthesize messageIcon, messageLabel;

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
    // set clear background
    self.view.backgroundColor = [UIColor clearColor];
    self.view.frame = CGRectMake(0, 381, 320, 30);
    self.view.alpha = 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    // fade in
    [self fadeIn];   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)fadeIn {
    [UIView beginAnimations:@"Fade In" context:nil];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationDelay:1];
    self.view.alpha = 1;
    [UIView commitAnimations];
    // wait for animation, then schedule fade out
    [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(fadeOut) userInfo:nil repeats:NO];
}

- (void)fadeOut {
    [UIView beginAnimations:@"Fade Out" context:nil];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationDelay:5.0];
    self.view.alpha = 0;
    [UIView commitAnimations];
    // wait for animation, then schedule fade out
    [NSTimer scheduledTimerWithTimeInterval:6.5 target:self selector:@selector(removeView) userInfo:nil repeats:NO];
}

- (void)removeView {
    [self.view removeFromSuperview];
}

@end
