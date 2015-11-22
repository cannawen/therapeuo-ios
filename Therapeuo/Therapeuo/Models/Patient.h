//
//  Patient.h
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "TBaseModel.h"
#import <CoreLocation/CoreLocation.h>

@interface Patient : TBaseModel

@property (nonatomic, readonly) NSString *patientId;
@property (nonatomic, readonly) CLLocationCoordinate2D location;

@end
