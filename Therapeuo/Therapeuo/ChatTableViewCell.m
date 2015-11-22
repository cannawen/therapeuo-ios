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

static CGFloat largeSpace = 75;
static CGFloat smallSpace = 10;

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
        [self styleForMyMessage];
    } else if (viewModel.isPatientMessage) {
        [self styleForPatientMessage];
    } else if (viewModel.isDoctorMessage) {
        [self styleForDoctorMessage];
    } else if (viewModel.isServerModel) {
        [self styleForServerMessage];
    } else {
        [self styleForUnknown];
    }
}

- (void)configureWithWidth:(CGFloat)width {
    self.frame = CGRectMake(0, 0, width, 44);
    self.dividerWidthConstraint.constant = width;
    self.dividerWidthConstraint.active = YES;
}

#pragma mark -

- (void)styleForMyMessage {
    self.messageView.backgroundColor = [[UIColor themeBlueColor] colorWithAlphaComponent:0.25];
    self.messageLabel.textColor = [UIColor blackColor];
    self.messageLeadingConstraint.constant = largeSpace;
    self.messageTrailingConstraint.constant = smallSpace;
    [self updateBorderColor:[UIColor themeBlueColor]];
}

- (void)styleForPatientMessage {
    self.messageView.backgroundColor = nil;
    self.messageLabel.textColor = [UIColor blackColor];
    self.messageLeadingConstraint.constant = smallSpace;
    self.messageTrailingConstraint.constant = largeSpace;
    [self updateBorderColor:[UIColor grayColor]];
}

- (void)styleForDoctorMessage {
    self.messageView.backgroundColor = nil;
    self.messageLabel.textColor = [UIColor blackColor];
    self.messageLeadingConstraint.constant = largeSpace;
    self.messageTrailingConstraint.constant = smallSpace;
    [self updateBorderColor:[UIColor grayColor]];
}

- (void)styleForServerMessage {
    self.messageView.backgroundColor = nil;
    self.messageLabel.textColor = [UIColor grayColor];
    self.messageLeadingConstraint.constant = largeSpace;
    self.messageTrailingConstraint.constant = largeSpace;
    [self updateBorderColor:nil];
}

- (void)styleForUnknown {
    self.messageView.backgroundColor = nil;
    self.messageLabel.textColor = [UIColor grayColor];
    self.messageLeadingConstraint.constant = 0;
    self.messageTrailingConstraint.constant = 0;
    [self updateBorderColor:[UIColor redColor]];
}

- (void)updateBorderColor:(UIColor *)borderColor {
    for (UIView *borderView in self.messageBorders) {
        borderView.backgroundColor = borderColor;
    }
}

@end

@interface ChatCellViewModel ()

@property (nonatomic) Message *message;
@property (nonatomic) BOOL isMyMessage;
@property (nonatomic) NSString *myMessageString;

@end

@implementation ChatCellViewModel

- (void)setMessage:(Message *)message {
    _message = message;
}

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

- (void)invalidateMessage {
    self.myMessageString = self.message.content;
    self.message = nil;
    self.isMyMessage = NO;
}

- (NSString *)messageString {
    return self.message.content ? : self.myMessageString;
}

- (BOOL)isPatientMessage {
    return [self.message isSentByPatient];
}

- (BOOL)isDoctorMessage {
    return self.myMessageString ? YES : [self.message isSentByDoctor];
}

- (BOOL)isServerModel {
    return [self.message isSentByServer];
}

@end
