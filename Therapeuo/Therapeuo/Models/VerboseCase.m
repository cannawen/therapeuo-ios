//
//  VerboseCase.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "VerboseCase.h"

#import "Case.h"
#import "Message.h"

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

@end
