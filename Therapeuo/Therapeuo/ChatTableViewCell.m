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

+ (CGFloat)heightForCellWithWidth:(CGFloat)width viewModel:(ChatCellViewModel *)viewModel {
    static ChatTableViewCell *leftSizingCell;
    static ChatTableViewCell *rightSizingCell;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leftSizingCell = [self loadViewFromNibNamed:[self leftMessageIdentifierString]];
        rightSizingCell = [self loadViewFromNibNamed:[self rightMessageIdentifierString]];
    });
    
    ChatTableViewCell *sizingCell;
    if (viewModel.isDoctorMessage) {
        sizingCell = rightSizingCell;
    } else {
        sizingCell = leftSizingCell;
    }
    [sizingCell configureWithViewModel:viewModel];
    CGSize size = [sizingCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (void)configureWithViewModel:(ChatCellViewModel *)viewModel {
    self.messageLabel.text = viewModel.messageString;
    if (viewModel.isMyMessage) {
        self.messageLabel.backgroundColor = [UIColor themeBlueColor];
    }
}

@end

@interface ChatCellViewModel ()

@property (nonatomic) Message *message;
@property (nonatomic) BOOL isMyMessage;

@end

@implementation ChatCellViewModel

+ (instancetype)viewModelFromMessage:(Message *)message isMyMessage:(BOOL)isMyMessage {
    ChatCellViewModel *viewModel = [ChatCellViewModel new];
    viewModel.message = message;
    viewModel.isMyMessage = isMyMessage;
    return viewModel;
}

- (NSString *)identifier {
    if ([self isDoctorMessage]) {
        return [ChatTableViewCell rightMessageIdentifierString];
    } else {
        return [ChatTableViewCell leftMessageIdentifierString];
    }
}
- (NSString *)messageString {
    return self.message.content;
}

- (BOOL)isPatientMessage {
    return [self.message isSentByPatient];
}

- (BOOL)isDoctorMessage {
    return [self.message isSentByDoctor];
}

@end
