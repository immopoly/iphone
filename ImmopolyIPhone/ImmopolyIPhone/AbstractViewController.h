//
//  AbstractViewController.h
//  TestAbstractVC
//
//  Created by Tobias Buchholz on 29.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractViewController : UIViewController {
    UIView *helperView;
    UIImageView *helperBackground;
    UIScrollView *helperScroll;
    UIImageView *helperTextImage;
    UIView *helperViewBubble;
    UIButton *btHelperViewIn;
    
    BOOL viewIsVisible;
}

@property(nonatomic, retain) UIView *helperView;
@property(nonatomic, retain) UIView *helperViewBubble;
@property(nonatomic, retain) UIButton *btHelperViewIn;
@property(nonatomic, retain) UIImageView *helperBackground;
@property(nonatomic, retain) UIScrollView *helperScroll;
@property(nonatomic, retain) UIImageView *helperTextImage;
@property(nonatomic, assign) BOOL viewIsVisible;

- (void)initButton;
- (void)initHelperViewWithMode:(int)_infoMode;
- (void)helperViewIn;
- (void)helperViewOut;

@end
