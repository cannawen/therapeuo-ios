//
//  TDataModule.h
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDataAccessProtocols.h"

@class Doctor;

@interface TDataModule : NSObject <TNetworkProtocol>

@property (nonatomic, readonly) Doctor *doctor; //most recent persisted data

@end
