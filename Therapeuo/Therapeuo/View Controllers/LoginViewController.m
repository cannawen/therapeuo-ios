//
//  LoginViewController.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "LoginViewController.h"
#import "ThemedTextField.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet ThemedTextField *emailTextField;
@property (weak, nonatomic) IBOutlet ThemedTextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)loginButtonTapped:(id)sender {
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    //TODO network call
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}


@end
