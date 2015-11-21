
#import "TConstants.h"

@protocol TNetworkProtocol <NSObject>
@optional
- (void)registerWithName:(NSString *)name
                   email:(NSString *)email
                password:(NSString *)password
                 success:(SuccssBlock)success
                 failure:(FailureBlock)failure;
@end