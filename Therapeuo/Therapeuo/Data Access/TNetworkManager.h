//
//  TNetworkManager.h
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TConstants.h"

@interface TNetworkManager : NSObject

+ (instancetype)sharedInstance;

- (void)registerWithEmail:(NSString *)email
                     name:(NSString *)name
                 password:(NSString *)password
                  success:(SuccssBlock)success
                  failure:(FailureBlock)failure;

@end
