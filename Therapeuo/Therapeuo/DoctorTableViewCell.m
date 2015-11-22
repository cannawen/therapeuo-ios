//
//  DoctorTableViewCell.m
//  Therapeuo
//
//  Created by Brian Shim on 2015-11-22.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "DoctorTableViewCell.h"
#import "Doctor.h"

@interface DoctorTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (nonatomic, strong) Doctor *doctor;

@end

@implementation DoctorTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureWithDoctor:(Doctor *)doctor {
    self.doctor = doctor;
    self.nameLabel.text = doctor.name;
    self.emailLabel.text = doctor.email;
}

@end
