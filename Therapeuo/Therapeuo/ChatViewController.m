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
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@property (nonatomic) NSArray <ChatCellViewModel *> *viewModels;
@property (nonatomic) VerboseCase *verboseCase;
@property (nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[ChatTableViewCell nib] forCellReuseIdentifier:NSStringFromClass([ChatTableViewCell class])];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollToBottom];
}

- (void)configureWithVerboseCase:(VerboseCase *)verboseCase {
    self.verboseCase = verboseCase;
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
    [self.tableView reloadData];
}

#pragma mark -

- (void)scrollToBottom {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.viewModels.count - 1
                                                               inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)handleRefresh:(id)sender {
    [self handleRefreshShowingFeedback:YES];
}

- (void)handleRefreshShowingFeedback:(BOOL)showingFeedback {
    if (showingFeedback) {
        [self spinnerShow];
    }
    [[TDataModule sharedInstance] fetchVerboseCaseWithId:self.verboseCase.theCase.caseId success:^(VerboseCase *result) {
        [self configureWithVerboseCase:result];
        if (showingFeedback) {
            [self spinnerHide];
            [self.refreshControl endRefreshing];
        }
    } failure:^(NSError *error) {
        if (showingFeedback) {
            [self showErrorWithMessage:@"Unable to reload messages"];
            [self spinnerHide];
            [self.refreshControl endRefreshing];
        }
    }];
}

- (void)showErrorWithMessage:(NSString *)warning {
    self.warningViewHeightConstraint.constant = 44;
    self.warningLabel.text = warning;
}

- (void)hideError {
    self.warningViewHeightConstraint.constant = 0;
}

#pragma mark - IBAction

- (IBAction)sendButtonTapped:(id)sender {
    NSString *message = self.messageTextField.text;
    ChatCellViewModel *viewModel = [ChatCellViewModel viewModelFromMyMessage:message];
    self.viewModels = [self.viewModels arrayByAddingObject:viewModel];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.viewModels.count-1 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.viewModels.count-1 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [[TDataModule sharedInstance] sendMessage:message
                                forCaseWithId:self.verboseCase.theCase.caseId
                                      success:^(id result) {
                                          self.messageTextField.text = nil;
                                          [self hideError];
                                          [self handleRefreshShowingFeedback:NO];
                                      } failure:^(NSError *error) {
                                          [self showErrorWithMessage:@"Unable to send message"];
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
