//
//  PatientCase.m
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "PatientCase.h"
#import "Patient.h"
#import "Doctor.h"

@interface PatientCase ()

@property (nonatomic, strong) Patient *patient;
@property (nonatomic, strong) NSArray *doctors;
@property (nonatomic, strong) Doctor *primaryDoctor;
@property (nonatomic, assign) BOOL open;
@property (nonatomic, strong) NSString *notes;

@end

@implementation PatientCase

@end
