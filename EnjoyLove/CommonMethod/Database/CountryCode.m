//
//  CountryCode.m
//  EnjoyLove
//
//  Created by HuangSam on 2016/10/18.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

#import "CountryCode.h"
#import "FMDB.h"
#define DBFILE_NAME @"NotesList.sqlite3"
#define TABLE_NAME @"ZZXCity"


@interface CountryCode ()

@property (nonatomic, strong) FMDatabase *fmdb;

@end

@implementation CountryCode

+ (CountryCode *)shared{
    static CountryCode *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [manager createEditableCopyOfDatabaseIfNeeded];
    });
    return manager;
}

- (void)createEditableCopyOfDatabaseIfNeeded {
    
     NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"ZZXCity" ofType:@"db"];
    self.fmdb = [FMDatabase databaseWithPath:dbPath];
    if ([self.fmdb open]) {
        NSLog(@"打开成功");
    }
    [self.fmdb close];
}

- (NSString *)applicationDocumentsDirectoryFile {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:DBFILE_NAME];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}
/*
 "_id" = 0;
 "area_code" = 1;
 "area_name" = 2;
 "area_tel_code" = 5;
 center = 6;
 level = 4;
 "parent_code" = 3;
 */
- (void)findAll{
    if ([self.fmdb open]) {
        FMResultSet *result = [self.fmdb executeQuery:[NSString stringWithFormat:@"select * from ZZXCity;"]];
        while ([result next]) {
            NSLog(@"column 0 data %@",[result stringForColumnIndex:0]);
            NSLog(@"column 1 data %@",[result stringForColumnIndex:1]);
            NSLog(@"column 2 data %@",[result stringForColumnIndex:2]);
            NSLog(@"column 3 data %@",[result stringForColumnIndex:3]);
            NSLog(@"column 4 data %@",[result stringForColumnIndex:4]);
            NSLog(@"column 5 data %@",[result stringForColumnIndex:5]);
            NSLog(@"column 6 data %@",[result stringForColumnIndex:6]);
        }
    }
    [self.fmdb close];
}

@end


