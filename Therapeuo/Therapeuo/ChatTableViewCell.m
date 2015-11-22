//
//  ChatTableViewCell.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "ChatTableViewCell.h"

@interface ChatTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation ChatTableViewCell

+ (instancetype)sizingCellWithWidth:(CGFloat)width viewModel:(ChatCellViewModel *)viewModel  {
    return nil;
}

- (void)configureWithViewModel:(ChatCellViewModel *)viewModel {
    
}

@end

@implementation ChatCellViewModel



@end
