//
//  AddDoctorsViewController.h
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-22.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Doctor;

@protocol AddDoctorsViewControllerDelegate

-(void)didAddDoctor:(Doctor *)doctors;

@end

@interface AddDoctorsViewController<UIAlertViewDelegate> : UIViewController

@property (nonatomic, weak) id<AddDoctorsViewControllerDelegate> delegate;

@end
