//
//  ChatViewController.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "ChatViewController.h"
#import "TConstants.h"
#import "ChatTableViewCell.h"
#import "VerboseCase.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendContainerBottomConstraint;
@property (nonatomic) VerboseCase *verboseCase;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[ChatTableViewCell leftMessageNib] forCellReuseIdentifier:[ChatTableViewCell leftMessageIdentifierString]];
    [self.tableView registerNib:[ChatTableViewCell rightMessageNib] forCellReuseIdentifier:[ChatTableViewCell rightMessageIdentifierString]];
}

- (void)configureWithVerboseCase:(VerboseCase *)verboseCase {
    self.verboseCase = verboseCase;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.verboseCase.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCellViewModel *viewModel = [ChatCellViewModel viewModelFromMessage:self.verboseCase.messages[indexPath.row]];
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:viewModel.identifier];
    return cell;
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
