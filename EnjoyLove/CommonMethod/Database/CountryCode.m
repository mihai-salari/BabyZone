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
#define TABLE_NAME @"global_area"

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
    
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    self.fmdb = [FMDatabase databaseWithPath:writableDBPath];
    if ([self.fmdb open]) {
        BOOL isExists = [self.fmdb tableExists:TABLE_NAME];
        if (!isExists) {
            NSString *sqlPath = [[NSBundle mainBundle] pathForResource:@"ga_area" ofType:@"sql"];
            NSString *createSQL = [[NSString alloc] initWithContentsOfFile:sqlPath encoding:NSUTF8StringEncoding error:nil];
            if ([self.fmdb executeUpdate:createSQL]) {
                NSLog(@"=========================建表成功=====================");
            }
            [self.fmdb close];
        }
    }else{
        [self.fmdb close];
    }
}

- (NSString *)applicationDocumentsDirectoryFile {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:DBFILE_NAME];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

- (void)findAll{
    if ([self.fmdb open]) {
        FMResultSet *result = [self.fmdb executeQuery:[NSString stringWithFormat:@"select * from global_area;"]];
        NSLog(@"obj =====%@",result);
    }
    [self.fmdb close];
}

@end


