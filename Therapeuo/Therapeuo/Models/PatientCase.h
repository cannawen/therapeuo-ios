//
//  PatientCase.h
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Patient;
@class Doctor;

@interface PatientCase : NSObject

@property (nonatomic, readonly) Patient *patient;
@property (nonatomic, readonly) NSArray *doctors;
@property (nonatomic, readonly) Doctor *primaryDoctor;
@property (nonatomic, readonly) BOOL open;
@property (nonatomic, readonly) NSString *notes;


@end
