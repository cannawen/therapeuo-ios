//
//  Recipient.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "Recipient.h"

@interface Recipient ()

@property (nonatomic, readwrite) RecipientType type;
@property (nonatomic, strong, readwrite) NSString *recipientId;

@end

@implementation Recipient


#pragma mark - Data Parsing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"recipientId" : @"_id",
             @"type" : @"_type",
             };
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"Doctor": @(RecipientTypeDoctor),
                                                                           @"Patient": @(RecipientTypePatient),
                                                                           }];
}

@end
