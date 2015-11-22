//
//  TBaseViewController.h
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Helpers.h"

@interface TBaseViewController : UIViewController <UITextFieldDelegate> // Must call super if child VC also implementing UITextFieldDelegate for keyboard scrolling to work

#pragma mark - Spinner
- (void)spinnerShow;
- (void)spinnerHide;

#pragma mark - Keyboard Methods
- (void)setupKeyboardHandlingForScrollView:(UIScrollView *)scrollView; //You must set textFields to be delegate of VC in order to use this
- (void)keyboardWillShowWithHeight:(CGFloat)height activeTextField:(UITextField *)activeTextField;
- (void)keyboardWillHideWithHeight:(CGFloat)height;

@end
