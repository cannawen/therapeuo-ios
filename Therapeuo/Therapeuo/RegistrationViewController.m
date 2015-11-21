//
//  RegistrationViewController.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "RegistrationViewController.h"
#import "TDataModule.h"

#import "Doctor.h"

#import "TAlertHelper.h"

@interface RegistrationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *logoBlurredImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *formBottomConstraint;
@property (nonatomic) CGFloat originalFormBottomConstraintOriginalConstant;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.originalFormBottomConstraintOriginalConstant = self.formBottomConstraint.constant;
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)registerButtonTapped:(id)sender {
    [self spinnerShow];
    [[TDataModule sharedInstance] registerWithName:self.nameTextField.text
                                             email:self.emailTextField.text
                                          password:self.passwordTextField.text
                                           success:^(Doctor *result) {
                                               [self spinnerHide];
                                               UIViewController *loginViewController = [self.navigationController.childViewControllers firstObject];
                                               [loginViewController performSegueWithIdentifier:@"caseController" sender:self];
                                           } failure:^(NSError *error) {
                                               [self spinnerHide];
                                               [TAlertHelper showDefaultError];
                                           }];
}

#pragma mark - Keyboard

- (void)keyboardWillShowWithHeight:(CGFloat)height activeTextField:(UITextField *)activeTextField {
    if (self.formBottomConstraint.constant == self.originalFormBottomConstraintOriginalConstant) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.formBottomConstraint.constant = height + self.originalFormBottomConstraintOriginalConstant;
            self.logoImageView.alpha = 0.0f;
            self.logoBlurredImageView.alpha = 1.0f;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHideWithHeight:(CGFloat)height {
    if (self.formBottomConstraint.constant != self.originalFormBottomConstraintOriginalConstant) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.formBottomConstraint.constant = self.originalFormBottomConstraintOriginalConstant;
            self.logoImageView.alpha = 1.0f;
            self.logoBlurredImageView.alpha = 0.0f;
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.view endEditing:YES];
    }
    return YES;
}

@end
