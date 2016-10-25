//
//  P2PMonitorController.h
//  Yoosee
//
//  Created by guojunyi on 14-3-26.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "P2PClient.h"
#import <AVFoundation/AVFoundation.h>
//#import "TouchButton.h"
#import "OpenGLView.h"
//#import "CustomBorderButton.h"
//#import "CustomView.h"
//#import "ProgressImageView.h"
//#import "MainController.h"
#import "AppDelegate.h"
#define FocalLength_Elongation_btnTag 300
#define FocalLength_Shorten_btnTag 301
#define FocalLength_Change_sliderTag 302

//竖屏
#define SOUND_BUTTON_H_TAG 1603221
#define SWITCH_SCREEN_BUTTON_H_TAG 1603222
#define DEFENCE_BUTTON_H_TAG 1603223
#define TALK_BUTTON_H_TAG 1603224
#define SCREENSHOT_BUTTON_H_TAG 1603225
#define PROMPT_BUTTON_TAG 1603226

@interface P2PMonitorController : OCBaseViewController<AVCaptureVideoDataOutputSampleBufferDelegate,UIGestureRecognizerDelegate,OpenGLViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>//监控界面缩放
@property (nonatomic, strong) Contact *deviceContact;


@end
