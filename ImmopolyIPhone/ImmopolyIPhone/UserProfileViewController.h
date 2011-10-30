//
//  UserProfileViewController.h
//  ImmopolyIPhone
//
//  Created by Maria Guseva on 30.10.11.
//  Copyright (c) 2011 HTW Berlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController {
    
    IBOutlet UILabel *hello;
    IBOutlet UILabel *bank;
    IBOutlet UILabel *miete;
    IBOutlet UILabel *provision;
}

@property(nonatomic, retain) IBOutlet UILabel *hello;
@property(nonatomic, retain) IBOutlet UILabel *bank;
@property(nonatomic, retain) IBOutlet UILabel *miete;
@property(nonatomic, retain) IBOutlet UILabel *provision;

-(IBAction) goBack;

@end
