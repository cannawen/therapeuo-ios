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

+ (UINib *)leftMessageNib {
    return [UINib nibWithNibName:@"LeftChatTableViewCell" bundle:nil];
}

+ (UINib *)rightMessageNib {
    return [UINib nibWithNibName:@"RightChatTableViewCell" bundle:nil];
}

+ (ChatTableViewCell *)loadViewFromNibNamed:(NSString *)nibName {
    return [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
}

+ (instancetype)sizingCellWithWidth:(CGFloat)width viewModel:(ChatCellViewModel *)viewModel {
    static ChatTableViewCell *leftSizingCell;
    static ChatTableViewCell *rightSizingCell;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leftSizingCell = [self loadViewFromNibNamed:@"LeftChatTableViewCell"];
        rightSizingCell = [self loadViewFromNibNamed:@"RightChatTableViewCell"];
    });
    
    if (viewModel.isMySentMessage) {
        [rightSizingCell configureWithViewModel:viewModel];
        return rightSizingCell;
    } else {
        [leftSizingCell configureWithViewModel:viewModel];
        return leftSizingCell;
    }
}

- (void)configureWithViewModel:(ChatCellViewModel *)viewModel {
    
}

@end

@interface ChatCellViewModel ()

@property (nonatomic) BOOL isMySentMessage;

@end

@implementation ChatCellViewModel



@end
