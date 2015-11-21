//
//  TPersistenceManager.m
//  Therapeuo
//
//  Created by Dev Floater 111 on 2015-11-21.
//  Copyright © 2015 Dumpling. All rights reserved.
//

#import <Blindside.h>
#import <YapDatabase.h>
#import "TPersistenceManager.h"

@interface TPersistenceManager ()

@property (nonatomic, strong) YapDatabase *database;
@property (nonatomic, strong) YapDatabaseConnection *mainConnection;

@end

@implementation TPersistenceManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _database = [[YapDatabase alloc] initWithPath:[self databasePath]];
        _mainConnection = [_database newConnection];
    }
    return self;
}

- (NSString *)databasePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [self checkPath:path];
    return [path stringByAppendingPathComponent:@"therapeuo.sqlite"];
}

- (NSError *)checkPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDirectory] || !isDirectory) {
        NSError *error = nil;
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                               forKey:NSFileProtectionKey];
        [fileManager createDirectoryAtPath:path
               withIntermediateDirectories:YES
                                attributes:attributes
                                     error:&error];
        return error;
    }
    return nil;
}


@end
