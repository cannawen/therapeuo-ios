
#import "TConstants.h"

@class Doctor;

@protocol TNetworkProtocol <NSObject>
@optional
- (void)registerWithName:(NSString *)name
                   email:(NSString *)email
                password:(NSString *)password
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
@end
