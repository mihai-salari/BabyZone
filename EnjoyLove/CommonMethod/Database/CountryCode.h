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

- (void)findAll;

@end
