//
//  UIFont+Theme.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "UIFont+Theme.h"

@implementation UIFont (Theme)

+ (UIFont *)themeFontStandardSize {
    return [self themeFontWithSize:18];
}

#pragma mark - Private

+ (UIFont *)themeFontWithSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size];
}

@end
