//
//  AppDelegate.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <Blindside.h>
#import "TModule.h"
#import "AppDelegate.h"
#import "TDataModule+Helpers.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (id<BSModule>)module {
    if (!_module) {
        _module = [[TModule alloc] init];
    }
    return _module;
}

- (id<BSInjector>)injector {
    if (!_injector) {
        _injector = [Blindside injectorWithModule:self.module];
    }
    return _injector;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TDataModule sharedInstance]; // calling this to at least load from persistence
    [self setupPush];
    return YES;
}

#pragma mark - Push notification code

- (void)setupPush {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications]; //iOS 8+
    } else {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Did receive notification with userInfo: %@", userInfo);
    NSString *caseId = userInfo[@"case"];
    NSString *messageId = userInfo[@"message"];
}

@end
