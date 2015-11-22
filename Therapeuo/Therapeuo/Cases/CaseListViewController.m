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

@interface CaseListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *openCases;
@property (nonatomic, strong) NSArray *proxyCases;
@property (nonatomic, strong) NSArray *closedCases;

@end

@implementation CaseListViewController

#pragma mark - View Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateSectionsWithCases:[TDataModule sharedInstance].cases];
    [self setupNavBar];
    [self setupCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateCases];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:@"doctorProfile"]) {
        DoctorProfileViewController *vc = (DoctorProfileViewController *)segue.destinationViewController;
        
        [vc configureWithDoctor];
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

#pragma mark - Cases

- (void)updateCases {
    NSString *doctorId = [TDataModule sharedInstance].doctor.doctorId;
    [[TDataModule sharedInstance] fetchCasesForDoctorWithId:doctorId success:^(NSArray *results) {;
        [self updateSectionsWithCases:results];
        
//        Case *testCase = [results firstObject];
//        [[TDataModule sharedInstance] sendMessage:@"asdfasdf"
//                                    forCaseWithId:testCase.caseId
//                                          success:nil
//                                          failure:nil];
        
        [self.collectionView reloadData];
    } failure:nil];
}

- (void)updateSectionsWithCases:(NSArray *)cases {
    NSString *doctorId = [TDataModule sharedInstance].doctor.doctorId;
    self.openCases = [cases filter:^BOOL(Case *aCase) {
        return aCase.open && [aCase.primaryDoctorId isEqualToString:doctorId];
    }];
//    self.proxyCases = [cases filter:^BOOL(Case *aCase) {
//        return aCase.open && ![aCase.primaryDoctorId isEqualToString:doctorId];
//    }];
//    self.closedCases = [cases filter:^BOOL(Case *aCase) {
//        return !aCase.open;
//    }];
    self.proxyCases = self.openCases;
    self.closedCases = self.openCases;
}

#pragma mark - IBActions

- (IBAction)logoutButtonTapped:(id)sender {
    [self spinnerShow];
    [[TDataModule sharedInstance] logoutSuccess:^(id _) {
        [self spinnerHide];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self spinnerHide];
        [TAlertHelper showDefaultError];
    }];
}

#pragma mark - <UICollectionViewDataSource>

- (NSArray *)casesForSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.openCases;
        case 1:
            return self.proxyCases;
        case 2:
            return self.closedCases;
        default:
            return nil;
    }
}

- (Case *)caseForIndexPath:(NSIndexPath *)indexPath {
    NSArray *cases = [self casesForSection:indexPath.section];
    return cases[indexPath.item];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self casesForSection:section].count;
}

#pragma mark - <UICollectionViewDelegate>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CaseListCell *cell = (CaseListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CaseListCell class]) forIndexPath:indexPath];
    Case *caseAtIndexPath = [self caseForIndexPath:indexPath];
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
    Case *currentCase = [self caseForIndexPath:indexPath];
    [self spinnerShow];
    [[TDataModule sharedInstance] fetchVerboseCaseWithId:currentCase.caseId
                                                 success:
     ^(VerboseCase *result) {
         [self spinnerHide];
         
         UIViewController *vc = [CaseViewController viewControllerWithVerboseCase:result];
         [self.navigationController pushViewController:vc animated:YES];

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
