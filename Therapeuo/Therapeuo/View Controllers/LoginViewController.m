//
//  LoginViewController.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "LoginViewController.h"
#import "ThemedTextField.h"
#import "ThemedButton.h"
#import "TDataModule+Helpers.h"
#import "TAlertHelper.h"
#import "TConstants.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet ThemedTextField *emailTextField;
@property (weak, nonatomic) IBOutlet ThemedTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBottomConstraint;
@property (nonatomic) CGFloat originalLoginBottomConstraintConstant;
@property (weak, nonatomic) IBOutlet ThemedButton *registerButton;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[TDataModule sharedInstance] readDoctorSuccess:^(id result) {
        if (result) {
            [self moveToHome];
        }
    } failure:nil];
    self.originalLoginBottomConstraintConstant = self.loginBottomConstraint.constant;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)loginButtonTapped:(id)sender {
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    [self spinnerShow];
    [[TDataModule sharedInstance] loginWithEmail:email
                                        password:password
                                         success:
     ^(id result) {
         [self spinnerHide];
         [self moveToHome];
     } failure:^(NSError *error) {
         [self spinnerHide];
         [TAlertHelper showDefaultError];
     }];
}

- (void)moveToHome {
    [self performSegueWithIdentifier:@"caseController" sender:self];
}

- (void)keyboardWillShowWithHeight:(CGFloat)height activeTextField:(UITextField *)activeTextField {
    if (self.loginBottomConstraint.constant == self.originalLoginBottomConstraintConstant) {
        [UIView animateWithDuration:animationDuration animations:^{
            CGFloat registerButtonHeight = CGRectGetHeight(self.registerButton.bounds);
            self.loginBottomConstraint.constant = height - registerButtonHeight;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHideWithHeight:(CGFloat)height {
    self.loginBottomConstraint.constant = self.originalLoginBottomConstraintConstant;
}

@end
