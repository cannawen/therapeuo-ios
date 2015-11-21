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

#import "Doctor.h"

NSString * const kDoctorsCollection = @"Doctors";
NSString * const kCurrentdDoctorKey = @"CurrentdDoctor";

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

- (void)readDoctorSuccess:(SuccssBlock)success
                  failure:(FailureBlock)failure {
    __block Doctor *doctor;
    [self.mainConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        doctor = [transaction objectForKey:kCurrentdDoctorKey inCollection:kDoctorsCollection];
    } completionBlock:^{
        if (success) {
            success(doctor);
        }
    }];
}

- (void)writeDoctor:(Doctor *)doctor
            success:(SuccssBlock)success
            failure:(FailureBlock)failure {
    [self.mainConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:doctor forKey:kCurrentdDoctorKey inCollection:kDoctorsCollection];
    } completionBlock:^{
        if (success) {
            success(doctor);
        }
    }];
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
