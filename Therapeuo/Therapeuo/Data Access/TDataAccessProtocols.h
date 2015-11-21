
#import "TConstants.h"

@class Doctor;

@protocol TNetworkProtocol <NSObject>
@optional
- (void)registerWithName:(NSString *)name
                   email:(NSString *)email
                password:(NSString *)password
                 success:(SuccssBlock)success
                 failure:(FailureBlock)failure;
- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(SuccssBlock)success
               failure:(FailureBlock)failure;
- (void)fetchDoctorWithId:(NSString *)doctorId
                  success:(SuccssBlock)success
                  failure:(FailureBlock)failure;
- (void)updateDoctor:(Doctor *)doctor
             success:(SuccssBlock)success
             failure:(FailureBlock)failure;
- (void)fetchCaseForDoctorWithId:(NSString *)doctorId
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
