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
#import "TDataModule.h"
#import "TAlertHelper.h"
#import "TConstants.h"
#import "Doctor.h"

@interface LoginViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet ThemedTextField *emailTextField;
@property (weak, nonatomic) IBOutlet ThemedTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBottomConstraint;
@property (nonatomic) CGFloat originalLoginBottomConstraintConstant;
@property (weak, nonatomic) IBOutlet ThemedButton *registerButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoBlurredImageView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTapToDismissKeboard];
    [[TDataModule sharedInstance] readDoctorSuccess:^(id result) {
        if (result) {
            [self moveToHome];
        }
    } failure:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.originalLoginBottomConstraintConstant = self.loginBottomConstraint.constant;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)moveToHome {
    [self setupPush];
    [self updateDevice];
    [self performSegueWithIdentifier:@"caseController" sender:self];
}

- (void)setupPush {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications]; //iOS 8+
    } else {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)updateDevice {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:kDeviceTokenKey];
    if (token) {
        Doctor *updatedDoctor = [[TDataModule sharedInstance].doctor copyWithDevice:token];
        [[TDataModule sharedInstance] updateDoctor:updatedDoctor
                                           success:nil
                                           failure:nil];
    }
}

#pragma mark - IBActions

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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark - Keyboard

- (void)keyboardWillShowWithHeight:(CGFloat)height activeTextField:(UITextField *)activeTextField {
    if (self.loginBottomConstraint.constant == self.originalLoginBottomConstraintConstant) {
        [UIView animateWithDuration:animationDuration animations:^{
            CGFloat registerButtonHeight = CGRectGetHeight(self.registerButton.bounds);
            self.loginBottomConstraint.constant = height - registerButtonHeight;
            self.logoImageView.alpha = 0.0f;
            self.logoBlurredImageView.alpha = 1.0f;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHideWithHeight:(CGFloat)height {
    if (self.loginBottomConstraint.constant != self.originalLoginBottomConstraintConstant) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.loginBottomConstraint.constant = self.originalLoginBottomConstraintConstant;
            self.logoImageView.alpha = 1.0f;
            self.logoBlurredImageView.alpha = 0.0f;
            [self.view layoutIfNeeded];
        }];
    }
}

@end
