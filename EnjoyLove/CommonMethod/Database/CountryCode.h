//
//  CountryCode.h
//  EnjoyLove
//
//  Created by HuangSam on 2016/10/18.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CityCode;
@interface CountryCode : NSObject

+ (CountryCode *)shared;

- (NSArray *)findViaName:(NSString *)name;

- (CityCode *)findViaDetermineName:(NSString *)name;

- (NSArray *)findViaLevel:(NSString *)level;

- (NSArray *)findViaParentCode:(NSString *)parentCode;

- (NSArray *)findAll;

@end
