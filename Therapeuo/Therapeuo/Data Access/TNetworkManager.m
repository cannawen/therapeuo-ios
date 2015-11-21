//
//  TNetworkManager.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <Blindside.h>
#import "TNetworkManager.h"
#import "TSessionManager.h"

@interface TNetworkManager ()

@property (nonatomic, strong) TSessionManager *sessionManager;

@end

@implementation TNetworkManager

+ (BSInitializer *)bsInitializer {
    return [BSInitializer initializerWithClass:[self class]
                                      selector:@selector(initWithSessionManager:)
                                  argumentKeys:
            [TSessionManager class],
            nil];;
}

- (instancetype)initWithSessionManager:(TSessionManager *)sessionManager {
    self = [super init];
    if (self) {
        _sessionManager = sessionManager;
    }
    return self;
}

- (void)registerWithEmail:(NSString *)email
                     name:(NSString *)name
                 password:(NSString *)password
                  success:(SuccssBlock)success
                  failure:(FailureBlock)failure {
    [self.sessionManager PUT:@""
                  parameters:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                         //cast to object here
                         if (success) {
                             success(responseObject);
                         }
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if (failure) {
                             failure(error);
                         }
                     }];
}

@end
