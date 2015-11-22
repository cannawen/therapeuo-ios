//
//  ThemedTextField.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "ThemedTextField.h"
#import "UIFont+Theme.h"
#import "ThemeTools.h"

@implementation ThemedTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [ThemeTools applyBlueThemeBorderToView:self];

    self.layer.masksToBounds = true;
    self.font = [UIFont themeFontStandardSize];
    self.borderStyle = UITextBorderStyleLine;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 15);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 15);
}

@end
