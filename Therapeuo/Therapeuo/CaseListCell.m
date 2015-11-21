//
//  CaseListCell.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "CaseListCell.h"

@interface CaseListCell ()
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorNamesLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@end

@implementation CaseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4.0f;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
}

- (void)setupWithPatientName:(NSString *)patientName
                 doctorNames:(NSString *)doctorNames
                       notes:(NSString *)notes {
    self.patientNameLabel.text = patientName;
    self.doctorNamesLabel.text = doctorNames;
    self.notesLabel.text = notes;
}

@end
