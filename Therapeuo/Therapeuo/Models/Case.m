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

@interface Case ()

@property (nonatomic, strong) NSString *caseId;
@property (nonatomic, strong) NSArray *doctorIds;
@property (nonatomic, assign) BOOL open;
@property (nonatomic, strong) NSString *patientId;
@property (nonatomic, strong) NSString *primaryDoctorId;

@property (nonatomic, strong) NSString *notes;

@end

@implementation Case

#pragma mark - Data Parsing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"caseId" : @"_id",
             @"doctorIds" : @"doctors",
             @"open" : @"open",
             @"patientId" : @"patient",
             @"primaryDoctorId" : @"primary",
             //notes
             };
}

+ (NSValueTransformer *)openJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

@end
