//
//  UIColor+Theme.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "UIColor+Theme.h"

@implementation UIColor (Theme)

+ (UIColor *)themeBlueColor {
    return [UIColor colorWithRed:51/255.0f green:153/255.0f blue:1 alpha:1];
}

- (UIColor *)darkerColor {
    CGFloat r, g, b, alpha;
    if ([self getRed:&r green:&g blue:&b alpha:&alpha])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:alpha];
    return nil;
}

@end
