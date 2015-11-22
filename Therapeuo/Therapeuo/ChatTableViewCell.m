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

static CGFloat largeSpace = 90;
static CGFloat smallSpace = 25;

@interface ChatTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftAngleImageView;
@property (weak, nonatomic) IBOutlet UIView *leftAngleBackgroundView;

@property (weak, nonatomic) IBOutlet UIImageView *rightAngleImageView;
@property (weak, nonatomic) IBOutlet UIView *rightAngleBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dividerWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIView *messageView;

@end

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftAngleImageView.image = [UIImage imageNamed:@"speech_angle"];
    self.rightAngleImageView.image = [UIImage imageNamed:@"speech_angle"];
    self.rightAngleImageView.transform = CGAffineTransformMakeRotation(-M_PI);
    self.messageView.layer.cornerRadius = 8.0f;
}

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
    self.messageLabel.textColor = [[UIColor themeBlueColor] darkerColor];
    self.messageLeadingConstraint.constant = largeSpace;
    self.messageTrailingConstraint.constant = smallSpace;
    
    UIColor *mainColor = [[UIColor themeBlueColor] colorWithAlphaComponent:0.5f];
    self.messageView.backgroundColor = mainColor;
    self.leftAngleBackgroundView.backgroundColor = [UIColor clearColor];
    self.rightAngleBackgroundView.backgroundColor = mainColor;
}

- (void)styleForPatientMessage {
    self.messageView.backgroundColor = nil;
    self.messageLabel.textColor = [[UIColor grayColor] darkerColor];
    self.messageLeadingConstraint.constant = smallSpace;
    self.messageTrailingConstraint.constant = largeSpace;
    
    UIColor *mainColor = [[UIColor grayColor] colorWithAlphaComponent:0.25f];
    self.messageView.backgroundColor = mainColor;
    self.rightAngleBackgroundView.backgroundColor = [UIColor clearColor];
    self.leftAngleBackgroundView.backgroundColor = mainColor;
}

- (void)styleForDoctorMessage {
    self.messageView.backgroundColor = nil;
    self.messageLabel.textColor = [UIColor grayColor];
    self.messageLeadingConstraint.constant = largeSpace;
    self.messageTrailingConstraint.constant = smallSpace;
    
    UIColor *mainColor = [[UIColor themeBlueColor] colorWithAlphaComponent:0.1f];
    self.messageView.backgroundColor = mainColor;
    self.leftAngleBackgroundView.backgroundColor = [UIColor clearColor];
    self.rightAngleBackgroundView.backgroundColor = mainColor;
}

- (void)styleForServerMessage {
    self.messageView.backgroundColor = nil;
    self.messageLabel.textColor = [UIColor lightGrayColor];
    self.messageLeadingConstraint.constant = largeSpace;
    self.messageTrailingConstraint.constant = largeSpace;
    
    UIColor *mainColor = [UIColor clearColor];
    self.messageView.backgroundColor = mainColor;
    self.leftAngleBackgroundView.backgroundColor = mainColor;
    self.rightAngleBackgroundView.backgroundColor = mainColor;
}

- (void)styleForUnknown {
    self.messageView.backgroundColor = nil;
    self.messageLabel.textColor = [UIColor lightGrayColor];
    self.messageLeadingConstraint.constant = 0;
    self.messageTrailingConstraint.constant = 0;
    
    UIColor *mainColor = [UIColor clearColor];
    self.messageView.backgroundColor = mainColor;
    self.leftAngleBackgroundView.backgroundColor = mainColor;
    self.rightAngleBackgroundView.backgroundColor = mainColor;
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
