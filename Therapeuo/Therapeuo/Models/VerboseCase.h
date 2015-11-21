//
//  VerboseCase.h
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "TBaseModel.h"

@class Patient;
@class Doctor;

@interface VerboseCase : TBaseModel

@property (nonatomic, readonly) Patient *patient;
@property (nonatomic, readonly) Doctor *primaryDoctor;

@end
