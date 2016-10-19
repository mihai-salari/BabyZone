//
//  OCMethod.h
//  EnjoyLove
//
//  Created by 黄漫 on 16/10/2.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (OCMethod)

@end

@interface NSString (OCMethod)
- (BOOL) isValidateNumber;
@end

@interface UIViewController (OCMethod)

- (void)dismissToRootViewController;

- (void)navigationBarItemWithNavigationTitle:(NSString *)title isImage:(BOOL)image leftSelector:(SEL)lsel leftImage:(NSString *)limage letfTitle:(NSString *)ltitle leftItemSize:(CGSize)lsize rightSelector:(SEL)rsel rightImage:(NSString *)rimage rightTitle:(NSString *)rtitle rightItemSize:(CGSize)rsize;
@end

@interface HMHUD : NSObject

+ (void)showHud:(NSString *)tip onView:(UIView *)view;

+ (void)showHudTip:(NSString *)tip forView:(UIView *)view;

+ (void)hideHud:(UIView *)view;

+ (void)showText:(NSString *)tip onView:(UIView *)view;


@end

@interface UIImage (OCMethod)
+ (UIImage *)imageFromColor:(UIColor *)color andSize:(CGSize)size;
@end


@interface UIColor (OCMethod)

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (UIColor*)colorFromRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

+ (UIColor*)colorFromRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

@end

@interface VideoTime : NSObject

+ (VideoTime *)shared;

@property(readonly) int lastGroup;
@property(readonly) int lastPin;
@property(readonly) int lastValue;
@property(readonly) int *lastTime;

- (void)refresh:(int)group pin:(int)p value:(int)val;

@end






