//
//  Recipient.h
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "TBaseModel.h"

typedef NS_ENUM(NSUInteger, RecipientType) {
    RecipientTypeNone = 0,
    RecipientTypeDoctor,
    RecipientTypePatient
};

@interface Recipient : TBaseModel

@property (nonatomic, readonly) RecipientType type;
@property (nonatomic, readonly) NSString *recipientId;

@end
