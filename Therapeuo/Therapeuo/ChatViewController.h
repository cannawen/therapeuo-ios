//
//  ChatViewController.h
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBaseViewController.h"

@class Message;

@interface ChatViewController : TBaseViewController

- (void)configureWithMessages:(NSArray <Message *> *)messages;

@end
