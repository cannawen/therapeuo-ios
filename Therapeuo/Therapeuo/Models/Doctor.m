//
//  Doctor.m
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "Doctor.h"

@interface Doctor ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, assign) BOOL available;
@property (nonatomic, assign) BOOL assisting;
@property (nonatomic, strong) NSString *device;

@end

@implementation Doctor

+ (instancetype)doctorWithName:(NSString *)name location:(NSString *)location available:(BOOL)available assisting:(BOOL)assisting device:(NSString *)device {
    
    return [[Doctor alloc] initWith:name location:location available:available assisting:assisting device:device];
    
}

- (instancetype)initWith:(NSString *)name location:(NSString *)location available:(BOOL)available assisting:(BOOL)assisting device:(NSString *)device {
 
    if (self = [self init]) {
        self.name = name;
        self.location = location;
        self.available = available;
        self.assisting = assisting;
        self.device = device;
    }
    return self;
}

@end
