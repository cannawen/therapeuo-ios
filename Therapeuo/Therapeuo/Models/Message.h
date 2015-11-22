//
//  Message.h
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "TBaseModel.h"

@class Recipient;

@interface Message : TBaseModel

@property (nonatomic, readonly) NSString *messageId;
@property (nonatomic, readonly) NSString *caseId;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) NSArray *receivers;
@property (nonatomic, readonly) Recipient *sender;
@property (nonatomic, readonly) NSNumber *timestamp;

- (BOOL)isSentByDoctor;
- (BOOL)isSentByPatient;

@end
