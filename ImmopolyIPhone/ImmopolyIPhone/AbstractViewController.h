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
}

@property(nonatomic, retain) UIView *helperView;

- (void)initButton;
- (void)initHelperView;
- (void)helperViewIn;
- (void)helperViewOut;
- (void)setHelperViewTitle:(NSString *)title;

@end
