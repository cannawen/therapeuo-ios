//
//  Case.m
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "Case.h"
#import "Patient.h"
#import "Doctor.h"

#import "NSArray+PivotalCore.h"

@interface Case ()

@property (nonatomic, strong) NSString *caseId;
@property (nonatomic, strong) NSArray *doctors;
@property (nonatomic, assign) BOOL open;
@property (nonatomic, strong) Patient *patient;
@property (nonatomic, strong) NSString *primaryDoctorId;
@property (nonatomic, strong) NSString *notes;

@end

@implementation Case

- (Doctor *)primaryDoctor {
    return [[self.doctors filter:^BOOL(Doctor *doctor) {
        return [doctor.doctorId isEqualToString:self.primaryDoctorId];
    }] firstObject];
}

#pragma mark - Data Parsing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"caseId" : @"_id",
             @"doctors" : @"doctors",
             @"open" : @"open",
             @"patient" : @"patient",
             @"primaryDoctorId" : @"primary",
             @"notes" : @"notes",
             };
}

+ (NSValueTransformer *)openJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)doctorsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:Doctor.class];
}

+ (NSValueTransformer *)patientJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Patient.class];
}

@end
