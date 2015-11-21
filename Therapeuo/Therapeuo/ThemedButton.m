//
//  ThemedButton.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "ThemedButton.h"
#import "UIColor+Theme.h"
#import "UIFont+Theme.h"

@implementation ThemedButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateColors];
    [self setContentEdgeInsets:UIEdgeInsetsMake(15.0, 25.0, 15.0, 25.0)];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    self.titleLabel.font = [UIFont themeFontStandardSize];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateColors];
}

- (void)updateColors {
    UIColor *backgroundColor;
    if (self.enabled) {
        backgroundColor = [UIColor themeBlueColor];
    } else {
        backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0 blue:232/255.0f alpha:1];
    }
    self.backgroundColor = backgroundColor;
    
}

@end
