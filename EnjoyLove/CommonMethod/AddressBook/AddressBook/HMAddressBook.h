//
//  HMAddressBook.h
//  HMAddressBook
//
//  Created by mainone on 16/9/14.
//  Copyright © 2016年 wjn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMAddressBookHandle.h"
#import "HMPersonModel.h"



/**
 *  获取原始顺序的所有联系人的Block
 */
typedef void(^AddressBookArrayBlock)(NSArray<HMPersonModel *> *addressBookArray);
/**
 *  获取按A~Z顺序排列的所有联系人的Block
 *
 *  @param addressBookDict       装有所有联系人的字典->每个字典key对应装有多个联系人模型的数组->每个模型里面包含着用户的相关信息.
 *  @param peopleNameKey         联系人姓名的大写首字母的数组
 */
typedef void(^AddressBookDictBlock)(NSDictionary<NSString *,NSArray *> *addressBookDict,NSArray *peopleNameKey);



@interface HMAddressBook : NSObject

/**
 *  请求用户是否授权app访问通讯录,最好在app启动的时候就请求
 */
+ (void)requestAddressBookAuthorization:(void(^)(BOOL success, NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *peopleNameKey))completionHandler;

/**
 *  获取按A~Z顺序排列的所有联系人
 *
 *  @param addressBookArray 联系人信息数组
 *  @param failure          授权失败
 */
+ (void)getOriginalAddressBook:(AddressBookArrayBlock)addressBookArr authorizationFailure:(AuthorizationFailure)failure;

/**
 *  获取按A~Z顺序排列的所有联系人
 *
 *  @param addressBookInfo 联系人信息字典
 *  @param failure         授权失败
 */
+ (void)getOrderAddressBook:(AddressBookDictBlock)addressBookInfo authorizationFailure:(AuthorizationFailure)failure;


/**
 *  添加联系人到通讯录中
 *
 *  @param person  联系人信息模型
 *  @param failure 授权失败
 */
+ (void)addPersonToAddressBook:(HMPersonModel *)person failure:(AuthorizationFailure)failure;



@end

@interface NSString (Helper)
/**
 *  获取字符串拼音
 *
 *  @return 
 */
- (NSString *)pinyin;
@end
