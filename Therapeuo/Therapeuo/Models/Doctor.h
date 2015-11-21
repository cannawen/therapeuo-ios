//
//  Doctor.h
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "TBaseModel.h"

@interface Doctor : TBaseModel

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *location;
@property (nonatomic, readonly) BOOL available;
@property (nonatomic, readonly) BOOL assisting;
@property (nonatomic, readonly) NSString *device;

// TODO figure out type for location either string or long/lat
+ (instancetype) doctorWithName:(NSString *)name
                       location:(NSString *)location
                      available:(BOOL)available
                      assisting:(BOOL)assisting
                         device:(NSString *)device;


@end
