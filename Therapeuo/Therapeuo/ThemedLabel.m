//
//  ThemedLabel.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "ThemedLabel.h"
#import "UIFont+Theme.h"

@implementation ThemedLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont themeFontStandardSize];
}

@end
