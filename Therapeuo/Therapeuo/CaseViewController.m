//
//  CaseViewController.m
//  Therapeuo
//
//  Created by Canna Wen on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "CaseViewController.h"
#import "Patient.h"
#import "Doctor.h"
#import "VerboseCase.h"
#import "Case.h"
#import "MutableCase.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Theme.h"
#import "TDataModule.h"
#import "ChatViewController.h"
#import "ThemedButton.h"

@interface CaseViewController ()

@property (nonatomic, strong) VerboseCase *patientCase;

@property (weak, nonatomic) IBOutlet UILabel *primaryMDLabel;
@property (weak, nonatomic) IBOutlet UILabel *associateMDLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UISwitch *caseCompletionSwitch;
@property (weak, nonatomic) IBOutlet UILabel *caseCompleteLabel;

@property (nonatomic, assign) BOOL caseEditing;
@property (weak, nonatomic) IBOutlet UILabel *primaryMDValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *associateMDValueLabel;
@property (weak, nonatomic) IBOutlet ThemedButton *openChatButton;

@end

typedef void (^ SaveBlock)(BOOL);

@implementation CaseViewController

+ (instancetype)viewControllerWithVerboseCase:(VerboseCase *)verboseCase {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CaseViewController *vc = (CaseViewController *)[sb instantiateViewControllerWithIdentifier:@"caseViewController"];
    vc.patientCase = verboseCase;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notesTextView.layer.borderColor = [UIColor themeBlueColor].CGColor;
    self.notesTextView.layer.borderWidth = 1.0f;
    
    self.primaryMDLabel.textColor = [UIColor themeBlueColor];
    self.associateMDLabel.textColor = [UIColor themeBlueColor];
    self.notesLabel.textColor = [UIColor themeBlueColor];
    self.caseCompletionSwitch.tintColor = [UIColor themeBlueColor];
    self.caseCompletionSwitch.onTintColor = [UIColor themeBlueColor];
    self.caseCompleteLabel.textColor = [UIColor themeBlueColor];
    
    self.title = self.patientCase.theCase.caseId;
    [self setupUI];
    
// bar buttons
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didSelectSaveButton)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)setCaseEditMode:(BOOL)editing {
    self.caseCompletionSwitch.enabled = editing;
    self.notesTextView.editable = editing;
    self.openChatButton.enabled = !editing;
}

- (void)setCaseEditing:(BOOL)isEditing {
    _caseEditing = !_caseEditing;
    
    if (_caseEditing) {
        // now editing
    } else {
        [self saveCase:^(BOOL didSave) {
            [self setCaseEditMode:NO];
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didSelectSaveButton)];

        }];
    }
}

- (void)didSelectSaveButton {
    
// do save
    if (!self.caseEditing) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didSelectSaveButton)];
        [self setCaseEditMode:YES];
    }
    self.caseEditing = !self.caseEditing;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    Case *theCase = self.patientCase.theCase;
    self.primaryMDValueLabel.text = theCase.primaryDoctor.name;
    
    NSMutableString *associateDoctorString = [NSMutableString new];
    for (Doctor *doctor in theCase.doctors) {
        [associateDoctorString appendString:[NSString stringWithFormat:@"%@,", doctor.name]];
    }
    
    if (associateDoctorString.length > 0) {
        self.associateMDValueLabel.text = [associateDoctorString substringToIndex:(associateDoctorString.length - 1)];
    }
    
    self.caseCompletionSwitch.on = theCase.open;
    self.notesTextView.text = theCase.notes;
}

- (void)saveCase:(SaveBlock)saveBlock {
    
    // Make new case:
    MutableCase *theCase = [self.patientCase.theCase copy];
    theCase.notes = self.notesTextView.text;
    theCase.open = self.caseCompletionSwitch.on;
    
    [[TDataModule sharedInstance] updateTheCase:theCase success:^(id result) {
//        remove spinner
        [self setCaseEditMode:NO];
        self.patientCase.theCase = theCase;
        saveBlock(YES);
    } failure:^(NSError *error) {
        [self setupUI];
    }];

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ChatViewControllerSegue"]) {
     
        ChatViewController *chatVC = (ChatViewController *)segue.destinationViewController;
        [chatVC configureWithVerboseCase:self.patientCase];
        
    }
}

@end
