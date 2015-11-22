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
#import "Case.h"
#import "Message.h"

#import "NSArray+PivotalCore.h"

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

#pragma mark - Registration / Login / Logout

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

- (void)logoutDoctorWithId:(NSString *)doctorId
                   success:(SuccssBlock)success
                   failure:(FailureBlock)failure {
    [self.sessionManager DELETE:[NSString stringWithFormat:@"doctors/%@/logout", doctorId]
                     parameters:nil
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                            NSLog(@"Logout successful");
                            if (success) {
                                success(nil);
                            }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            NSLog(@"Logout failed");
                            if (failure) {
                                failure(error);
                            }
                        }];
}

#pragma mark - Doctor

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

- (void)fetchCasesForDoctorWithId:(NSString *)doctorId
                          success:(SuccssBlock)success
                          failure:(FailureBlock)failure {
    [self.sessionManager GET:[NSString stringWithFormat:@"doctors/%@/cases", doctorId]
                  parameters:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                         NSLog(@"Fetch doctor cases success");
                         NSArray *cases = [responseObject map:^id(NSDictionary *caseJsonResponse) {
                             NSError *error = nil;
                             Case *parsedCase = [MTLJSONAdapter modelOfClass:Case.class fromJSONDictionary:caseJsonResponse error:&error];
                             if (error) {
                                 NSLog(@"Failed to parse doctor %@ case: %@", doctorId, caseJsonResponse);
                                 return [NSNull null];
                             } else {
                                 return parsedCase;
                             }
                         }];
                         if (success) {
                             success(cases);
                         }
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Fetch doctor cases failed");
                         if (failure) {
                             failure(error);
                         }
                     }];
}

#pragma mark - Cases

- (void)fetchCaseWithId:(NSString *)caseId
                success:(SuccssBlock)success
                failure:(FailureBlock)failure {
    [self.sessionManager GET:[NSString stringWithFormat:@"cases/%@", caseId]
                  parameters:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                         NSLog(@"Fetch case success");
                         [self parseModelClass:Case.class
                              fromJsonResponse:responseObject
                                       success:success
                                       failure:failure];
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Fetch case failed");
                         if (failure) {
                             failure(error);
                         }
                     }];
}

- (void)updateTheCase:(Case *)theCase
              success:(SuccssBlock)success
              failure:(FailureBlock)failure {
    NSError *error = nil;
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:theCase error:&error];
    if (error) {
        NSLog(@"Failed to construct JSON for updating case: %@", theCase);
        if (failure) {
            failure(error);
        }
    }
    [self.sessionManager PUT:[NSString stringWithFormat:@"cases/%@", theCase.caseId]
                  parameters:params
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                         NSLog(@"Update case success");
                         if (success) {
                             success(nil);
                         }
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Update case failed");
                         if (failure) {
                             failure(error);
                         }
                     }];
}

- (void)fetchMessagesForCaseWithId:(NSString *)caseId
                           success:(SuccssBlock)success
                           failure:(FailureBlock)failure {
    [self.sessionManager GET:[NSString stringWithFormat:@"cases/%@/messages", caseId]
                  parameters:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                         NSLog(@"Fetch messages success");
                         NSArray *messages = [responseObject map:^id(NSDictionary *messageJsonResponse) {
                             NSError *error = nil;
                             Message *parsedMessage = [MTLJSONAdapter modelOfClass:Message.class fromJSONDictionary:messageJsonResponse error:&error];
                             if (error) {
                                 NSLog(@"Failed to parse case %@ message: %@", caseId, messageJsonResponse);
                                 return [NSNull null];
                             } else {
                                 return parsedMessage;
                             }
                         }];
                         if (success) {
                             success(messages);
                         }
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Fetch messages failed");
                         if (failure) {
                             failure(error);
                         }
                     }];
}

- (void)sendMessageForCaseWithId:(NSString *)caseId
                        doctorId:(NSString *)doctorId
                         success:(SuccssBlock)success
                         failure:(FailureBlock)failure {
//    {
//        "content": "Hello",
//        "doctor": "ID"
//    }
}


#pragma mark - Helpers

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
