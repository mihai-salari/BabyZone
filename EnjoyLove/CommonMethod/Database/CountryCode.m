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
