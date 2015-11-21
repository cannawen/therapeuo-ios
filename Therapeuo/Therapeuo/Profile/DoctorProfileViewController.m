//
//  DoctorProfileViewController.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "DoctorProfileViewController.h"
#import "Doctor.h"
#import "TDataModule+Helpers.h"

@interface DoctorProfileViewController ()

@property (nonatomic, strong) Doctor *doctor;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UISwitch *availableSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *assistingSwitch;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, assign) BOOL isEditingProfile;
@end

typedef void (^ SaveBlock)(BOOL);

@implementation DoctorProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.doctor.name;
    _isEditingProfile = NO;
    
    // Default disabled - change if adding edit ability
    [self initializeUI];
    
    [self setProfileEditMode:NO];
    self.deviceLabel.text = self.doctor.device;
    
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didSelectEditButton)];
    self.navigationItem.rightBarButtonItem = self.editButton;
}

-(void)setProfileEditMode:(BOOL)shouldEdit {
    self.nameField.enabled = shouldEdit;
    self.locationField.enabled = shouldEdit;
    self.availableSwitch.enabled = shouldEdit;
    self.assistingSwitch.enabled = shouldEdit;
}

- (void)initializeUI {
    self.nameField.text = self.doctor.name;
    self.locationField.text = self.doctor.location;
    self.availableSwitch.on = self.doctor.available;
    self.assistingSwitch.on = self.doctor.assisting;
    self.deviceLabel.text = self.doctor.device;
}

-(void)configureWithDoctor {
    
    [[TDataModule sharedInstance] readDoctorSuccess:^(id result) {
        self.doctor = (Doctor *)result;
        [self initializeUI];
    } failure:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to get profile" message:@"Could not get profile" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Action button
-(void)didSelectEditButton {
    if (!_isEditingProfile) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didSelectEditButton)];
        [self setProfileEditMode:YES];
    }
    self.isEditingProfile = !self.isEditingProfile;
}

- (void)setIsEditingProfile:(BOOL)isEditing {
    _isEditingProfile = !_isEditingProfile;
    if (!_isEditingProfile) {
        
        [self saveProfile:^(BOOL didSave) {
            [self setProfileEditMode:NO];
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didSelectEditButton)];
        }];
    }
}

- (void)saveProfile:(SaveBlock)saveBlock {
    
    Doctor *doctor = [Doctor doctorWithID:self.doctor.doctorId name:self.nameField.text location:@"agaweg" available:self.availableSwitch.on assisting:self.assistingSwitch.on device:self.deviceLabel.text];
    
    
    [[TDataModule sharedInstance] updateDoctor:doctor success:^(id result) {
        // remove spinner
        [self setProfileEditMode:NO];
        saveBlock(YES);
    } failure:^(NSError *error) {
        [self initializeUI];
    }];
    // block-based save call
    
//     assume success

    // else error
    // initialize
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
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
