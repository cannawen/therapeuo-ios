//
//  CaseListViewController.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "CaseListViewController.h"
#import "DoctorProfileViewController.h"

#import "TDataModule+Helpers.h"

#import "Doctor.h"

#import "CaseListCell.h"

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


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"profileIcon"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem.image = image;

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([CaseListCell class]) bundle:[NSBundle bundleForClass:[self class]]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([CaseListCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Doctor *doctor = [TDataModule sharedInstance].doctor;
    [[TDataModule sharedInstance] fetchCaseForDoctorWithId:doctor.doctorId success:^(id result) {
        
    } failure:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.cases = [self fakeCases];
    [self.collectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:@"doctorProfile"]) {
        DoctorProfileViewController *vc = (DoctorProfileViewController *)segue.destinationViewController;
        
        [vc configureWithDoctor];
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - <UICollectionViewDelegate>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CaseListCell *cell = (CaseListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CaseListCell class]) forIndexPath:indexPath];
    TempCaseClass *caseAtIndexPath = self.cases[indexPath.item];
    NSString *patientName = caseAtIndexPath.patient;
    NSString *doctorNames = [NSString stringWithFormat:@"Doctors: %@", [caseAtIndexPath.doctors componentsJoinedByString:@", "]];
    NSString *notes = caseAtIndexPath.notes;
    [cell setupWithPatientName:patientName
                   doctorNames:doctorNames
                         notes:notes];
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, 120.0f);
}

@end
