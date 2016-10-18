//
//  CountryCode.m
//  EnjoyLove
//
//  Created by HuangSam on 2016/10/18.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

#import "CountryCode.h"
#import "sqlite3.h"
#define DBFILE_NAME @"NotesList.sqlite3"

@implementation CountryCode
{
    sqlite3 *db;
}
+ (CountryCode *)shared{
    
}
@end

/*
 + (Database *)shared{
 static Database *sharedManager = nil;
 static dispatch_once_t once;
 dispatch_once(&once, ^{
 
 sharedManager = [[self alloc] init];
 [sharedManager createEditableCopyOfDatabaseIfNeeded];
 });
 return sharedManager;
 }
 
 - (void)createEditableCopyOfDatabaseIfNeeded {
 
 NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
 
 if (sqlite3_open([writableDBPath UTF8String], &db) != SQLITE_OK) {
 sqlite3_close(db);
 NSAssert(NO,@"数据库打开失败。");
 } else {
 NSString *sqlPath = [[NSBundle mainBundle] pathForResource:@"ga_area" ofType:@"sql"];
 char *err;
 NSString *createSQL = [[NSString alloc] initWithContentsOfFile:sqlPath encoding:NSUTF8StringEncoding error:nil];
 if (sqlite3_exec(db,[createSQL UTF8String],NULL,NULL,&err) != SQLITE_OK) {
 sqlite3_close(db);
 NSAssert1(NO, @"建表失败, %s", err);
 }
 sqlite3_close(db);
 }
 }
 
 - (NSString *)applicationDocumentsDirectoryFile {
 NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
 NSString *path = [documentDirectory stringByAppendingPathComponent:DBFILE_NAME];
 
 return path;
 }
 */
