//
//  UITableViewCell+Sizing.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "UITableViewCell+Sizing.h"

@implementation UITableViewCell (Sizing)

//This isn't working.
- (CGFloat)heightOfViewFromWidth:(CGFloat)width {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGSize size;
    self.frame = CGRectMake(0, 0, width, 44);
    NSLayoutConstraint *temporaryWidthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
    [self addConstraint:temporaryWidthConstraint];
    
    [self layoutSubviews];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    [self removeConstraint:temporaryWidthConstraint];
    
    return size.height;
}

@end
