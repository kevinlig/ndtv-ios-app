//
//  LegalInfoView.m
//  Notre Dame Television
//
//  Created by Kevin Li on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LegalInfoView.h"

@implementation LegalInfoView

@synthesize legalInfo;

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
    
    // load the application version and display it with the legal notices
    NSString *standardText = legalInfo.text;
    legalInfo.text = [NSString stringWithFormat:@"This is the Notre Dame Television app for iOS, version %@.\n\nThis app is copyright \u00A9 2012 by Kevin Li.\n\n%@",[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"],standardText];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Close button
- (IBAction)closeView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
