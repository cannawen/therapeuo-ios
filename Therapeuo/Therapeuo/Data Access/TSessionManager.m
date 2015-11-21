//
//  TSessionManager.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <Blindside.h>
#import "TConstants.h"
#import "TSessionManager.h"

@implementation TSessionManager

+ (BSInitializer *)bsInitializer {
    return [BSInitializer initializerWithClass:[self class]
                                      selector:@selector(initWithBaseURL:)
                                  argumentKeys:
            kBaseUrlKey,
            nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self.securityPolicy setAllowInvalidCertificates:YES];
        [self.securityPolicy setValidatesDomainName:NO];
    }
    return self;
}

@end
