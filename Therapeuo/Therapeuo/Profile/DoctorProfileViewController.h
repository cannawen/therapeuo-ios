//
//  ProfileViewController.h
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Doctor;

@interface DoctorProfileViewController : UIViewController

-(void)configureWithDoctor:(Doctor *)doctor;

@end
