//
//  CirclePercentView.h
//  DrawCircleAnimation
//
//

#import <UIKit/UIKit.h>
#import "HMPercentLabel.h"

typedef enum {
    CirclePercentTypeLine = 0,
    CirclePercentTypePie
} CirclePercentType;

@interface HMCirclePercentView : UIView

@property (nonatomic, strong) NSString *key; 
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;
@property (nonatomic, assign) CGFloat fontSize;

/*
 * Auto calculated radius base on View's frame
 *
 * @param percent percent of circle to display
 * @param lineWidth witdth of circle
 * @param clockwise determine clockwise
 * @param fillColor color inside cricle
 * @param strokeColor color of circle line
 * @param animatedColors colors array to animated. if this param is nil, Stroke color will be used to draw circle
 */

- (instancetype)initWithFrame:(CGRect)frame showText:(BOOL)show;

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
               animatedColors:(NSArray *)colors;

- (void)updateCircleWithPercent:(CGFloat)percent;

#if 0

- (void)drawCircleWithPercent:(CGFloat)percent
                     duration:(CGFloat)duration
                    lineWidth:(CGFloat)lineWidth
                    clockwise:(BOOL)clockwise
                      lineCap:(NSString *)lineCap
                    fillColor:(UIColor *)fillColor
                  strokeColor:(UIColor *)strokeColor
               animatedColors:(NSArray *)colors;

- (void)drawPieChartWithPercent:(CGFloat)percent
                       duration:(CGFloat)duration
                      clockwise:(BOOL)clockwise
                      fillColor:(UIColor *)fillColor
                    strokeColor:(UIColor *)strokeColor
                 animatedColors:(NSArray *)colors;

#endif

/*
 * Start draw animation
 */
- (void)startAnimation;

@end
