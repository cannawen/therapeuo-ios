//
//  TModule.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <Blindside.h>
#import "TModule.h"

#import "TConstants.h"

// Networking
#import "TSessionManager.h"
#import "TNetworkManager.h"
#import "TPersistenceManager.h"
#import "TDataModule.h"


@implementation TModule

- (void)configure:(id)binder {
    //Networking
    [binder bind:kBaseUrlKey toInstance:[NSURL URLWithString:@"https://therapeuo.herokuapp.com"]];
    [binder bind:[TSessionManager class] withScope:[BSSingleton scope]];
    [binder bind:[TNetworkManager class] withScope:[BSSingleton scope]];
    [binder bind:[TPersistenceManager class] withScope:[BSSingleton scope]];
    [binder bind:[TDataModule class] withScope:[BSSingleton scope]];
}

@end
