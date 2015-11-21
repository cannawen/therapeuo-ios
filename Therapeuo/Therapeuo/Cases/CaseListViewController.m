//
//  CaseListViewController.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "CaseListViewController.h"

@interface TempCaseClass : NSObject
@property (nonatomic, strong) id patient;
@property (nonatomic, strong) id doctor;
@property (nonatomic, strong) NSArray *doctors;
@property (nonatomic) BOOL open;
@property (nonatomic, strong) NSString *notes;
@end


@interface CaseListViewController ()

@end

@implementation CaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
