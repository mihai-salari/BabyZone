//
//  TweenLabel.h
//  DrawCircleAnimation
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HMPercentLayer;
@protocol HMPercentDelegate;

@interface HMPercentLabel : NSObject
@property (strong, nonatomic) CAMediaTimingFunction *timingFunction;

- (instancetype)initWithObject:(UIView *)object key:(NSString *)key from:(CGFloat)fromValue to:(CGFloat)toValue duration:(NSTimeInterval)duration;

- (void)start;
@end

@interface HMPercentLayer : CALayer

@property (strong, nonatomic) id<HMPercentDelegate> tweenDelegate;
@property (nonatomic) CGFloat fromValue;
@property (nonatomic) CGFloat toValue;
@property (nonatomic) NSTimeInterval tweenDuration;

- (instancetype)initWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration;
- (void)startAnimation;
@end

@protocol HMPercentDelegate <NSObject>

- (void)layer:(HMPercentLayer *)layer didSetAnimationPropertyTo:(CGFloat)toValue;
- (void)layerDidStopAnimation;

@end