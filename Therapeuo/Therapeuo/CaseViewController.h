//
//  CaseViewController.h
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddDoctorsViewController.h"
#import <MapKit/MapKit.h>

@class VerboseCase;

@interface CaseViewController <AddDoctorsViewControllerDelegate, MKMapViewDelegate> : UIViewController

+ (instancetype)viewControllerWithVerboseCase:(VerboseCase *)verboseCase;
@end
