//
//  LegalInfoView.h
//  Notre Dame Television
//
//  Created by Kevin Li on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LegalInfoView : UIViewController {
    IBOutlet UITextView *legalInfo;
}
@property (retain, nonatomic) IBOutlet UITextView *legalInfo;

- (IBAction)closeView:(id)sender;

@end
