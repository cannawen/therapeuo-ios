
#import "TConstants.h"

@class Doctor;
@class Case;

@protocol TNetworkProtocol <NSObject>
@optional

#pragma mark - Registration / Login / Logout

- (void)registerWithName:(NSString *)name
                   email:(NSString *)email
                password:(NSString *)password
                 success:(SuccssBlock)success
                 failure:(FailureBlock)failure;
- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(SuccssBlock)success
               failure:(FailureBlock)failure;
- (void)logoutDoctorWithId:(NSString *)doctorId
                   success:(SuccssBlock)success
                   failure:(FailureBlock)failure;

#pragma mark - Doctor

- (void)fetchDoctorWithId:(NSString *)doctorId
                  success:(SuccssBlock)success
                  failure:(FailureBlock)failure;
- (void)updateDoctor:(Doctor *)doctor
             success:(SuccssBlock)success
             failure:(FailureBlock)failure;
- (void)fetchCasesForDoctorWithId:(NSString *)doctorId
                          success:(SuccssBlock)success
                          failure:(FailureBlock)failure;

#pragma mark - Cases

- (void)fetchCaseWithId:(NSString *)caseId
                success:(SuccssBlock)success
                failure:(FailureBlock)failure;
- (void)updateTheCase:(Case *)theCase
              success:(SuccssBlock)success
              failure:(FailureBlock)failure;
- (void)fetchMessagesForCaseWithId:(NSString *)caseId
                           success:(SuccssBlock)success
                           failure:(FailureBlock)failure;
- (void)sendMessageForCaseWithId:(NSString *)caseId
                        doctorId:(NSString *)doctorId
                         success:(SuccssBlock)success
                         failure:(FailureBlock)failure;

@end

@protocol TPersistenceProtocol <NSObject>
@optional

- (void)readDoctorSuccess:(SuccssBlock)success
                  failure:(FailureBlock)failure;
- (void)writeDoctor:(Doctor *)doctor
            success:(SuccssBlock)success
            failure:(FailureBlock)failure;
- (void)flushAllSuccess:(SuccssBlock)success
                failure:(FailureBlock)failure;

@end

@protocol TDataAccessSpecialProtocol <NSObject>
@optional

- (void)fetchVerboseCaseWithId:(NSString *)caseId
                       success:(SuccssBlock)success
                       failure:(FailureBlock)failure;
- (void)logoutSuccess:(SuccssBlock)success
              failure:(FailureBlock)failure;

@end
