//
//  DoctorTableViewCell.h
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-22.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Doctor;

@interface DoctorTableViewCell : UITableViewCell

-(void)configureWithDoctor:(Doctor *)doctor;

@end
