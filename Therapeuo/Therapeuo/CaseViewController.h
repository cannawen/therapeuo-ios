//
//  CaseViewController.h
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PatientCase;

@interface CaseViewController : UIViewController

- (void)configureWithPatientCase:(PatientCase *)patientCase;

@end
