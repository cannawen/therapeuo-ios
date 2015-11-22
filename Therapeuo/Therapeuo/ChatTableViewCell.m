//
//  ChatTableViewCell.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "Message.h"
#import "UIColor+Theme.h"

@interface ChatTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation ChatTableViewCell

+ (UINib *)leftMessageNib {
    return [UINib nibWithNibName:[self leftMessageIdentifierString] bundle:nil];
}

+ (UINib *)rightMessageNib {
    return [UINib nibWithNibName:[self rightMessageIdentifierString] bundle:nil];
}

+ (NSString *)leftMessageIdentifierString {
    return @"LeftChatTableViewCell";
}

+ (NSString *)rightMessageIdentifierString {
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
        leftSizingCell = [self loadViewFromNibNamed:[self leftMessageIdentifierString]];
        rightSizingCell = [self loadViewFromNibNamed:[self rightMessageIdentifierString]];
    });
    
    if (viewModel.isDoctorMessage) {
        [rightSizingCell configureWithViewModel:viewModel];
        return rightSizingCell;
    } else {
        [leftSizingCell configureWithViewModel:viewModel];
        return leftSizingCell;
    }
}

- (void)configureWithViewModel:(ChatCellViewModel *)viewModel {
    self.messageLabel.text = viewModel.messageString;
    if (viewModel.isMyMessage) {
        self.messageLabel.backgroundColor = [UIColor themeBlueColor];
    }
}

@end

@interface ChatCellViewModel ()

@property (nonatomic) BOOL isDoctorMessage;
@property (nonatomic) BOOL isMyMessage;
@property (nonatomic) NSString *messageString;

@end

@implementation ChatCellViewModel

+ (instancetype)viewModelFromMessage:(Message *)message {
    ChatCellViewModel *viewModel = [ChatCellViewModel new];
    viewModel.messageString = message.content;
    return viewModel;
}

@end
