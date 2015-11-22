//
//  VerboseCase.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "VerboseCase.h"

#import "Case.h"
#import "Patient.h"
#import "Doctor.h"
#import "Message.h"

#import "NSArray+PivotalCore.h"

@interface VerboseCase ()

@property (nonatomic, strong) Case *theCase;
@property (nonatomic, strong) Patient *patient;
@property (nonatomic, strong) Doctor *primaryDoctor;
@property (nonatomic, strong) NSArray *doctors;
@property (nonatomic, strong) NSArray *messages;

@end

@implementation VerboseCase

- (Doctor *)primaryDoctor {
    return [[self.doctors filter:^BOOL(Doctor *doctor) {
        return [doctor.doctorId isEqualToString:self.theCase.primaryDoctorId];
    }] firstObject];
}

+ (instancetype)instanceWithCase:(Case *)theCase
                         patient:(Patient *)patient
                         doctors:(NSArray *)doctors
                        messages:(NSArray *)messages {
    VerboseCase *verboseCase = [[VerboseCase alloc] init];
    verboseCase.theCase = theCase;
    verboseCase.patient = patient;
    verboseCase.doctors = doctors;
    verboseCase.messages = messages;
    return verboseCase;
}

@end
