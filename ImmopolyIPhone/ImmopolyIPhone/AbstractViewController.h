//
//  AbstractViewController.h
//  TestAbstractVC
//
//  Created by Tobias Buchholz on 29.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
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
    
    BOOL viewIsVisible;
}

@property(nonatomic, retain) UIView *helperView;
@property(nonatomic, retain) UIView *helperViewBubble;
@property(nonatomic, retain) UIButton *btHelperViewIn;
@property(nonatomic, retain) UIImageView *helperBackground;
@property(nonatomic, retain) UIScrollView *helperScroll;
@property(nonatomic, retain) UIImageView *helperTextImage;
@property(nonatomic, assign) BOOL viewIsVisible;
@property(nonatomic, retain) UIButton *linkButton;

- (void)initButton;
- (void)initHelperViewWithMode:(int)_infoMode;
- (void)helperViewIn;
- (void)helperViewOut;
-(void)openImmopolyWeb;

@end
