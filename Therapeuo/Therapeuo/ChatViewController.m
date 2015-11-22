//
//  ChatViewController.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "ChatViewController.h"
#import "TConstants.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendContainerBottomConstraint;

@end

@implementation ChatViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Keyboard

- (void)keyboardWillShowWithHeight:(CGFloat)height activeTextField:(UITextField *)activeTextField {
    if (self.sendContainerBottomConstraint.constant == 0) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.sendContainerBottomConstraint.constant = height;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHideWithHeight:(CGFloat)height {
    if (self.sendContainerBottomConstraint.constant > 0) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.sendContainerBottomConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
}

@end
