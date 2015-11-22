//
//  CaseListViewController.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "CaseListViewController.h"
#import "DoctorProfileViewController.h"
#import "TDataModule.h"

#import "Patient.h"
#import "Doctor.h"
#import "Case.h"
#import "VerboseCase.h"

#import "TAlertHelper.h"

#import "CaseListCell.h"
#import "CaseViewController.h"

#import "NSArray+PivotalCore.h"

@interface TempCaseClass : NSObject
@property (nonatomic, strong) id patient;
@property (nonatomic, strong) id doctor;
@property (nonatomic, strong) NSArray *doctors;
@property (nonatomic) BOOL open;
@property (nonatomic, strong) NSString *notes;
@end
@implementation TempCaseClass
@end


@interface CaseListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *cases;

@end

@implementation CaseListViewController

- (NSArray *)fakeCases {
    TempCaseClass *asdf1 = [[TempCaseClass alloc] init];
    asdf1.patient = @"Brian";
    asdf1.doctor = @"Canna";
    asdf1.doctors = @[@"Canna", @"Andrew"];
    asdf1.open = YES;
    asdf1.notes = @"Some sleep and rest should be all it takes";
    
    TempCaseClass *asdf2 = [[TempCaseClass alloc] init];
    asdf2.patient = @"Steven";
    asdf2.doctor = @"Rebecca";
    asdf2.doctors = @[@"Andrew", @"Rebecca"];
    asdf2.open = YES;
    asdf2.notes = @"Steven has experienced deteriorating symtoms of a rare condition called eating-too-much, an on-site visit may be required";
    
    TempCaseClass *asdf3 = [[TempCaseClass alloc] init];
    asdf3.patient = @"ASDFASDF";
    asdf3.doctor = @"adsf";
    asdf3.doctors = @[@"14p98", @"asdfbjl"];
    asdf3.open = NO;
    
    return @[asdf1, asdf2, asdf3];
}

#pragma mark - View Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cases = [TDataModule sharedInstance].cases;
    [self setupNavBar];
    [self setupCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Doctor *doctor = [TDataModule sharedInstance].doctor;
    __weak TDataModule *weakDataModule = [TDataModule sharedInstance];
    [[TDataModule sharedInstance] fetchCasesForDoctorWithId:doctor.doctorId success:^(NSArray *results) {
        self.cases = [TDataModule sharedInstance].cases;
        [self.collectionView reloadData];
    } failure:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:@"doctorProfile"]) {
        DoctorProfileViewController *vc = (DoctorProfileViewController *)segue.destinationViewController;
        
        [vc configureWithDoctor];
    } else if ([identifier isEqualToString:@"CaseViewControllerSegue"]) {
        CaseViewController *vc = [[CaseViewController alloc] init];
        
        // TODO get a case.
        [vc configureWithPatientCase:[self fakeCases][0]];
    }
}

#pragma mark - Setup

- (void)setupNavBar {
    UIImage *image = [UIImage imageNamed:@"profileIcon"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem.image = image;
    self.navigationItem.hidesBackButton = YES;
}

- (void)setupCollectionView {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([CaseListCell class]) bundle:[NSBundle bundleForClass:[self class]]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([CaseListCell class])];
}

#pragma mark - IBActions

- (IBAction)logoutButtonTapped:(id)sender {
    TDataModule *dataModule = [TDataModule sharedInstance];
    [dataModule logoutDoctorWithId:dataModule.doctor.doctorId
                           success:nil
                           failure:nil];
    [dataModule flushAllSuccess:^(id result) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cases.count;
}

#pragma mark - <UICollectionViewDelegate>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CaseListCell *cell = (CaseListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CaseListCell class]) forIndexPath:indexPath];
    Case *caseAtIndexPath = self.cases[indexPath.item];
    NSArray *doctorNames = [caseAtIndexPath.doctors map:^NSString *(Doctor *doctor) {
        return doctor.name;
    }];
    NSString *patientNameString = caseAtIndexPath.patient.patientId;
    NSString *doctorNamesString = [NSString stringWithFormat:@"Doctors: %@", [doctorNames componentsJoinedByString:@", "]];
    NSString *notes = caseAtIndexPath.notes;
    [cell setupWithPatientName:patientNameString
                   doctorNames:doctorNamesString
                         notes:notes];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Case *currentCase = self.cases[indexPath.item];
    [self spinnerShow];
    [[TDataModule sharedInstance] fetchVerboseCaseWithId:currentCase.caseId
                                   success:
     ^(VerboseCase *result) {
         [self spinnerHide];
         [self performSegueWithIdentifier:@"CaseViewControllerSegue" sender:nil];
     } failure:^(NSError *error) {
         [self spinnerHide];
         [TAlertHelper showDefaultError];
     }];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, 120.0f);
}

@end
