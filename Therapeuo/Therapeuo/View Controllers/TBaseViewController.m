//
//  TBaseViewController.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "TBaseViewController.h"

@interface TBaseViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic) UITextField *activeField;

@end

@implementation TBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerKeyboardNotifications];
}

#pragma mark - Spinner

- (UIActivityIndicatorView *)spinner {
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc]
                    initWithFrame:CGRectMake(self.view.bounds.size.width/2.0f,
                                             self.view.bounds.size.height/2.0f,
                                             20.0f,
                                             20.0f)];
        [self.view addSubview:_spinner];
        _spinner.center = self.view.center;
        _spinner.hidesWhenStopped = YES;
        _spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return _spinner;
}

- (void)spinnerShow {
    [self.spinner startAnimating];
}

- (void)spinnerHide {
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    self.spinner = nil;
}

#pragma mark - Keyboard Methods

- (void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [self keyboardWillShowWithHeight:[self keyboardHeightFromNotification:notification]
                    activeTextField:self.activeField];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self keyboardWillHideWithHeight:[self keyboardHeightFromNotification:notification]];
}

- (CGFloat)keyboardHeightFromNotification:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    return keyboardSize.height;
}

#pragma mark - Methods to override for custom behaviour

- (void)keyboardWillShowWithHeight:(CGFloat)height activeTextField:(UITextField *)activeTextField {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= height;
    
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillHideWithHeight:(CGFloat)height {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
}

@end
