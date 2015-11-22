//
//  Message.m
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "Message.h"
#import "Recipient.h"

@interface Message ()

@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *caseId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *receivers;
@property (nonatomic, strong) Recipient *sender;
@property (nonatomic, strong) NSNumber *timestamp; //should switch this to NSDate transformer?

@end

@implementation Message

#pragma mark - Data Parsing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"messageId" : @"_id",
             @"caseId" : @"case",
             @"content" : @"content",
             @"receivers" : @"receivers",
             @"sender" : @"sender",
             @"timestamp" : @"timestamp",
             };
}

+ (NSValueTransformer *)receiversJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:Recipient.class];
}

+ (NSValueTransformer *)senderJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Recipient.class];
}

- (BOOL)isSentByDoctor {
    return self.sender.type == RecipientTypeDoctor;
}

- (BOOL)isSentByPatient {
    return self.sender.type == RecipientTypePatient;
}

- (BOOL)isSentByServer {
    return self.sender.type == RecipientTypeServer;
}

@end
