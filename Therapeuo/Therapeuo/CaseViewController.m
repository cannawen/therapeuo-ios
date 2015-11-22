//
//  CaseViewController.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "CaseViewController.h"
#import "PatientCase.h"
#import "Case.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Theme.h"

@interface CaseViewController ()

@property (nonatomic, strong) PatientCase *patientCase;

@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *primaryMDLabel;
@property (weak, nonatomic) IBOutlet UILabel *associateMDLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

@end

@implementation CaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notesTextView.layer.borderColor = [UIColor themeBlueColor].CGColor;
    self.notesTextView.layer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
//    self.patientNameLabel.text = self.patientCase.patientCase.pa
//    self.primaryMDLabel.text = self.patientCase.patientCase.pri
}

- (void)configureWithPatientCase:(PatientCase *)patientCase {
    self.patientCase = patientCase;
//    [self setupUI];
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
