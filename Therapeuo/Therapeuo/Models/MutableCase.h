//
//  MutableCase.h
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Case.h"

@interface MutableCase : Case

@property (nonatomic, copy) NSString *caseId;
@property (nonatomic, copy) NSArray *doctors;
@property (nonatomic, assign) BOOL open;
@property (nonatomic, copy) Patient *patient;
@property (nonatomic, copy) NSString *primaryDoctorId;
@property (nonatomic, copy) NSString *notes;

@end
