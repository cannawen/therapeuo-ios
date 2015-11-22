//
//  Patient.m
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "Patient.h"

@interface Patient ()

@property (nonatomic, strong) NSString *patientId;
@property (nonatomic, strong) NSString *locationDescription;
@property (nonatomic, strong) NSArray *location;

@end

@implementation Patient

#pragma mark - Data Parsing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"patientId" : @"_id",
             @"locationDescription" : @"locationDescription",
             @"location" : @"location",
             };
}

@end
