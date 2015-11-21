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
    //TODO: Steven to make network call
    [[TDataModule sharedInstance] registerWithName:name
                                             email:email
                                          password:password
                                           success:^(Doctor *result) {

                                           } failure:^(NSError *error) {
                                               [TAlertHelper showDefaultError];
                                           }];
    
//    NSLog(@"%@", [TDataModule sharedInstance].doctor);
    
//    [[TDataModule sharedInstance] loginWithEmail:@"c"
//                                        password:@"c"
//                                         success:nil
//                                         failure:nil];
    
//    [[TDataModule sharedInstance] updateDoctor:[TDataModule sharedInstance].doctor
//                                       success:nil
//                                       failure:nil];
    
//    [[TDataModule sharedInstance] fetchDoctorWithId:[TDataModule sharedInstance].doctor.doctorId
//                                            success:nil
//                                            failure:nil];
}

@end
