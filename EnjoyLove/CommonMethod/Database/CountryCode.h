//
//  CountryCode.h
//  EnjoyLove
//
//  Created by HuangSam on 2016/10/18.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryCode : NSObject

+ (CountryCode *)shared;

- (NSArray *)findViaName:(NSString *)name;

- (NSArray *)findViaLevel:(NSString *)level;

- (NSArray *)findViaParentCode:(NSString *)parentCode;

- (NSArray *)findAll;

@end
