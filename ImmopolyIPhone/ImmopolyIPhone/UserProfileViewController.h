//
//  UserProfileViewController.h
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 30.10.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataDelegate.h"
#import "LoginDelegate.h"
#import "LoginCheck.h"

@interface UserProfileViewController : UIViewController <UserDataDelegate> {
    
    IBOutlet UILabel *hello;
    IBOutlet UILabel *bank;
    IBOutlet UILabel *miete;
    IBOutlet UILabel *numExposes;
    IBOutlet UILabel *labelBank;
    IBOutlet UILabel *labelMiete;
    IBOutlet UILabel *labelNumExposes;
    IBOutlet UIActivityIndicatorView *spinner;
    
    LoginCheck *loginCheck;
    
    BOOL bagdesViewClosed;
    IBOutlet UIView *badgesView;
    IBOutlet UIButton *showBadgesButton;
    IBOutletCollection(UIImageView) NSArray *badgeImages;
}

@property(nonatomic, retain) IBOutlet UILabel *hello;
@property(nonatomic, retain) IBOutlet UILabel *bank;
@property(nonatomic, retain) IBOutlet UILabel *miete;
@property(nonatomic, retain) IBOutlet UILabel *numExposes;
@property(nonatomic, retain) IBOutlet UILabel *labelBank;
@property(nonatomic, retain) IBOutlet UILabel *labelMiete;
@property(nonatomic, retain) IBOutlet UILabel *labelNumExposes;
@property(nonatomic, retain) LoginCheck *loginCheck;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;

@property(nonatomic, assign) BOOL badgesViewClosed;
@property(nonatomic, retain) IBOutlet UIView *badgesView;
@property(nonatomic, retain) IBOutlet UIButton *showBadgesButton;
@property(nonatomic, retain) IBOutletCollection(UIImageView) NSArray *badgeImages;

-(void) displayUserData;
-(void) hideLabels:(BOOL)_hidden;
-(void) stopSpinnerAnimation;

-(NSString*) formatToCurrencyWithNumber:(double)number;
-(IBAction) toggleBadgesView;
- (void)displayBadges;

@end
