//
//  ChatTableViewCell.h
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Message;

@interface ChatCellViewModel : NSObject

@property (nonatomic, readonly) BOOL isDoctorMessage;
@property (nonatomic, readonly) BOOL isMyMessage;
@property (nonatomic, readonly) NSString *messageString;

+ (instancetype)viewModelFromMessage:(Message *)message;

@end

@interface ChatTableViewCell : UITableViewCell

+ (UINib *)rightMessageNib;
+ (NSString *)rightMessageIdentifierString;

+ (UINib *)leftMessageNib;
+ (NSString *)leftMessageIdentifierString;

+ (instancetype)sizingCellWithWidth:(CGFloat)width viewModel:(ChatCellViewModel *)viewModel;

- (void)configureWithViewModel:(ChatCellViewModel *)viewModel;

@end
