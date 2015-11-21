//
//  TNetworkManager.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <Blindside.h>
#import "MTLJSONAdapter.h"
#import "TNetworkManager.h"
#import "TSessionManager.h"

#import "Doctor.h"

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
                          NSLog(@"Registration success");
                          [self parseModelClass:Doctor.class
                               fromJsonResponse:responseObject
                                        success:success
                                        failure:failure];
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Registration failed with error: %@", error);
                          if (failure) {
                              failure(error);
                          }
                      }];
}

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(SuccssBlock)success
               failure:(FailureBlock)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:email forKey:@"email"];
    [params setValue:password forKey:@"password"];
    [self.sessionManager POST:@"doctors/login"
                   parameters:params
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                          NSLog(@"Log-in success with status: %@", responseObject[@"success"]);
                          [self parseModelClass:Doctor.class
                               fromJsonResponse:responseObject[@"doctor"]
                                        success:success
                                        failure:failure];
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Log-in failed with error: %@", error);
                          if (failure) {
                              failure(error);
                          }
                      }];
}

- (void)fetchDoctorWithId:(NSString *)doctorId
                  success:(SuccssBlock)success
                  failure:(FailureBlock)failure {
    [self.sessionManager GET:[NSString stringWithFormat:@"doctors/%@", doctorId]
                  parameters:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                         NSLog(@"Fetching doctor success");
                         [self parseModelClass:Doctor.class
                              fromJsonResponse:responseObject
                                       success:success
                                       failure:failure];
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Fetching doctor failed with error: %@", error);
                         if (failure) {
                             failure(error);
                         }
                     }];
}

- (void)updateDoctor:(Doctor *)doctor
             success:(SuccssBlock)success
             failure:(FailureBlock)failure {
    NSError *error = nil;
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:doctor error:&error];
    if (error) {
        NSLog(@"Failed to construct JSON for updating doctor: %@", doctor);
        if (failure) {
            failure(error);
        }
    }
    [self.sessionManager PUT:[NSString stringWithFormat:@"doctors/%@", doctor.doctorId]
                   parameters:params
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                          NSLog(@"Update doctor success with status: %@", responseObject[@"success"]);
                          [self parseModelClass:Doctor.class
                               fromJsonResponse:responseObject[@"doctor"]
                                        success:success
                                        failure:failure];
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Update doctor failed with error: %@", error);
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
        NSLog(@"Failed to parse class: %@", NSStringFromClass(modelClass));
        failure(error);
    }
}

@end
