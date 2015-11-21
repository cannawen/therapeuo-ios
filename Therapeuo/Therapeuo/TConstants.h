
#import <Foundation/Foundation.h>

typedef void (^SuccssBlock)(id result);
typedef void (^FailureBlock)(NSError *error);

// Networking
extern NSString * const kBaseUrlKey;