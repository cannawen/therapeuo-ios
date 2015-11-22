//
//  ChatTableViewCell.h
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCellViewModel : NSObject

@property (nonatomic, readonly) BOOL isMySentMessage;
@property (nonatomic, readonly) NSString *message;

+ (instancetype)viewModelWithMessage:(NSString *)message
                     isMySentMessage:(BOOL)isMySentMessage;

@end

@interface ChatTableViewCell : UITableViewCell

+ (UINib *)partnerMessageNib;
+ (NSString *)partnerMessageIdentifierString;

+ (UINib *)myMessageNib;
+ (NSString *)myMessageIdentifierString;

+ (instancetype)sizingCellWithWidth:(CGFloat)width viewModel:(ChatCellViewModel *)viewModel;

- (void)configureWithViewModel:(ChatCellViewModel *)viewModel;

@end
