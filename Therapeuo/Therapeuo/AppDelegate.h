//
//  AppDelegate.h
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSInjector;
@protocol BSModule;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<BSInjector> injector;
@property (strong, nonatomic) id<BSModule> module;

@end

