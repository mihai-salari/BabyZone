//
//  HMAddressBook.m
//  HMAddressBook
//
//  Created by mainone on 16/9/14.
//  Copyright © 2016年 wjn. All rights reserved.
//

#import "HMAddressBook.h"
#define START NSDate *startTime = [NSDate date]
#define END NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

@implementation HMAddressBook

+ (void)requestAddressBookAuthorization:(void(^)(BOOL success, NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *peopleNameKey))completionHandler {
    if(IOS9_LATER) {
#ifdef __IPHONE_9_0
        // 1.判断是否授权成功,若授权成功直接return
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) return;
        // 2.创建通讯录
        CNContactStore *store = [[CNContactStore alloc] init];
        // 3.授权
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                
                [[self class] getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *peopleNameKey) {
                    if (completionHandler) {
                        completionHandler(YES, addressBookDict, peopleNameKey);
                    }
                } authorizationFailure:nil];
                
            }else{
                if (completionHandler) {
                    completionHandler(NO, nil,nil);
                }
            }
        }];
#endif
    } else {
        // 1.获取授权的状态
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        // 2.判断授权状态,如果是未决定状态,才需要请求
        if (status == kABAuthorizationStatusNotDetermined) {
            // 3.创建通讯录进行授权
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    
                    [[self class] getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *peopleNameKey) {
                        if (completionHandler) {
                            completionHandler(YES, addressBookDict, peopleNameKey);
                        }
                    } authorizationFailure:nil];
                    
                }else{
                    if (completionHandler) {
                        completionHandler(NO, nil,nil);
                    }
                }
            });
        }
    }
}

#pragma mark - 排序所有联系人
+ (void)getOriginalAddressBook:(AddressBookArrayBlock)addressBookArr authorizationFailure:(AuthorizationFailure)failure {
    //开启一个子线程,将耗时操作放到异步串行队列
    dispatch_queue_t queue = dispatch_queue_create("addressBookArray", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        NSMutableArray *array = [NSMutableArray array];
        [HMAddressBookHandle getAddressBookDataSource:^(HMPersonModel *model) {
            //将单个联系人模型装进数组
            [array addObject:model];
        } authorizationFailure:^{
            //将授权失败的信息回调到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                failure ? failure() : nil;
            });
        }];
        // 将联系人数组回调到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            addressBookArr ? addressBookArr(array) : nil ;
        });
    });
}

+ (NSArray *)customSortWithArray:(NSArray<HMPersonModel *> *)array
{
    NSArray *results = [array sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    return results;
}

/**
 *  数组排序
 *
 *  @param array
 *  @param key
 *
 *  @return
 */
+ (NSArray *)sortWithArray:(NSArray *)array key:(NSString *)key
{
    NSArray *resultArray = [array sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:YES]]];
    return resultArray;
}

#pragma mark - 获取按A~Z顺序排列的所有联系人
+ (void)getOrderAddressBook:(AddressBookDictBlock)addressBookInfo authorizationFailure:(AuthorizationFailure)failure {
    
    //开启一个子线程,将耗时操作放到异步串行队列
    dispatch_queue_t queue = dispatch_queue_create("addressBookInfo", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSMutableDictionary *addressBookDict = [NSMutableDictionary dictionary];
        //***************** 这是一段耗时操作 **********************//
        [HMAddressBookHandle getAddressBookDataSource:^(HMPersonModel *model) {
            //获取到姓名的大写首字母
            NSString *firstLetterString = [self getFirstLetterFromString:model.name];
            //如果该字母对应的联系人模型不为空,则将此联系人模型添加到此数组中
            if (firstLetterString) {
                if (addressBookDict[firstLetterString]) {
                    [addressBookDict[firstLetterString] addObject:model];
                } else {//没有出现过该首字母，则在字典中新增一组key-value
                    //创建新发可变数组存储该首字母对应的联系人模型
                    NSMutableArray *arrGroupNames = [NSMutableArray arrayWithObject:model];
                    //将首字母-姓名数组作为key-value加入到字典中
                    [addressBookDict setObject:arrGroupNames forKey:firstLetterString];
                }
            }
        } authorizationFailure:^{
            //将授权失败的信息回调到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                failure ? failure() : nil;
            });
        }];
        //***************** 这是一段耗时操作 **********************//
        // 重新对所有大写字母Key值里面对应的的联系人数组进行排序
        //1.遍历联系人字典中所有的元素,利用到多核cpu的优势,参考:http://blog.sunnyxx.com/2014/04/30/ios_iterator/
        [addressBookDict enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, NSMutableArray * _Nonnull keyPeopleArray, BOOL * _Nonnull stop) {
            //2.对每个Key值对应的数组里的元素来排序
            [keyPeopleArray sortUsingComparator:^NSComparisonResult(HMPersonModel*  _Nonnull obj1, HMPersonModel  *_Nonnull obj2) {
                return [obj1.name localizedCompare:obj2.name];
            }];
        }];
        // 将addressBookDict字典中的所有Key值进行排序: A~Z
        NSArray *peopleNameKey = [[addressBookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        // 把#挪到最后显示
        NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:peopleNameKey];
        if ([peopleNameKey containsObject:@"#"]) {
            [mutableArr removeObject:@"#"];
            [mutableArr insertObject:@"#" atIndex:mutableArr.count];
        }
        // 将排序好的通讯录数据回调到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            addressBookInfo ? addressBookInfo(addressBookDict,mutableArr) : nil;
        });
    });
}

#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)getFirstLetterFromString:(NSString *)aString {
    if (aString) {
        NSMutableString *str = [NSMutableString stringWithString:aString];
        //带声调的拼音
        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
        //不带声调的拼音
        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
        //转化为大写拼音
        NSString *strPinYin   = [str capitalizedString];
        NSString *firstString = [strPinYin substringToIndex:1];
        //判断姓名首位是否为大写字母
        NSString * regexA     = @"^[A-Z]$";
        NSPredicate *predA    = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
        //获取并返回首字母
        return [predA evaluateWithObject:firstString] ? firstString : @"#";
    }
    return nil;
}


+ (void)addPersonToAddressBook:(HMPersonModel *)person failure:(AuthorizationFailure)failure {
    [HMAddressBookHandle addPersonToAddressBook:person failure:^{
        failure ? failure() : nil;
    }];
}




@end

@implementation NSString (Helper)
/**
 *  获取字符串拼音
 *
 *  @return 
 */
- (NSString *)pinyin
{
    if (self.length)
    {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:self];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO))
        {
            //带音调
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO))
            {
                //不带音调
                return [ms uppercaseString];
            }
        }
        
    }
    return nil;
}
@end
