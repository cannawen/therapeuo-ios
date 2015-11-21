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

@end

@implementation DoctorProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.doctor.name;
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
