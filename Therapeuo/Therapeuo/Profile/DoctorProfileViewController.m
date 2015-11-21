//
//  DoctorProfileViewController.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "DoctorProfileViewController.h"
#import "Doctor.h"

@interface DoctorProfileViewController ()

@property (nonatomic, strong) Doctor *doctor;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UISwitch *availableSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *assistingSwitch;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@end

@implementation DoctorProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Default disabled - change if adding edit ability
    self.title = self.doctor.name;
    self.nameField.enabled = NO;
    self.locationField.enabled = NO;
    self.availableSwitch.enabled = NO;
    self.assistingSwitch.enabled = NO;
    
    self.nameField.text = self.doctor.name;
    self.locationField.text = self.doctor.location;
    self.availableSwitch.on = self.doctor.available;
    self.assistingSwitch.on = self.doctor.assisting;
    self.deviceLabel.text = self.doctor.device;
}

-(void)configureWithDoctor:(Doctor *)doctor {
    self.doctor = doctor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
