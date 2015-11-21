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


@implementation TModule

- (void)configure:(id)binder {
    //Networking
    [binder bind:kBaseUrlKey toInstance:[NSURL URLWithString:@"google.ca"]];
    [binder bind:[TSessionManager class] withScope:[BSSingleton scope]];
    [binder bind:[TNetworkManager class] withScope:[BSSingleton scope]];
}

@end
