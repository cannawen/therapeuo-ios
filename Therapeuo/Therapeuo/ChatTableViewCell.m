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
#import "UITableViewCell+Sizing.h"

@interface ChatTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dividerWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLeadingConstraint;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *messageBorders;
@property (weak, nonatomic) IBOutlet UIView *messageView;

@end

@implementation ChatTableViewCell

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([ChatTableViewCell class]) bundle:nil];
}

+ (NSString *)identifierString {
    return NSStringFromClass([ChatTableViewCell class]);
}

+ (ChatTableViewCell *)loadViewFromNibNamed:(NSString *)nibName {
    return [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
}

+ (CGFloat)heightForCellWithWidth:(CGFloat)width viewModel:(ChatCellViewModel *)viewModel {
    static ChatTableViewCell *sizingCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self loadViewFromNibNamed:NSStringFromClass([ChatTableViewCell class])];
    });
    [sizingCell configureWithWidth:width];
    [sizingCell configureWithViewModel:viewModel];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (void)configureWithViewModel:(ChatCellViewModel *)viewModel {
    self.messageLabel.text = viewModel.messageString;
    if (viewModel.isMyMessage) {
        self.messageView.backgroundColor = [[UIColor themeBlueColor] colorWithAlphaComponent:0.25];
    }
    if (viewModel.isPatientMessage) {
        self.messageLeadingConstraint.constant = 10;
        self.messageTrailingConstraint.constant = 75;
    } else {
        self.messageLeadingConstraint.constant = 75;
        self.messageTrailingConstraint.constant = 10;
    }
    
    for (UIView *borderView in self.messageBorders) {
        if (viewModel.isMyMessage) {
            borderView.backgroundColor = [UIColor themeBlueColor];
        } else {
            borderView.backgroundColor = [UIColor grayColor];
        }
    }
}

- (void)configureWithWidth:(CGFloat)width {
    self.frame = CGRectMake(0, 0, width, 44);
    self.dividerWidthConstraint.constant = width;
    self.dividerWidthConstraint.active = YES;
}

@end

@interface ChatCellViewModel ()

@property (nonatomic) Message *message;
@property (nonatomic) BOOL isMyMessage;
@property (nonatomic) NSString *myMessageString;

@end

@implementation ChatCellViewModel

+ (instancetype)viewModelFromMessage:(Message *)message isMyMessage:(BOOL)isMyMessage {
    ChatCellViewModel *viewModel = [ChatCellViewModel new];
    viewModel.message = message;
    viewModel.isMyMessage = isMyMessage;
    return viewModel;
}

+ (instancetype)viewModelFromMyMessage:(NSString *)message {
    ChatCellViewModel *viewModel = [ChatCellViewModel new];
    viewModel.myMessageString = message;
    viewModel.isMyMessage = YES;
    return viewModel;
}

- (NSString *)messageString {
    return self.message.content ? : self.myMessageString;
}

- (BOOL)isPatientMessage {
    return self.myMessageString ? NO : [self.message isSentByPatient];
}

- (BOOL)isDoctorMessage {
    return self.myMessageString ? YES : [self.message isSentByDoctor];
}

@end
