//
//  ThemedTextField.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "ThemedTextField.h"
#import "UIColor+Theme.h"
#import "UIFont+Theme.h"

@implementation ThemedTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = [UIColor themeBlueColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = true;
    self.font = [UIFont themeFontStandardSize];
    self.borderStyle = UITextBorderStyleLine;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 25, 15);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 25, 15);
}

@end
