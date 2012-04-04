    //
//  BaseViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//
// Copyright (c) 2011 Peter Boctor
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "CustomTabBarController.h"
#import "AppDelegate.h"

@implementation CustomTabBarController
@synthesize button;

- (id)init {
    self = [super init];
    
    if(self != nil){
        // Create new instance of locMg
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    }
    
    return self;
}

// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image
{
  UIViewController* viewController = [[[UIViewController alloc] init] autorelease];
  viewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:title image:image tag:0] autorelease];
  return viewController;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
  button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
  button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];

  CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
  if (heightDifference < 0)
    button.center = self.tabBar.center;
  else
  {
    CGPoint center = self.tabBar.center;
    center.y = center.y - heightDifference/2.0;
    button.center = center;
  }
    
    
  [button addTarget:self action:@selector(centerClicked) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:button];
    
  [self setBackgroundImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    
    
}


-(void) centerClicked{
    [self setSelectedIndex:2];
    [button setBackgroundImage:[UIImage imageNamed:@"tabbar_center_icon_blue.png"] forState:UIControlStateNormal];
    AppDelegate *delegate = [(AppDelegate *) [UIApplication sharedApplication]delegate];
    [delegate setSelectedViewController:[[[delegate tabBarController]viewControllers]objectAtIndex:2]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return NO;
}

- (void) setBackgroundImage:(UIImage *)i {
    // UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,480)];
    //imageView.backgroundColor = [UIColor colorWithPatternImage:i];  
    //[[self view] addSubview:imageView];
    //[[self view] sendSubviewToBack:imageView];
    //[[self view] setOpaque:NO];
    //[[self view] setBackgroundColor:[UIColor clearColor]];
    //[imageView release];
    
    UITabBar *tabBar = [self tabBar];
    if ([tabBar respondsToSelector:@selector(setBackgroundImage:)])
    {
        // ios 5 code here
        [tabBar setBackgroundImage:i];
        
    }
    else
    {
        // ios 4 code here
        
        CGRect frame = CGRectMake(0, 0, 480, 49);
        UIView *tabbg_view = [[UIView alloc] initWithFrame:frame];
        UIImage *tabbag_image = i;
        UIColor *tabbg_color = [[UIColor alloc] initWithPatternImage:tabbag_image];
        tabbg_view.backgroundColor = tabbg_color;
        [tabBar insertSubview:tabbg_view atIndex:0];
        
    }
    
}

@end
