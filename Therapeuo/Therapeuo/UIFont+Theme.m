//
//  UIFont+Theme.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "UIFont+Theme.h"

@implementation UIFont (Theme)

+ (UIFont *)themeFontSmallSize {
    return [self themeFontWithSize:14];
}

+ (UIFont *)themeFontStandardSize {
    return [self themeFontWithSize:18];
}

+ (UIFont *)themeFontLargeSize {
    return [self themeFontWithSize:22];
}

#pragma mark - Private

+ (UIFont *)themeFontWithSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size];
}

@end
