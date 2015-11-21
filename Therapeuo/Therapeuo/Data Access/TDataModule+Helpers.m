//
//  TDataModule+Helpers.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "TDataModule+Helpers.h"

#import <Blindside.h>
#import "AppDelegate.h"

@implementation TDataModule (Helpers)

+ (instancetype)sharedInstance {
    AppDelegate *appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    return [appDelegate.injector getInstance:[self class]];
}

@end
