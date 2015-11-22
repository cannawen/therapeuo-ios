//
//  VerboseCase.h
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "TBaseModel.h"

@class Case;
@class Patient;
@class Doctor;
@class Message;

@interface VerboseCase : TBaseModel

@property (nonatomic, strong) Case *theCase;
@property (nonatomic, strong) NSArray *messages;

+ (instancetype)instanceWithCase:(Case *)theCase
                        messages:(NSArray *)messages;

- (id)senderForMessage:(Message *)message; // either a Patient or Doctor object

@end
