//
//  TAlertHelper.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "TAlertHelper.h"

@implementation TAlertHelper

+ (void)showDefaultError {
    [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                message:@"Something went wrong, please try again later."
                               delegate:nil
                      cancelButtonTitle:@""
                      otherButtonTitles:nil] show];
}

@end
