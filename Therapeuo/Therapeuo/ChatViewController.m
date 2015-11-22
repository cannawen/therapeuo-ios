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
#import "ThemedTextField.h"
#import "TDataModule.h"
#import "Case.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendContainerBottomConstraint;
@property (weak, nonatomic) IBOutlet ThemedTextField *messageTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warningViewHeightConstraint;

@property (nonatomic) NSArray <ChatCellViewModel *> *viewModels;
@property (nonatomic) VerboseCase *verboseCase;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[ChatTableViewCell nib] forCellReuseIdentifier:NSStringFromClass([ChatTableViewCell class])];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.viewModels.count - 1
                                                               inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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

#pragma mark - IBAction

- (IBAction)sendButtonTapped:(id)sender {
    NSString *message = self.messageTextField.text;
    [[TDataModule sharedInstance] sendMessage:message
                                forCaseWithId:self.verboseCase.theCase.caseId
                                      success:^(id result) {
                                          self.warningViewHeightConstraint.constant = 0;
                                          self.messageTextField.text = message;
                                      }
                                      failure:^(NSError *error) {
                                          self.warningViewHeightConstraint.constant = 44;
                                      }];
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
