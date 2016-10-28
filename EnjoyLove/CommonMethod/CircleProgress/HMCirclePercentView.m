//
//  CirclePercentView.m
//  DrawCircleAnimation
//
//

#import "HMCirclePercentView.h"

#define kStartAngle -M_PI_2

@interface HMCirclePercentView()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *circle;
@property (nonatomic) CGPoint centerPoint;
@property (nonatomic) CGFloat duration;
@property (nonatomic) CGFloat percent;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat trackWidth;
@property (nonatomic) CGFloat progressWidth;
@property (nonatomic) BOOL showText;
@property (nonatomic, strong) UIColor *progressFillColor;
@property (nonatomic, strong) UIColor *progressStrokeColor;
@property (nonatomic, strong) UIColor *trackFillColor;
@property (nonatomic, strong) UIColor *trackStrokeColor;
@property (nonatomic) NSString *lineCap; // kCALineCapButt, kCALineCapRound, kCALineCapSquare
@property (nonatomic) BOOL clockwise;
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) UILabel *percentLabel;
@end

@implementation HMCirclePercentView

- (instancetype)initWithFrame:(CGRect)frame showText:(BOOL)show{
    self = [super initWithFrame:frame];
    if (self) {
        self.showText = show;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    self.backgroundLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.backgroundLayer];
    
    self.circle = [CAShapeLayer layer];
    [self.layer addSublayer:self.circle];
    
    if (self.showText) {
        self.percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, self.frame.size.height / 2)];
        self.percentLabel.font = [UIFont boldSystemFontOfSize:self.fontSize];
        [self addSubview:self.percentLabel];
    }
    
    self.colors = [NSMutableArray new];
}


- (void)drawCircleWithPercent:(CGFloat)percent
                     duration:(CGFloat)duration
                    lineWidth:(CGFloat)lineWidth
                    clockwise:(BOOL)clockwise
                      lineCap:(NSString *)lineCap
                    fillColor:(UIColor *)fillColor
                  strokeColor:(UIColor *)strokeColor
               animatedColors:(NSArray *)colors {
    
#if 0
    self.duration = duration;
    self.percent = percent;
    self.lineWidth = lineWidth;
    self.clockwise = clockwise;
    [self.colors removeAllObjects];
    if (colors != nil) {
        for (UIColor *color in colors) {
            [self.colors addObject:(id)color.CGColor];
        }
    } else {
        [self.colors addObject:(id)strokeColor.CGColor];
    }
    
    CGFloat min = MIN(self.frame.size.width, self.frame.size.height);
    self.radius = (min - lineWidth)  / 2;
    self.centerPoint = CGPointMake(self.frame.size.width / 2 - self.radius, self.frame.size.height / 2 - self.radius);
    self.lineCap = lineCap;
    
    [self setupBackgroundLayerWithFillColor:fillColor];
    [self setupCircleLayerWithStrokeColor:strokeColor];
//    [self setupPercentLabel];
#endif
}

- (void)drawPieChartWithPercent:(CGFloat)percent
                       duration:(CGFloat)duration
                      clockwise:(BOOL)clockwise
                      fillColor:(UIColor *)fillColor
                    strokeColor:(UIColor *)strokeColor
                 animatedColors:(NSArray *)colors {
    
#if 0
    self.duration = duration;
    self.percent = percent;
    self.clockwise = clockwise;
    [self.colors removeAllObjects];
    if (colors != nil) {
        
        for (UIColor *color in colors) {
            [self.colors addObject:(id)color.CGColor];
        }
    } else {
        [self.colors addObject:(id)strokeColor.CGColor];
    }
    
    CGFloat min = MIN(self.frame.size.width, self.frame.size.height);
    self.lineWidth = min  / 2;
    self.radius = (min - self.lineWidth) / 2;
    self.centerPoint = CGPointMake(self.frame.size.width / 2 - self.radius, self.frame.size.height / 2 - self.radius);
    self.lineCap = kCALineCapButt;
    
    [self setupBackgroundLayerWithFillColor:fillColor];
    [self setupCircleLayerWithStrokeColor:strokeColor];
    [self setupPercentLabel];
#endif
}


- (void)drawCircleWithPercent:(CGFloat)percent
                     duration:(CGFloat)duration
                   trackWidth:(CGFloat)trackWidth
                progressWidth:(CGFloat)progressWidth
                    clockwise:(BOOL)clockwise
                      lineCap:(NSString *)lineCap
                trackFillColor:(UIColor *)trackFillColor
             trackStrokeColor:(UIColor *)trackStrokeColor
            progressFillColor:(UIColor *)progressFillColor
          progressStrokeColor:(UIColor *)progressStrokeColor
               animatedColors:(NSArray *)colors{
    self.duration = duration;
    self.percent = percent;
    self.lineWidth = 0;
    self.trackWidth = trackWidth;
    self.progressWidth = progressWidth;
    self.trackFillColor = trackFillColor;
    self.trackStrokeColor = trackStrokeColor;
    self.progressFillColor = progressFillColor;
    self.progressStrokeColor = progressStrokeColor;
    self.clockwise = clockwise;
    [self.colors removeAllObjects];
    if (colors != nil) {
        for (UIColor *color in colors) {
            [self.colors addObject:(id)color.CGColor];
        }
    } else {
        [self.colors addObject:(id)progressStrokeColor.CGColor];
    }
    
    CGFloat min = MIN(self.frame.size.width, self.frame.size.height);
    self.radius = (min - trackWidth)  / 2;
    self.centerPoint = CGPointMake(self.frame.size.width / 2 - self.radius, self.frame.size.height / 2 - self.radius);
    self.lineCap = lineCap;
    
    [self setupBackgroundLayerWithFillColor:self.trackFillColor];
    [self setupCircleLayerWithStrokeColor:self.progressStrokeColor];
    if (self.showText) {
        [self setupPercentLabel];
    }
}

