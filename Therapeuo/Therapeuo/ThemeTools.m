//
//  ThemeTools.m
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "ThemeTools.h"
#import "UIColor+Theme.h"

@implementation ThemeTools

+ (void)applyBlueThemeBorderToView:(UIView *)view {
    view.layer.borderColor = [UIColor themeBlueColor].CGColor;
    view.layer.borderWidth = 1.0f;
}

@end
