//
//  RegistrationViewController.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "RegistrationViewController.h"
#import "TDataModule+Helpers.h"

#import "Doctor.h"

#import "TAlertHelper.h"

@interface RegistrationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation RegistrationViewController

- (IBAction)registerButtonTapped:(id)sender {
    NSString *name = self.nameTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    [self spinnerShow];
    [[TDataModule sharedInstance] registerWithName:name
                                             email:email
                                          password:password
                                           success:^(Doctor *result) {
                                               [self spinnerHide];
                                               UIViewController *loginViewController = [self.navigationController.childViewControllers firstObject];
                                               [loginViewController performSegueWithIdentifier:@"caseController" sender:self];
                                           } failure:^(NSError *error) {
                                               [self spinnerHide];
                                               [TAlertHelper showDefaultError];
                                           }];
}

@end
