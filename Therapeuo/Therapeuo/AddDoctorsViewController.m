//
//  AddDoctorsViewController.m
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-22.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "AddDoctorsViewController.h"
#import "DoctorTableViewCell.h"
#import "TDataModule.h"

@interface AddDoctorsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;

@property (nonatomic, strong) NSArray *allDoctors;
@property (nonatomic, strong) NSMutableArray *addedDoctors;

@end

@implementation AddDoctorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Doctors";
     UINib *nib = [UINib nibWithNibName:NSStringFromClass([DoctorTableViewCell class]) bundle:[NSBundle bundleForClass:[self class]]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"DoctorCell"];
    
    [self.loadingView startAnimating];
    [[TDataModule sharedInstance] fetchAllDoctorsSuccess:^(id result) {
        self.allDoctors = (NSArray*)result;
        [self setupUI];
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get doctors" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [self.loadingView stopAnimating];
    }];
    // Do any additional setup after loading the view.
}

- (void)setupUI {
    [self.tableView reloadData];
}

- (IBAction)actionCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didAddDoctor:self.allDoctors[indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allDoctors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Doctor *doctor = self.allDoctors[indexPath.row];
    DoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorCell"];
    [cell configureWithDoctor:doctor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:NULL];
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
