//
//  AbstractViewController.h
//  TestAbstractVC
//
//  Created by Tobias Buchholz on 29.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionItem.h"

#define INFO_IMMOPOLY 0
#define INFO_MAP 1
#define INFO_PORTFOLIO 2
#define INFO_EXPOSE 3
#define INFO_HISTORY 4
#define INFO_USER 5
#define INFO_OTHER_USER 6
#define INFO_FEEDBACK 7


@interface AbstractViewController : UIViewController {
    UIView *helperView;
    UIImageView *helperBackground;
    UIScrollView *helperScroll;
    UIImageView *helperTextImage;
    UIView *helperViewBubble;
    UIButton *btHelperViewIn;
    UIButton *linkButton;
    UIActivityIndicatorView *spinner;
    ActionItem *selectedActionItem;
    
    BOOL viewIsVisible;
}

@property(nonatomic, strong) UIView *helperView;
@property(nonatomic, strong) UIView *helperViewBubble;
@property(nonatomic, strong) UIButton *btHelperViewIn;
@property(nonatomic, strong) UIImageView *helperBackground;
@property(nonatomic, strong) UIScrollView *helperScroll;
@property(nonatomic, strong) UIImageView *helperTextImage;
@property(nonatomic, assign) BOOL viewIsVisible;
@property(nonatomic, strong) UIButton *linkButton;
@property(nonatomic, strong) UIActivityIndicatorView *spinner;
@property(nonatomic, strong) ActionItem *selectedActionItem;

- (void)initButton;
- (void)initHelperViewWithMode:(int)_infoMode;
- (void)initSpinner;
- (void)helperViewIn;
- (void)helperViewOut;
- (void)openImmopolyWeb;
- (void)stopSpinnerAnimation;
- (IBAction)performUserAction:(id)sender;

@end
