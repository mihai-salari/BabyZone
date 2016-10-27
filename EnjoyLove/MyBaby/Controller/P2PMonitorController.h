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
#import "OpenGLView.h"
#import "AppDelegate.h"

@interface P2PMonitorController : OCBaseViewController<AVCaptureVideoDataOutputSampleBufferDelegate,UIGestureRecognizerDelegate,OpenGLViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>//监控界面缩放
@property (nonatomic, strong) Contact *deviceContact;

@property (nonatomic, copy) void(^monitorRefreshHandler)(UIImage *currentImage);

@end
