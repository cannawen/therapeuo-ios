//
//  TBaseViewController.h
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBaseViewController : UIViewController <UITextFieldDelegate>

- (void)spinnerShow;
- (void)spinnerHide;

@property (nonatomic) IBOutlet UIScrollView *scrollView;

@end
