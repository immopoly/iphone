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
    UIView *helperViewBubble;
    UIButton *btHelperViewIn;
}

@property(nonatomic, retain) UIView *helperView;
@property(nonatomic, retain) UIView *helperViewBubble;
@property(nonatomic, retain) UIButton *btHelperViewIn;

- (void)initButton;
- (void)initHelperView;
- (void)helperViewIn;
- (void)helperViewOut;
- (void)setHelperViewTitle:(NSString *)_viewTitle;
- (void)setHelperViewTextWithFile:(NSString *)_fileName;

@end
