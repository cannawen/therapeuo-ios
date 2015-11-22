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
#import "TDataModule.h"
#import "Doctor.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendContainerBottomConstraint;
@property (nonatomic) NSArray <ChatCellViewModel *> *viewModels;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[ChatTableViewCell nib] forCellReuseIdentifier:NSStringFromClass([ChatTableViewCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
}

- (void)configureWithVerboseCase:(VerboseCase *)verboseCase {
    NSString *myId = [TDataModule sharedInstance].doctor.doctorId;
    NSMutableArray *array = [NSMutableArray array];
    for (Message *message in verboseCase.messages) {
        id sender = [verboseCase senderForMessage:message];
        BOOL isMyMessage;
        if ([sender isKindOfClass:[Doctor class]] && ((Doctor *)sender).doctorId == myId) {
            isMyMessage = YES;
        } else {
            isMyMessage = NO;
        }
        ChatCellViewModel *viewModel = [ChatCellViewModel viewModelFromMessage:message isMyMessage:isMyMessage];
        [array addObject:viewModel];
    }
    self.viewModels = array;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCellViewModel *viewModel = self.viewModels[indexPath.row];
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChatTableViewCell class])];
    [cell configureWithViewModel:viewModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCellViewModel *viewModel = self.viewModels[indexPath.row];
    return [ChatTableViewCell heightForCellWithWidth:CGRectGetWidth(tableView.bounds) viewModel:viewModel];
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