- (void)updateCircleWithPercent:(CGFloat)percent{
    [self setupBackgroundLayerWithFillColor:self.trackFillColor];
    [self setupCircleLayerWithStrokeColor:self.progressStrokeColor];
}


- (void)setupBackgroundLayerWithFillColor:(UIColor *)fillColor {

    self.backgroundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:kStartAngle endAngle:2*M_PI + kStartAngle clockwise:self.clockwise].CGPath;                                             //(kStartAngle + (100 * 2 * M_PI) / 100)
    
    // Center the shape in self.view
    self.backgroundLayer.position = self.centerPoint;
    
    // Configure the apperence of the circle
    self.backgroundLayer.fillColor = fillColor.CGColor;
    self.backgroundLayer.strokeColor = self.trackStrokeColor.CGColor;
    self.backgroundLayer.lineWidth = self.lineWidth == 0 ? self.trackWidth : self.lineWidth;
    self.backgroundLayer.lineCap = self.lineCap;
    self.backgroundLayer.rasterizationScale = 2 * [UIScreen mainScreen].scale;
    self.backgroundLayer.shouldRasterize = YES;

}

- (void)setupCircleLayerWithStrokeColor:(UIColor *)strokeColor {
    // Set up the shape of the circle

    CGFloat endAngle = [self calculateToValueWithPercent:self.percent];
    
    // Make a circular shape
    self.circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:kStartAngle endAngle:endAngle clockwise:self.clockwise].CGPath;
    
    // Center the shape in self.view
    
    self.circle.position = self.centerPoint;
    
    // Configure the apperence of the circle
    self.circle.fillColor = self.progressFillColor.CGColor;
    self.circle.strokeColor = self.progressStrokeColor.CGColor;
    self.circle.lineWidth = self.lineWidth == 0 ? self.progressWidth : self.lineWidth;
    self.circle.lineCap = self.lineCap;
    self.circle.shouldRasterize = YES;
    self.circle.rasterizationScale = 2 * [UIScreen mainScreen].scale;

}

- (void)setupPercentLabel {

    NSLayoutConstraint *centerHor = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.percentLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerVer = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.percentLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

    self.percentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[centerHor, centerVer]];
    [self layoutIfNeeded];
    self.percentLabel.text = [NSString stringWithFormat:@"%d", (int)self.percent];
    self.percentLabel.textColor = [UIColor whiteColor];
}

- (void)startAnimation {
    [self drawBackgroundCircle];
    [self drawCircle];
    if (self.showText) {
        HMPercentLabel *tween = [[HMPercentLabel alloc] initWithObject:self.percentLabel key:@"text" from:0 to:self.percent duration:self.duration];
        tween.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [tween start];
    }
}

- (void)drawCircle {
    
    [self.circle removeAllAnimations];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = self.duration; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // Add the animation to the circle
    [self.circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    
    CAKeyframeAnimation *colorsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
    colorsAnimation.values = self.colors;
//    colorsAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.3], [NSNumber numberWithFloat:0.8], [NSNumber numberWithFloat:1.0], nil];
    colorsAnimation.calculationMode = kCAAnimationPaced;
    colorsAnimation.removedOnCompletion = NO;
    colorsAnimation.fillMode = kCAFillModeForwards;
    colorsAnimation.duration = self.duration;

    [self.circle addAnimation:colorsAnimation forKey:@"strokeColor"];
}

- (void)drawBackgroundCircle {
    [self.backgroundLayer removeAllAnimations];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = self.duration; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // Add the animation to the circle
    [self.backgroundLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
}

- (CGFloat)calculateToValueWithPercent:(CGFloat)percent {
    return (kStartAngle + (percent * 2 * M_PI) / 100);
}

- (NSArray *)calculateColorsWithPercent:(CGFloat)percent {
    NSMutableArray *colorsArray = [NSMutableArray new];
    if (percent <= 30) {
        [colorsArray addObject:(id)[UIColor greenColor].CGColor];
    }
    
    if (percent > 30 && percent <= 80 ) {
        [colorsArray addObject:(id)[UIColor greenColor].CGColor];
        [colorsArray addObject:(id)[UIColor yellowColor].CGColor];
    }
    
    if (percent > 80) {
        [colorsArray addObject:(id)[UIColor greenColor].CGColor];
        [colorsArray addObject:(id)[UIColor yellowColor].CGColor];
        [colorsArray addObject:(id)[UIColor orangeColor].CGColor];
        [colorsArray addObject:(id)[UIColor redColor].CGColor];
    }
    
    return colorsArray;
}

@end


