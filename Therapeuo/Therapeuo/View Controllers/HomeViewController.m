//
//  HomeViewController.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "HomeViewController.h"
#import "DoctorProfileViewController.h"

#import "Doctor.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *myProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *caseButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:@"doctorProfile"]) {
        DoctorProfileViewController *vc = (DoctorProfileViewController *)segue.destinationViewController;
        
        [vc configureWithDoctor:[self getDoctor]];
    }
}


// TODO: Find how we're getting the doctor ex) dependency inject factory, user context
-(Doctor *)getDoctor {
    Doctor *doctor = [Doctor doctorWithName:@"John Smith" location:@"1 Main Street" available:YES assisting:NO device:@"iPhone"];
    return doctor;
}

@end
