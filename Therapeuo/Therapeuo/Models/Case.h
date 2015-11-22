//
//  Case.h
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "TBaseModel.h"

@class Patient;

@interface Case : TBaseModel

@property (nonatomic, readonly) NSString *caseId;
@property (nonatomic, readonly) NSArray *doctors;
@property (nonatomic, readonly) BOOL open;
@property (nonatomic, readonly) Patient *patient;
@property (nonatomic, readonly) NSString *primaryDoctorId;
@property (nonatomic, readonly) NSString *notes;

@end
