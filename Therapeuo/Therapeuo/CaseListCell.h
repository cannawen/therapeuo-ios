//
//  CaseListCell.h
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseListCell : UICollectionViewCell

- (void)setupWithPatientName:(NSString *)patientName
                 doctorNames:(NSString *)doctorNames
                       notes:(NSString *)notes;

@end
