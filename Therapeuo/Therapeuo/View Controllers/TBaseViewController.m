//
//  TBaseViewController.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import "TBaseViewController.h"

@interface TBaseViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation TBaseViewController

- (UIActivityIndicatorView *)spinner {
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc]
                    initWithFrame:CGRectMake(self.view.bounds.size.width/2.0f,
                                             self.view.bounds.size.height/2.0f,
                                             20.0f,
                                             20.0f)];
        [self.view addSubview:_spinner];
        _spinner.center = self.view.center;
        _spinner.hidesWhenStopped = YES;
        _spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return _spinner;
}

- (void)spinnerShow {
    [self.spinner startAnimating];
}

- (void)spinnerHide {
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    self.spinner = nil;
}

@end
