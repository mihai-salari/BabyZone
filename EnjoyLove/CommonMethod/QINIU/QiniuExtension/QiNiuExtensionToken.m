//
//  QiNiuExtensionToken.m
//  EnjoyLove
//
//  Created by HuangSam on 2016/10/15.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

#import "QiNiuExtensionToken.h"
#import <CommonCrypto/CommonCrypto.h>
#import "JSONKit.h"
#import "GTMBase64.h"
#define QINIU_AK  @"Y-IZ6mOA6Rh_gVbqLTOdeISFdmQiIEVc3BttLQny"
#define QINIU_SK  @"abniSlBJE7xdIV807-TM98ekZa1gJNnw8EIXoLGw"

@interface QiNiuExtensionToken ()
@property (nonatomic , assign) int expires;
@property (nonatomic, copy) NSString *scope;
@end


@implementation QiNiuExtensionToken

+ (QiNiuExtensionToken *)shared{
    static QiNiuExtensionToken *token = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        token = [[QiNiuExtensionToken alloc] init];
    });
    return token;
}

- (NSString *)makeTokenWithScope:(NSString *)scope
{
    self.scope = scope;
    const char *secretKeyStr = [QINIU_SK UTF8String];
    
    NSString *policy = [self marshal];
    
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodedPolicy = [GTMBase64 stringByWebSafeEncodingData:policyData padded:TRUE];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    
    NSString *encodedDigest = [GTMBase64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  QINIU_AK, encodedDigest, encodedPolicy];
    
    return token;//得到了token
}
- (NSString *)marshal
{
    time_t deadline;
    time(&deadline);//返回当前系统时间
    //@property (nonatomic , assign) int expires; 怎么定义随你...
    deadline += (self.expires > 0) ? self.expires : 3600; // +3600秒,即默认token保存1小时.
    
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //users是我开辟的公共空间名（即bucket），aaa是文件的key，
    //按七牛“上传策略”的描述：    <bucket>:<key>，表示只允许用户上传指定key的文件。在这种格式下文件默认允许“修改”，若已存在同名资源则会被覆盖。如果只希望上传指定key的文件，并且不允许修改，那么可以将下面的 insertOnly 属性值设为 1。
    //所以如果参数只传users的话，下次上传key还是aaa的文件会提示存在同名文件，不能上传。
    //传users:aaa的话，可以覆盖更新，但实测延迟较长，我上传同名新文件上去，下载下来的还是老文件。
    [dic setObject:self.scope forKey:@"scope"];//根据
    
    [dic setObject:deadlineNumber forKey:@"deadline"];
    
    NSString *json = [dic JSONString];
    
    return json;
}

@end
