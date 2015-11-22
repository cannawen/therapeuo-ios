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

+ (UINib *)partnerMessageNib {
    return [UINib nibWithNibName:[self partnerMessageIdentifierString] bundle:nil];
}

+ (UINib *)myMessageNib {
    return [UINib nibWithNibName:[self myMessageIdentifierString] bundle:nil];
}

+ (NSString *)partnerMessageIdentifierString {
    return @"LeftChatTableViewCell";
}

+ (NSString *)myMessageIdentifierString {
    return @"RightChatTableViewCell";
}

+ (ChatTableViewCell *)loadViewFromNibNamed:(NSString *)nibName {
    return [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
}

+ (instancetype)sizingCellWithWidth:(CGFloat)width viewModel:(ChatCellViewModel *)viewModel {
    static ChatTableViewCell *leftSizingCell;
    static ChatTableViewCell *rightSizingCell;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leftSizingCell = [self loadViewFromNibNamed:[self partnerMessageIdentifierString]];
        rightSizingCell = [self loadViewFromNibNamed:[self myMessageIdentifierString]];
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
    self.messageLabel.text = viewModel.message;
}

@end

@interface ChatCellViewModel ()

@property (nonatomic) BOOL isMySentMessage;
@property (nonatomic) NSString *message;

@end

@implementation ChatCellViewModel

+ (instancetype)viewModelWithMessage:(NSString *)message isMySentMessage:(BOOL)isMySentMessage {
    ChatCellViewModel *viewModel = [ChatCellViewModel new];
    viewModel.message = message;
    viewModel.isMySentMessage = isMySentMessage;
    return viewModel;
}

@end
