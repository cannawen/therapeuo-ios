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
#import "ThemeTools.h"

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
@property (weak, nonatomic) IBOutlet UIButton *addDoctorButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (weak, nonatomic) IBOutlet UILabel *locationValueLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

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
    
    [ThemeTools applyBlueThemeBorderToView:self.notesTextView];
    
    self.primaryMDLabel.textColor = [UIColor themeBlueColor];
    self.associateMDLabel.textColor = [UIColor themeBlueColor];
    self.notesLabel.textColor = [UIColor themeBlueColor];
    self.caseCompletionSwitch.tintColor = [UIColor themeBlueColor];
    self.caseCompletionSwitch.onTintColor = [UIColor themeBlueColor];
    self.caseCompleteLabel.textColor = [UIColor themeBlueColor];
    self.locationLabel.textColor = [UIColor themeBlueColor];
    
    self.title = self.patientCase.theCase.patient.patientId;
    [self setupUI];
    
// bar buttons
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didSelectSaveButton)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)setCaseEditMode:(BOOL)editing {
    self.caseCompletionSwitch.enabled = editing;
    self.notesTextView.editable = editing;
    self.openChatButton.enabled = !editing;
    self.addDoctorButton.enabled = !editing;
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
        [associateDoctorString appendString:[NSString stringWithFormat:@"%@, ", doctor.name]];
    }
    
    if (associateDoctorString.length > 0) {
        self.associateMDValueLabel.text = [associateDoctorString substringToIndex:(associateDoctorString.length - 2)];
    }
    
    self.locationValueLabel.text = theCase.patient.locationDescription;
    
    self.caseCompletionSwitch.on = theCase.open;
    self.notesTextView.text = theCase.notes;
    [self updateMap];
    
}

- (void)updateMap {
    // create a region and pass it to the Map View
    self.mapView.delegate = self;
    Patient *patient = self.patientCase.theCase.patient;
    MKCoordinateRegion region;
    
    double longitude = [patient.location[1] doubleValue];
    double latitude = [patient.location[0] doubleValue];
    
    region.center.latitude = latitude;
    region.center.longitude = longitude;
    region.span.latitudeDelta = 5;
    region.span.longitudeDelta = 5;

    [self.mapView setRegion:region animated:YES];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    [annotation setTitle:@"Patient is here!"];
    [self.mapView addAnnotation:annotation];
    
}

#pragma mark - end
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
        
    } else if ([segue.identifier isEqualToString:@"AddDoctorsSegue"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
    
        AddDoctorsViewController *addDocVC = (AddDoctorsViewController *)nav.topViewController;
        addDocVC.delegate = self;
    }
}

#pragma AddDoctorsViewControllerDelegate
-(void)didAddDoctor:(Doctor *)doctor {
    [self.loadingSpinner startAnimating];
    [[TDataModule sharedInstance] addDoctorId:doctor.doctorId toCaseId:self.patientCase.theCase.caseId success:^(id result) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } failure:^(NSError *error) {
        [self.loadingSpinner stopAnimating];
    }];
}


@end
