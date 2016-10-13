//
//  TweenLabel.m
//  DrawCircleAnimation
//
//

#import "HMPercentLabel.h"

@interface HMPercentLabel() <HMPercentDelegate>

@property (strong, nonatomic) HMPercentLayer *layer;
@property (strong, nonatomic) UIView *object;
@property (strong, nonatomic) NSString *key;

@end

@implementation HMPercentLabel

- (instancetype)initWithObject:(UIView *)object key:(NSString *)key from:(CGFloat)fromValue to:(CGFloat)toValue duration:(NSTimeInterval)duration {
    self = [super init];
    if (self) {
        self.object = object;
        self.key = key;
        self.layer = [[HMPercentLayer alloc] init];
        self.layer.fromValue = fromValue;
        self.layer.toValue = toValue;
        self.layer.tweenDuration = duration;
        self.layer.tweenDelegate = self;
        [self.object.layer addSublayer:self.layer];
    }
    return self;
}

- (void)start {
    [self.layer startAnimation];
}

- (void)layer:(HMPercentLayer *)layer didSetAnimationPropertyTo:(CGFloat)toValue {
    int percent = (int)toValue;
    NSString *text = [NSString stringWithFormat:@"%2d", percent];
    [self.object setValue:text forKey:self.key];
}

- (void)layerDidStopAnimation {
    int percent = (int)self.layer.toValue;
    NSString *text = [NSString stringWithFormat:@"%2d", percent];
    [self.object setValue:text forKey:self.key];
    [self.layer removeFromSuperlayer];
}
@end


//=============================================================//
@interface HMPercentLayer()

@property (nonatomic) CGFloat animatableProperty;
@property (nonatomic) CGFloat delay;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) CAMediaTimingFunction *timingFunction;

@end

@implementation HMPercentLayer

@dynamic animatableProperty;
@dynamic color;

- (instancetype)initWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration {
    self = [super init];
    if (self) {
        self.fromValue = fromValue;
        self.toValue = toValue;
        self.duration = duration;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {

    if ([key isEqualToString:@"animatableProperty"] || [key isEqualToString:@"color"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

- (id<CAAction>)actionForKey:(NSString *)event {
    if (![event isEqualToString:@"animatableProperty"] && ![event isEqualToString:@"color"]) {
        return [super animationForKey:event];
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
    animation.timingFunction = self.timingFunction;
    animation.fromValue = [NSNumber numberWithFloat:self.fromValue];
    animation.toValue = [NSNumber numberWithFloat:self.toValue];
    animation.duration = self.tweenDuration;
    animation.beginTime = CACurrentMediaTime() + self.delay;
    animation.delegate = self;
    
    return animation;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.tweenDelegate layerDidStopAnimation];
}

- (void)display {
    if (self.presentationLayer != nil) {
        HMPercentLayer *tweenLayer = (HMPercentLayer *)self.presentationLayer;
        [self.tweenDelegate layer:self didSetAnimationPropertyTo:tweenLayer.animatableProperty];
    }
}

- (void)startAnimation {
    self.animatableProperty = self.toValue;
}
@end