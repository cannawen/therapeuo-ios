//
//  VerboseCase.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "VerboseCase.h"

#import "Case.h"
#import "Doctor.h"
#import "Patient.h"
#import "Message.h"
#import "Recipient.h"

#import "NSArray+PivotalCore.h"

@interface VerboseCase ()

@property (nonatomic, strong) Case *theCase;
@property (nonatomic, strong) NSArray *messages;

@end

@implementation VerboseCase

+ (instancetype)instanceWithCase:(Case *)theCase
                        messages:(NSArray *)messages {
    VerboseCase *verboseCase = [[VerboseCase alloc] init];
    verboseCase.theCase = theCase;
    verboseCase.messages = messages;
    return verboseCase;
}

- (id)senderForMessage:(Message *)message {
    NSString *senderId = message.sender.recipientId;
    id sender;
    
    if ([senderId isEqualToString:self.theCase.patient.patientId]) {
        sender = self.theCase.patient;
    } else {
        sender = [[self.theCase.doctors filter:^BOOL(Doctor *doctor) {
            return [senderId isEqualToString:doctor.doctorId];
        }] firstObject];
    }
    return sender;
}

@end
