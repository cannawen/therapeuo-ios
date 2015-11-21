//
//  TNetworkManager.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "AppDelegate.h"

#import <Blindside.h>
#import "MTLJSONAdapter.h"
#import "TNetworkManager.h"
#import "TSessionManager.h"

#import "Doctor.h"

@interface TNetworkManager ()

@property (nonatomic, strong) TSessionManager *sessionManager;

@end

@implementation TNetworkManager

+ (instancetype)sharedInstance {
    AppDelegate *appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    return [appDelegate.injector getInstance:[self class]];
}

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

- (void)registerWithName:(NSString *)name
                   email:(NSString *)email
                 password:(NSString *)password
                  success:(SuccssBlock)success
                  failure:(FailureBlock)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:name forKey:@"name"];
    [params setValue:email forKey:@"email"];
    [params setValue:password forKey:@"password"];
    [self.sessionManager POST:@"doctors/register"
                  parameters:params
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                         [self parseModelClass:Doctor.class
                              fromJsonResponse:responseObject
                                       success:success
                                       failure:failure];
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if (failure) {
                             failure(error);
                         }
                     }];
}

- (void)parseModelClass:(Class)modelClass
       fromJsonResponse:(NSDictionary *)jsonResponse
                success:(SuccssBlock)success
                failure:(FailureBlock)failure {
    NSError *error = nil;
    id model = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:jsonResponse error:&error];
    if (!error) {
        if (success) {
            success(model);
        }
    } else {
        failure(error);
    }
}

//Steve - user later to construct json
//NSError *error = nil;
//NSDictionary *JSONDictionary = [MTLJSONAdapter JSONDictionaryFromModel:user error:&error];

@end
