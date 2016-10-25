//
//  OCMethod.m
//  EnjoyLove
//
//  Created by 黄漫 on 16/10/2.
//  Copyright © 2016年 HuangSam. All rights reserved.
//
#include <arpa/inet.h>
#include <ifaddrs.h>
#import "OCMethod.h"
#import "MBProgressHUD.h"
#import "EnjoyLove-Swift.h"
@implementation NSObject (OCMethod)


- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

@end

@implementation NSString (OCMethod)

- (BOOL) isValidateNumber{
    const char *cvalue = [self UTF8String];
    int len = strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9')) {
            return FALSE;
        }
    }
    return TRUE;
}

@end

@implementation UIViewController (OCMethod)

- (void)dismissToRootViewController{
    UIViewController *controller = self;
    while (controller.presentingViewController != nil) {
        controller = controller.presentingViewController;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationBarItemWithNavigationTitle:(NSString *)title isImage:(BOOL)image leftSelector:(SEL)lsel leftImage:(NSString *)limage letfTitle:(NSString *)ltitle leftItemSize:(CGSize)lsize rightSelector:(SEL)rsel rightImage:(NSString *)rimage rightTitle:(NSString *)rtitle rightItemSize:(CGSize)rsize{
    self.navigationItem.title = title;
    if (lsel) {
        if (image) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, lsize.width, lsize.height);
            [btn setImage:[UIImage imageWithName:limage] forState:UIControlStateNormal];
            [btn addTarget:self action:lsel forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }else{
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ltitle style:UIBarButtonItemStylePlain target:self action:lsel];
        }
    }
    
    if (rsel) {
        if (image) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, rsize.width, rsize.height);
            [btn setImage:[UIImage imageWithName:rimage] forState:UIControlStateNormal];
            [btn addTarget:self action:rsel forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }else{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rtitle style:UIBarButtonItemStylePlain target:self action:rsel];
        }
    }
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end

static int hudViewTag = 1000000;
@implementation HMHUD

+ (void)showHud:(NSString *)tip onView:(UIView *)view{
    [[self class] onMain:^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.label.text = tip;
        hud.label.numberOfLines = 0;
        hud.tag = hudViewTag;
    }];
}

+ (void)showHudTip:(NSString *)tip forView:(UIView *)view{
    [[self class] onMain:^{
        MBProgressHUD *targetView = [view viewWithTag:hudViewTag];
        targetView.label.text = tip;
        targetView.label.numberOfLines = 0;
    }];
}

+ (void)hideHud:(UIView *)view{
    [[self class] onMain:^{
        MBProgressHUD *targetView = [view viewWithTag:hudViewTag];
        [targetView hideAnimated:YES];
        [targetView removeFromSuperViewOnHide];
        targetView = nil;
    }];
}

+ (void)showText:(NSString *)tip onView:(UIView *)view{
    [[self class] onMain:^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.offset = CGPointMake(0, MBProgressMaxOffset);
        hud.square = YES;
        hud.label.text = tip;
        hud.label.numberOfLines = 0;
        [hud hideAnimated:YES afterDelay:3.0];
    }];
}

+ (void)onMain:(void(^)())completionHandler{
    if (completionHandler) {
        if ([NSOperationQueue currentQueue] == [NSOperationQueue mainQueue]) {
            completionHandler();
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler();
            });
        }
    }
}

@end

@implementation UIImage (OCMethod)

+ (UIImage *)imageFromColor:(UIColor *)color andSize:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation UIColor (OCMethod)

+ (UIColor *)colorFromHexString:(NSString *)hexString{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return  [UIColor grayColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];

}

+ (UIColor*)colorFromRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue{
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue/255.0) alpha:1.0];
}

+ (UIColor*)colorFromRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue/255.0) alpha:alpha];
}



@end


@interface VideoTime ()

@property(nonatomic) int lastGroup;
@property(nonatomic) int lastPin;
@property(nonatomic) int lastValue;
@property(nonatomic) int *lastTime;

@end

@implementation VideoTime


+ (VideoTime *)shared{
    static VideoTime *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [manager setIfNeed];
    });
    return manager;
}

- (void)setIfNeed{
    int time[8] = {0};
    time[0] = -15;
    time[1] = 6000;
    time[2] = -1;
    //记录当前的GPIO设置参数
    self.lastGroup = 1;
    self.lastPin = 0;
    self.lastValue = 3;
    self.lastTime = time;
}

- (void)refresh:(int)group pin:(int)p value:(int)val{
    int time[8] = {0};
    time[0] = -1000;
    time[1] = 1000;
    time[2] = -1000;
    time[3] = 1000;
    time[4] = -1000;
    self.lastGroup = group;
    self.lastPin = p;
    self.lastValue = val;
    self.lastTime = time;
}

@end




