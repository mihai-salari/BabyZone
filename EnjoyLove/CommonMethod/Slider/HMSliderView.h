//
//  SliderView.h
//  Slider
//
//  Created by Mathieu Bolard on 02/02/12.
//  Copyright (c) 2012 Streettours. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HM)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end

@class HMSliderLabel;
@protocol HMSliderViewDelegate;

@interface HMSliderView : UIView {
    UISlider *_slider;
    HMSliderLabel *_label;
    id<HMSliderViewDelegate> _delegate;
    BOOL _sliding;
}

@property (nonatomic, assign) NSString *text;
@property (nonatomic, assign) UIColor *labelColor;
@property (nonatomic) IBOutlet id<HMSliderViewDelegate> delegate;
@property (nonatomic) BOOL enabled;

- (void)setThumbColor:(UIColor *)color;

- (void)setThumbImage:(UIImage *)image;


@end

@protocol HMSliderViewDelegate <NSObject>

- (void) sliderDidSlide:(HMSliderView *)slideView;

@end




@interface HMSliderLabel : UILabel {
    NSTimer *animationTimer;
    CGFloat gradientLocations[3];
    int animationTimerCount;
    BOOL _animated;
}

@property (nonatomic, assign, getter = isAnimated) BOOL animated;

@end