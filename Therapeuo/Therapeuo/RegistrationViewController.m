//
//  RegistrationViewController.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "RegistrationViewController.h"
#import "TNetworkManager.h"

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
    //TODO: Steven to make network call
    [[TNetworkManager sharedInstance] registerWithEmail:email
                                                   name:name
                                               password:password
                                                success:^(id result) {
                                                    // currently no parsing models
                                                } failure:^(NSError *error) {
                                                    
                                                }];
}

@end
