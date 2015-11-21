//
//  TDataModule.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <Blindside.h>
#import <ReactiveCocoa.h>
#import "TDataModule.h"
#import "TNetworkManager.h"
#import "TPersistenceManager.h"

#import "Doctor.h"
#import "Case.h"

@interface TDataModule ()

// In memory cache
@property (nonatomic, strong) Doctor *doctor;

@property (nonatomic, strong) TNetworkManager *networkManager;
@property (nonatomic, strong) TPersistenceManager *persistenceManager;

@end

@implementation TDataModule

+ (BSInitializer *)bsInitializer {
    return [BSInitializer initializerWithClass:[self class]
                                      selector:@selector(initWithNetworkManager:
                                                         persistenceManager:)
                                  argumentKeys:
            [TNetworkManager class],
            [TPersistenceManager class],
            nil];;
}

- (instancetype)initWithNetworkManager:(TNetworkManager *)networkManager
                    persistenceManager:(TPersistenceManager *)persistenceManager {
    self = [super init];
    if (self) {
        _networkManager = networkManager;
        _persistenceManager = persistenceManager;
        [_persistenceManager readDoctorSuccess:^(Doctor *result) {
            self.doctor = result;
        } failure:nil];
    }
    return self;
}

#pragma mark - <TNetworkProtocol>

- (void)registerWithName:(NSString *)name
                   email:(NSString *)email
                password:(NSString *)password
                 success:(SuccssBlock)success
                 failure:(FailureBlock)failure {
    [self.networkManager registerWithName:name
                                    email:email
                                 password:password
                                  success:
     ^(Doctor *result) {
         [self storeDoctor:result success:success failure:failure];
     } failure:failure];
}

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(SuccssBlock)success
               failure:(FailureBlock)failure {
    [self.networkManager loginWithEmail:email
                               password:password
                                success:
     ^(Doctor *result) {
         [self storeDoctor:result success:success failure:failure];
     } failure:failure];
}

- (void)fetchDoctorWithId:(NSString *)doctorId
                  success:(SuccssBlock)success
                  failure:(FailureBlock)failure {
    [self.networkManager fetchDoctorWithId:doctorId success:^(Doctor* result) {
        [self storeDoctor:result success:success failure:failure];
    } failure:failure];
}

- (void)updateDoctor:(Doctor *)doctor
             success:(SuccssBlock)success
             failure:(FailureBlock)failure {
    [self.networkManager updateDoctor:doctor success:^(id result) {
        [self storeDoctor:doctor success:success failure:failure];
    } failure:failure];
}

- (void)storeDoctor:(Doctor *)doctor
            success:(SuccssBlock)success
            failure:(FailureBlock)failure {
    [self.persistenceManager writeDoctor:doctor success:^(id _) {
        self.doctor = doctor;
        if (success) {
            success(doctor);
        }
    } failure:failure];
}

- (void)fetchVerboseCaseWithId:(NSString *)caseId
                       success:(SuccssBlock)success
                       failure:(FailureBlock)failure {
    __weak TNetworkManager *weakNetworkManager = self.networkManager;
    [self.networkManager fetchCaseWithId:caseId success:^(Case *resultCase) {
        [weakNetworkManager fetchDoctorWithId:resultCase.primaryDoctorId success:^(Doctor *resultDoctor) {
            // add doctor
            [weakNetworkManager fetchMessagesForCaseWithId:resultCase.caseId success:^(id result) {
                // add message
            } failure:failure];
        } failure:failure];
    } failure:failure];
}

- (void)logoutDoctorWithId:(NSString *)doctorId
                   success:(SuccssBlock)success
                   failure:(FailureBlock)failure {
    [self.networkManager logoutDoctorWithId:doctorId success:^(id _) {
        [self.persistenceManager flushAllSuccess:nil failure:nil];
        if (success) {
            success(nil);
        }
    } failure:failure];
}

#pragma mark - <TPersistenceProtocol>

- (void)readDoctorSuccess:(SuccssBlock)success
                  failure:(FailureBlock)failure {
    if (_doctor) {
        success(_doctor);
    } else {
        [self.persistenceManager readDoctorSuccess:success failure:failure];
    }
}

#pragma mark -

- (id)forwardingTargetForSelector:(SEL)aSelector {
    for (id target in @[self.networkManager ? : [NSNull null],
                        self.persistenceManager ? : [NSNull null]]) {
        if ([target respondsToSelector:aSelector]) {
            return target;
        }
    }
    return nil;
}

@end
