
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^SuccssBlock)(id result);
typedef void (^FailureBlock)(NSError *error);

// Networking
extern NSString * const kBaseUrlKey;

extern NSString * const kDeviceTokenKey;
extern CGFloat animationDuration;