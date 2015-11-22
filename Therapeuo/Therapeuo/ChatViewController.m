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
#import "Message.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendContainerBottomConstraint;
@property (weak, nonatomic) IBOutlet ThemedTextField *messageTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warningViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@property (nonatomic) NSMutableArray <ChatCellViewModel *> *viewModels;
@property (nonatomic) VerboseCase *verboseCase;
@property (nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[ChatTableViewCell nib] forCellReuseIdentifier:NSStringFromClass([ChatTableViewCell class])];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handlePullToRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInlineRefresh) name:@"recievedPush" object:nil];
    self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 10, 0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollToBottom];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureWithVerboseCase:(VerboseCase *)verboseCase {
    self.verboseCase = verboseCase;
    self.viewModels = [self viewModelsWithVerboseCase:verboseCase];
    [self.tableView reloadData];
}

- (NSMutableArray *)viewModelsWithVerboseCase:(VerboseCase *)verboseCase {
    NSArray *sortedMessage = [verboseCase.messages sortedArrayUsingComparator:^NSComparisonResult(Message *message1, Message *message2) {
        if ([message1.timestamp integerValue] == [message2.timestamp integerValue]) {
            return NSOrderedSame;
        }
        if (message1.timestamp > message2.timestamp) {
            return NSOrderedDescending;
        }
        
        return NSOrderedAscending;
    }];
    
    NSString *myId = [TDataModule sharedInstance].doctor.doctorId;
    NSMutableArray *array = [NSMutableArray array];
    for (Message *message in sortedMessage) {
        id sender = [verboseCase senderForMessage:message];
        NSString *name;
        BOOL isMyMessage = NO;
        if ([sender isKindOfClass:[Doctor class]]) {
            if ([((Doctor *)sender).doctorId isEqualToString:myId]) {
                name = @"Me";
                isMyMessage = YES;
            } else {
                name = ((Doctor *)sender).name;
            }
        }
        ChatCellViewModel *viewModel = [ChatCellViewModel viewModelFromMessage:message
                                                                          name:name
                                                                   isMyMessage:isMyMessage];
        [array addObject:viewModel];
    }
    return array;
}

#pragma mark -

- (void)scrollToBottom {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.viewModels.count - 1
                                                               inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)handleInlineRefresh {
    NSUInteger oldMessageCount = self.viewModels.count;
    [[TDataModule sharedInstance] fetchVerboseCaseWithId:self.verboseCase.theCase.caseId success:^(VerboseCase *result) {
        [self configureWithVerboseCase:result];
        [self scrollToBottom];
        NSUInteger newMessageCount = self.viewModels.count;
        for (NSInteger newMessageIndex = oldMessageCount; newMessageIndex < newMessageCount; newMessageIndex++) {
            ChatCellViewModel *viewModel = self.viewModels[newMessageIndex];
            viewModel.shouldFlash = YES;
        }
        [self.tableView reloadData];
        [self scrollToBottom];
    } failure:^(NSError *error) {
        [self.tableView reloadData];
        [self scrollToBottom];
    }];
}

- (void)handlePullToRefresh {
    [self spinnerShow];
    [[TDataModule sharedInstance] fetchVerboseCaseWithId:self.verboseCase.theCase.caseId success:^(VerboseCase *result) {
        [self configureWithVerboseCase:result];
        [self spinnerHide];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self showErrorWithMessage:@"Unable to reload messages"];
        [self spinnerHide];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
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
    
    [[TDataModule sharedInstance] sendMessage:message
                                forCaseWithId:self.verboseCase.theCase.caseId
                                      success:^(id result) {
                                          self.messageTextField.text = nil;
                                          [self hideError];
                                          [self handleInlineRefresh];
                                      } failure:^(NSError *error) {
                                          [self showErrorWithMessage:@"Unable to send message"];
                                          [[self viewModels] removeLastObject];
                                          [self.tableView reloadData];
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
    if (viewModel.shouldFlash) {
        [cell flash];
        viewModel.shouldFlash = NO;
    }
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
