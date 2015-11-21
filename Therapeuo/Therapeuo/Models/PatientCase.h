//
//  PatientCase.h
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Case;

@interface PatientCase : NSObject

@property (nonatomic, readonly) Case *patientCase;
@property (nonatomic, readonly) NSArray *messages;

@end
