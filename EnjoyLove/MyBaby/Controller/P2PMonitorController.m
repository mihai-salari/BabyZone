///
//  P2PMonitorController.m
//  Yoosee
//
//  Created by guojunyi on 14-3-26.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

/***********UI逻辑**************
 1、ap模式和局域网机器使用rtsp连接
 2、画布：
 rtsp:根据opengl解码动态,因为一般ipc是16：9，960p的机器是4:3
 3、分辨率设置
 rtsp:不支持
 4、当前观看人数
 rtsp:不支持 （因为rtsp连接时不会收到通知，所以不用处理此处逻辑）
 ******************************/
#import "EnjoyLove-Swift.h"
#import "P2PMonitorController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "P2PClient.h"
#import "Toast+UIView.h"
#import "AppDelegate.h"
#import "PAIOUnit.h"
#import "UDManager.h"
#import "LoginResult.h"
#import "Utils.h"
#import "ContactDAO.h"
#import "FListManager.h"
#import "Contact.h"
#import "OCMethod.h"

#define MAX_VIDEO_RES_SIZE ((1920+32)*1088)

#define BUTTON_WIDTH    60
#define BUTTON_PADDING  8

#define BUTTON_CAMERA_TAG  1000
#define BUTTON_VIDEO_TAG   1001
#define BUTTON_MUSIC_TAG   1002
#define BUTTON_VOICE_TAG   1003
#define BUTTON_CANCEL_TAG  1004

@interface P2PMonitorController ()
{
    
    BOOL _isPlaying;
}

@property (nonatomic, strong) OpenGLView *remoteView;
@property (nonatomic) BOOL isReject;
@property (nonatomic) BOOL isFullScreen4B3;
@property (nonatomic) BOOL isShowControllerBar;
@property (nonatomic) BOOL isVideoModeHD;

@property (nonatomic,strong) UIScrollView *scrollView;//监控界面缩放
@property (nonatomic) BOOL isScale;//监控界面缩放

@property (strong, nonatomic) UIView *bottomView;//重新调整监控画面
@property (strong, nonatomic) UIView *pressView;
@property (nonatomic) BOOL isTalking;

@property (strong, nonatomic) UIView *controllerRight;
@property (strong, nonatomic) UIView *controllerRightBg;//重新调整监控画面
@property (strong, nonatomic) UIView *bottomBarView;//重新调整监控画面
@property (strong, nonatomic) UIView *controllBar;

@property (nonatomic) BOOL isAlreadyShowResolution;//重新调整监控画面

@property (nonatomic) BOOL isDefenceOn;//重新调整监控画面

@property(nonatomic) BOOL isShowLeftView;

@property(nonatomic) int lastGroup;
@property(nonatomic) int lastPin;
@property(nonatomic) int lastValue;
@property(nonatomic) int *lastTime;

@property(nonatomic, strong) UIButton *clickGPIO0_0Button;
@property(nonatomic, strong) UIButton *clickGPIO0_1Button;
@property(nonatomic, strong) UIButton *clickGPIO0_2Button;
@property(nonatomic, strong) UIButton *clickGPIO0_3Button;
@property(nonatomic, strong) UIButton *clickGPIO0_4Button;
@property(nonatomic, strong) UIButton *clickGPIO2_6Button;

@property(nonatomic, strong) UIButton *lightButton;
@property (nonatomic) BOOL isLightSwitchOn;
@property (strong, nonatomic) UIActivityIndicatorView *progressView;
@property (nonatomic) BOOL isSupportLightSwitch;



@property (strong, nonatomic) UIView *focalLengthView;
@property (nonatomic) BOOL isSupportFocalLength;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGestureRecognizer;

//判断当前监控处于横屏还是竖屏界面
@property (assign,nonatomic) BOOL isFullScreen;
@property (strong, nonatomic) UIView *fullScreenBgView;

//竖屏控件
@property (nonatomic,strong) UIView *canvasView;    //显示监控画面的载体
@property (assign,nonatomic) CGRect canvasframe;
@property (nonatomic,strong) UIButton *promptButton;
@property (nonatomic,strong) UILabel *labelTip;
//@property (strong, nonatomic) ProgressImageView *yProgressView;
@property (nonatomic,strong) UIView *midToolHView;   //全屏时，隐藏
@property (nonatomic,strong) UIView *bottomToolHView;   //全屏时，隐藏
@property (nonatomic,strong) UIButton *defenceButtonH;   //布防撤防按钮

//YES表示当前处于监控中，且接收到推送，点击观看监控
@property (assign,nonatomic) BOOL isIntoMonitorFromMonitor;


//@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *musicButton;
@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIView *buttonContainerView;

@end

@implementation P2PMonitorController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isPlaying = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (self.deviceContact) {
        self.isShowControllerBar = YES;
        self.isVideoModeHD = NO;
        
        [AppDelegate sharedDefault].monitoredContactId = self.deviceContact.contactId;
        
        [[P2PClient sharedClient] setIsBCalled:NO];
        [[P2PClient sharedClient] setCallId:self.deviceContact.contactId];
        [[P2PClient sharedClient] setP2pCallType:P2PCALL_TYPE_MONITOR];
        [[P2PClient sharedClient] setCallPassword:self.deviceContact.contactPassword];
        
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        
        //监控竖屏时，各控件初始化(先)
        [self initializeSubviews];
        
        
        //rtsp监控界面弹出修改
        [self monitorP2PCall];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self forceOrientationLandscape];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteMessage:) name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    //rtsp监控界面弹出修改
    /*
     * 1. 注册监控渲染监听通知
     * 2. 在函数monitorStartRender里，开始渲染监控画面
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(monitorStartRender:) name:MONITOR_START_RENDER_MESSAGE object:nil];
    
    NSString *contactId = [[P2PClient sharedClient] callId];
    NSString *contactPassword = [[P2PClient sharedClient] callPassword];
    if ([AppDelegate sharedDefault].isDoorBellAlarm) {//透传连接
        [[P2PClient sharedClient] sendCustomCmdWithId:contactId password:contactPassword cmd:@"IPC1anerfa:connect"];
    }
    
    //过滤当前被监控帐号的推送显示
    [AppDelegate sharedDefault].monitoredContactId = contactId;
    [AppDelegate sharedDefault].isMonitoring = YES;//当前是监控、视频通话或呼叫状态下
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     //释放约束
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForcePortrait=NO;
    appdelegate.isForceLandscape=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    self.isReject = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (self.isFullScreen){
        if (self.scrollView){
            [self.scrollView setZoomScale:1.0];
        }
    }
    [self.remoteView setCaptureFinishScreen:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    //rtsp监控界面弹出修改
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MONITOR_START_RENDER_MESSAGE object:nil];
    
    if ([AppDelegate sharedDefault].isDoorBellAlarm) {//透传连接
        NSString *contactId = [[P2PClient sharedClient] callId];
        NSString *contactPassword = [[P2PClient sharedClient] callPassword];
        [[P2PClient sharedClient] sendCustomCmdWithId:contactId password:contactPassword cmd:@"IPC1anerfa:disconnect"];
    }
    
    [AppDelegate sharedDefault].monitoredContactId = nil;
    if ([AppDelegate sharedDefault].isMonitoring) {
        [AppDelegate sharedDefault].isMonitoring = NO;//挂断，不处于监控状态
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initializeSubviews{
    //取得竖屏的rect
    CGRect rect = [AppDelegate getScreenSizeHorizontal:YES];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    self.canvasView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.canvasView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.canvasView];
    //    [canvasView release];
    //视频监控连接中的背景图片
    NSString *filePath = [Utils getHeaderFilePathWithId:[[P2PClient sharedClient] callId]];
    UIImage *headImg = [UIImage imageWithContentsOfFile:filePath];
    if(headImg==nil){
        headImg = [UIImage imageNamed:@"babySleep.png"];
    }
    self.canvasView.layer.contents = (id)headImg.CGImage;
    
    self.remoteView = [[OpenGLView alloc] init];
    self.remoteView.frame = CGRectMake(0, 0, CGRectGetWidth(self.canvasView.frame), CGRectGetHeight(self.canvasView.frame));
    self.remoteView.delegate = self;
    self.remoteView.layer.masksToBounds = YES;
    [self.canvasView addSubview:self.remoteView];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(20, 20, 50, 50);
    [cancelButton setImage:[UIImage imageWithName:@"baby_cancel.png"] forState:UIControlStateNormal];
    cancelButton.tag = BUTTON_CANCEL_TAG;
    [cancelButton addTarget:self action:@selector(horizontalButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.canvasView addSubview:cancelButton];
    
    CGFloat contanerViewHeight = BUTTON_PADDING * 3 + BUTTON_WIDTH * 4;
    UIView *buttonContainerView = [[UIView alloc] initWithFrame:CGRectMake(width - 80, (height - contanerViewHeight) / 2, BUTTON_WIDTH, contanerViewHeight)];
    [self.canvasView addSubview:buttonContainerView];
    
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraButton.frame = CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_WIDTH);
    self.cameraButton.tag = BUTTON_CAMERA_TAG;
    [self.cameraButton setImage:[UIImage imageWithName:@"baby_camera_normal.png"] forState:UIControlStateNormal];
    [self.cameraButton setImage:[UIImage imageWithName:@"baby_camera_selected.png"] forState:UIControlStateSelected];
    [self.cameraButton addTarget:self action:@selector(horizontalButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainerView addSubview:self.cameraButton];
    
    self.videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoButton.frame = CGRectMake(0, BUTTON_WIDTH + BUTTON_PADDING, BUTTON_WIDTH, BUTTON_WIDTH);
    self.videoButton.tag = BUTTON_VIDEO_TAG;
    [self.videoButton setImage:[UIImage imageWithName:@"baby_video_normal.png"] forState:UIControlStateNormal];
    [self.videoButton setImage:[UIImage imageWithName:@"baby_video_selected.png"] forState:UIControlStateSelected];
    [self.videoButton addTarget:self action:@selector(horizontalButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainerView addSubview:self.videoButton];
    
    self.musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.musicButton.frame = CGRectMake(0, 2 * (BUTTON_WIDTH + BUTTON_PADDING), BUTTON_WIDTH, BUTTON_WIDTH);
    self.musicButton.tag = BUTTON_MUSIC_TAG;
    [self.musicButton setImage:[UIImage imageWithName:@"baby_music_normal.png"] forState:UIControlStateNormal];
    [self.musicButton setImage:[UIImage imageWithName:@"baby_music_selected.png"] forState:UIControlStateSelected];
    [self.musicButton addTarget:self action:@selector(horizontalButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainerView addSubview:self.musicButton];
    
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceButton.frame = CGRectMake(0, 3 * (BUTTON_WIDTH + BUTTON_PADDING), BUTTON_WIDTH, BUTTON_WIDTH);
    self.voiceButton.tag = BUTTON_VOICE_TAG;
    [self.voiceButton setImage:[UIImage imageWithName:@"baby_voice_normal.png"] forState:UIControlStateNormal];
    [self.voiceButton setImage:[UIImage imageWithName:@"baby_voice_selected.png"] forState:UIControlStateSelected];
    [self.voiceButton addTarget:self action:@selector(horizontalButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonContainerView addSubview:self.voiceButton];
    
    self.cameraButton.userInteractionEnabled = NO;
    self.videoButton.userInteractionEnabled = NO;
    self.musicButton.userInteractionEnabled = NO;
    self.voiceButton.userInteractionEnabled = NO;
    
}

//rtsp监控界面弹出修改
-(void)monitorP2PCall{
    [[P2PClient sharedClient] setP2pCallState:P2PCALL_STATUS_CALLING];
    BOOL isBCalled = [[P2PClient sharedClient] isBCalled];
    P2PCallType type = [[P2PClient sharedClient] p2pCallType];
    NSString *callId = [[P2PClient sharedClient] callId];
    NSString *callPassword = [[P2PClient sharedClient] callPassword];
    
    if(!isBCalled){
        BOOL isApMode = ([[AppDelegate sharedDefault]dwApContactID] != 0);
        if (!isApMode)
        {
            [[P2PClient sharedClient] p2pCallWithId:callId password:callPassword callType:type];
        }
        else
        {
            [[P2PClient sharedClient] p2pCallWithId:@"1" password:callPassword callType:type];
        }
    }
}


//rtsp监控界面弹出修改
#pragma mark - 渲染监控界面
-(void)monitorStartRender:(NSNotification*)notification{
    //开始渲染
    self.isReject = NO;
    [NSThread detachNewThreadSelector:@selector(renderView) toTarget:self withObject:nil];
    [self doOperationsAfterMonitorStartRender];
    
}

- (void)renderView
{
    _isPlaying = YES;
    
    GAVFrame * m_pAVFrame ;
    while (!self.isReject)
    {
        if(fgGetVideoFrameToDisplay(&m_pAVFrame))
        {
            [self.remoteView render:m_pAVFrame];
            vReleaseVideoFrame();
        }
        usleep(10000);
    }
    
    
    _isPlaying = NO;
}


#define MESG_SET_GPIO_PERMISSION_DENIED 86
#define MESG_GPIO_CTRL_QUEUE_IS_FULL 87
#define MESG_SET_DEVICE_NOT_SUPPORT 255

#define GPIO0_0 10
#define GPIO0_1 11
#define GPIO0_2 12
#define GPIO0_3 13
#define GPIO0_4 14
#define GPIO2_6 15
- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    switch(key){
        case RET_GET_FOCUS_ZOOM:
        {
            int value = [[parameter valueForKey:@"value"] intValue];
           
            if (value == 3) {//变倍变焦都有
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isSupportFocalLength = YES;
                    [self.pinchGestureRecognizer addTarget:self action:@selector(localLengthPinchToZoom:)];
                });
            }else if (value == 2){//只有变焦
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isSupportFocalLength = YES;
                });
                
            }else if (value == 1){//只有变倍
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pinchGestureRecognizer addTarget:self action:@selector(localLengthPinchToZoom:)];
                });
            }
        }
            break;
        case RET_SET_GPIO_CTL:
        {
            int result = [[parameter valueForKey:@"result"] intValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.clickGPIO0_0Button.backgroundColor = [UIColor clearColor];
                self.clickGPIO0_1Button.backgroundColor = [UIColor clearColor];
                self.clickGPIO0_2Button.backgroundColor = [UIColor clearColor];
                self.clickGPIO0_3Button.backgroundColor = [UIColor clearColor];
                self.clickGPIO0_4Button.backgroundColor = [UIColor clearColor];
                self.clickGPIO2_6Button.backgroundColor = [UIColor clearColor];
            });
            if (result == 0) {
                //设置成功
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToast:NSLocalizedString(@"operator_success", nil)];
                });
            }else if (result == MESG_SET_GPIO_PERMISSION_DENIED){
                //该GPIO未开放
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.view makeToast:NSLocalizedString(@"not_open", nil)];
                });
            }else if (result == MESG_GPIO_CTRL_QUEUE_IS_FULL){
                //操作过于频繁，之前的操作未执行完
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.view makeToast:NSLocalizedString(@"too_frequent", nil)];
                });
            }else if(result == MESG_SET_DEVICE_NOT_SUPPORT){
                //设备不支持此操作
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.view makeToast:NSLocalizedString(@"not_support_operation", nil)];
                });
            }
        }
            break;
        case RET_GET_LIGHT_SWITCH_STATE:
        {
            int result = [[parameter valueForKey:@"result"] intValue];
            
            if (result == 0) {
                int state = [[parameter valueForKey:@"state"] intValue];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isSupportLightSwitch = YES;
                    if (state == 1) {//灯是开状态
                        self.isLightSwitchOn = YES;
                        [self.lightButton setBackgroundImage:[UIImage imageNamed:@"lighton.png"] forState:UIControlStateNormal];
                    }else{
                        self.isLightSwitchOn = NO;
                        [self.lightButton setBackgroundImage:[UIImage imageNamed:@"lightoff.png"] forState:UIControlStateNormal];
                    }
                });
            }
        }
            break;
        case RET_SET_LIGHT_SWITCH_STATE:
        {
            int result = [[parameter valueForKey:@"result"] intValue];
            
            if (result == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.lightButton setHidden:NO];
                    [self.progressView setHidden:YES];
                    [self.progressView stopAnimating];
                    if (self.isLightSwitchOn) {//灯正开着
                        self.isLightSwitchOn = NO;//关灯
                        [self.lightButton setBackgroundImage:[UIImage imageNamed:@"lightoff.png"] forState:UIControlStateNormal];
                    }else{//灯正关着
                        self.isLightSwitchOn = YES;//开灯
                        [self.lightButton setBackgroundImage:[UIImage imageNamed:@"lighton.png"] forState:UIControlStateNormal];
                    }
                });
            }
        }
            break;
        case RET_DEVICE_NOT_SUPPORT:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.clickGPIO0_0Button.backgroundColor = [UIColor clearColor];
                self.clickGPIO0_1Button.backgroundColor = [UIColor clearColor];
                self.clickGPIO0_2Button.backgroundColor = [UIColor clearColor];
                self.clickGPIO0_3Button.backgroundColor = [UIColor clearColor];
                self.clickGPIO0_4Button.backgroundColor = [UIColor clearColor];
                self.clickGPIO2_6Button.backgroundColor = [UIColor clearColor];
                
                //[self.view makeToast:NSLocalizedString(@"device_not_support", nil)];
            });
        }
            break;
        case RET_GET_NPCSETTINGS_REMOTE_DEFENCE:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger state = [[parameter valueForKey:@"state"] intValue];
                if(state==SETTING_VALUE_REMOTE_DEFENCE_STATE_ON)
                {
                    //竖屏
                    [self.defenceButtonH setImage:[UIImage imageNamed:@"monitor_defence_on_h.png"] forState:UIControlStateNormal];
                    [self.defenceButtonH setImage:[UIImage imageNamed:@"monitor_defence_on_h_p.png"] forState:UIControlStateHighlighted];
                    //获取到布防状态，设置为可点且显示相应的图标
                    self.defenceButtonH.enabled = YES;
                    
                    
                    self.isDefenceOn = YES;
                    
                }
                else
                {
                    //竖屏
                    [self.defenceButtonH setImage:[UIImage imageNamed:@"monitor_defence_off_h.png"] forState:UIControlStateNormal];
                    [self.defenceButtonH setImage:[UIImage imageNamed:@"monitor_defence_off_h_p.png"] forState:UIControlStateHighlighted];
                    //获取到布防状态，设置为可点且显示相应的图标
                    self.defenceButtonH.enabled = YES;
                    
                    
                    self.isDefenceOn = NO;
                    
                }

            });
        }
            break;
            
        case RET_SET_NPCSETTINGS_REMOTE_DEFENCE:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger state = [[parameter valueForKey:@"state"] intValue];
                if(state==SETTING_VALUE_REMOTE_DEFENCE_STATE_ON){
                    //竖屏
                    [self.defenceButtonH setImage:[UIImage imageNamed:@"monitor_defence_on_h.png"] forState:UIControlStateNormal];
                    [self.defenceButtonH setImage:[UIImage imageNamed:@"monitor_defence_on_h_p.png"] forState:UIControlStateHighlighted];
                    
                    
                    self.isDefenceOn = YES;
                    
                }else{
                    //竖屏
                    [self.defenceButtonH setImage:[UIImage imageNamed:@"monitor_defence_off_h.png"] forState:UIControlStateNormal];
                    [self.defenceButtonH setImage:[UIImage imageNamed:@"monitor_defence_off_h_p.png"] forState:UIControlStateHighlighted];
                    
                    
                    self.isDefenceOn = NO;
                    
                }
            });
        }
            break;
    }
}

- (void)ack_receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    int result   = [[parameter valueForKey:@"result"] intValue];
    switch(key){
        case ACK_RET_SET_GPIO_CTL:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    
                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                }else if(result==2){
                    DLog(@"resend do device update");
                    NSString *contactId = [[P2PClient sharedClient] callId];
                    NSString *contactPassword = [[P2PClient sharedClient] callPassword];
                    
                    [[P2PClient sharedClient] setGpioCtrlWithId:contactId password:contactPassword group:self.lastGroup pin:self.lastPin value:self.lastValue time:self.lastTime];
                }
            });
        }
            break;
        case ACK_RET_GET_LIGHT_STATE:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    
                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                }else if(result==2){
                    DLog(@"resend do device update");
                    NSString *contactId = [[P2PClient sharedClient] callId];
                    NSString *contactPassword = [[P2PClient sharedClient] callPassword];
                    
                    [[P2PClient sharedClient] getLightStateWithDeviceId:contactId password:contactPassword];
                }
            });
        }
            break;
        case ACK_RET_SET_LIGHT_STATE:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    
                    [self.view makeToast:NSLocalizedString(@"device_password_error", nil)];
                }else if(result==2){
                    DLog(@"resend do device update");
                    NSString *contactId = [[P2PClient sharedClient] callId];
                    NSString *contactPassword = [[P2PClient sharedClient] callPassword];
                    
                    if (self.isLightSwitchOn) {//灯正开着
                        [[P2PClient sharedClient] setLightStateWithDeviceId:contactId password:contactPassword switchState:0];//关灯
                    }else{
                        [[P2PClient sharedClient] setLightStateWithDeviceId:contactId password:contactPassword switchState:1];//开灯
                    }
                }
            });
        }
            break;
        case ACK_RET_GET_DEFENCE_STATE:
        {
            if(result==2){
                //超时
                NSString *callId = [[P2PClient sharedClient] callId];
                NSString *callPassword = [[P2PClient sharedClient] callPassword];
                [[P2PClient sharedClient]getDefenceState:callId password:callPassword];
            }
        }
            break;
            
        case ACK_RET_SET_NPCSETTINGS_REMOTE_DEFENCE:
        {
            if (result == 2)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToast:NSLocalizedString(@"net_exception", nil)];
                });
            }
        }
            break;
    }
    
}


-(NSString *)getCallErrorStringWith:(int)errorFlag{
    switch(errorFlag)
    {
        case CALL_ERROR_NONE:
        {
            return NSLocalizedString(@"id_unknown_error", nil);
            
        }
            break;
        case CALL_ERROR_DESID_NOT_ENABLE:
        {
            return NSLocalizedString(@"id_disabled", nil);
        }
            break;
        case CALL_ERROR_DESID_OVERDATE:
        {
            return NSLocalizedString(@"id_overdate", nil);
        }
            break;
        case CALL_ERROR_DESID_NOT_ACTIVE:
        {
            return NSLocalizedString(@"id_inactived", nil);
        }
            break;
        case CALL_ERROR_DESID_OFFLINE:
        {
            return NSLocalizedString(@"id_offline", nil);
        }
            break;
        case CALL_ERROR_DESID_BUSY:
        {
            return NSLocalizedString(@"id_busy", nil);
        }
            break;
        case CALL_ERROR_DESID_POWERDOWN:
        {
            return NSLocalizedString(@"id_powerdown", nil);
        }
            break;
        case CALL_ERROR_NO_HELPER:
        {
            return NSLocalizedString(@"id_connect_failed", nil);
        }
            break;
        case CALL_ERROR_HANGUP:
        {
            return NSLocalizedString(@"id_hangup", nil);
            
            break;
        }
        case CALL_ERROR_TIMEOUT:
        {
            return NSLocalizedString(@"id_timeout", nil);
        }
            break;
        case CALL_ERROR_INTER_ERROR:
        {
            return NSLocalizedString(@"id_internal_error", nil);
        }
            break;
        case CALL_ERROR_RING_TIMEOUT:
        {
            return NSLocalizedString(@"id_no_accept", nil);
        }
            break;
        case CALL_ERROR_PW_WRONG:
        {
            return NSLocalizedString(@"id_password_error", nil);
        }
            break;
        case CALL_ERROR_CONN_FAIL:
        {
            return NSLocalizedString(@"id_connect_failed", nil);
        }
            break;
        case CALL_ERROR_NOT_SUPPORT:
        {
            return NSLocalizedString(@"id_not_support", nil);
        }
            break;
        default:
        {
            return NSLocalizedString(@"id_unknown_error", nil);
        }
            break;
    }
}







#pragma mark 按下按钮时，响应

- (void)horizontalButtonClick:(UIButton *)btn{
    
    switch (btn.tag) {
        case BUTTON_CAMERA_TAG:
        {
            btn.selected = !btn.selected;
        }
            break;
        case BUTTON_VIDEO_TAG:
        {
            btn.selected = !btn.selected;
        }
            break;
        case BUTTON_MUSIC_TAG:
        {
            btn.selected = !btn.selected;
        }
            break;
        case BUTTON_VOICE_TAG:
        {
            btn.selected = !btn.selected;
        }
            break;
        case BUTTON_CANCEL_TAG:
        {
            if(!self.isReject){
                self.isReject = !self.isReject;
                while (_isPlaying) {
                    usleep(50*1000);
                }
                
                [[P2PClient sharedClient] p2pHungUp];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}



#pragma mark - 改变焦距
-(void)btnClickToChangeFocalLength:(id)sender{
    UIView *view = (UIView *)sender;
    if (view.tag == FocalLength_Elongation_btnTag) {
        //焦距变长
        BYTE cmdData[5] = {0};
        cmdData[0] = 0x05;
        fgSendUserData(9, 1, cmdData, sizeof(cmdData));
    }else if (view.tag == FocalLength_Shorten_btnTag){
        //焦距变短
        BYTE cmdData[5] = {0};
        cmdData[0] = 0x15;
        fgSendUserData(9, 1, cmdData, sizeof(cmdData));
    }else{
        UISlider *focalLengthSlider = (UISlider *)view;
        if (focalLengthSlider.value < 7.5) {
            //焦距变长
            BYTE cmdData[5] = {0};
            cmdData[0] = 0x05;
            fgSendUserData(9, 1, cmdData, sizeof(cmdData));
        }else{
            //焦距变短
            BYTE cmdData[5] = {0};
            cmdData[0] = 0x15;
            fgSendUserData(9, 1, cmdData, sizeof(cmdData));
        }
        focalLengthSlider.value = 7.5;
    }
}

#pragma mark - 焦距变倍
-(void)localLengthPinchToZoom:(id)sender {
    if (!self.isFullScreen) {
        return;
    }
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        if ([(UIPinchGestureRecognizer*)sender scale] > 1.0) {
            BYTE cmdData[5] = {0};
            cmdData[0] = 0x05;
            fgSendUserData(9, 2, cmdData, sizeof(cmdData));
        }else{
            BYTE cmdData[5] = {0};
            cmdData[0] = 0x15;
            fgSendUserData(9, 2, cmdData, sizeof(cmdData));
        }
    }
}

#pragma mark - 监控开始渲染后，此处执行相关操作
-(void)doOperationsAfterMonitorStartRender{//rtsp监控界面弹出修改
    
    /*
     *1. 应该放在监控准备就绪之后（即渲染之后）
     */
    [[PAIOUnit sharedUnit] setMuteAudio:NO];
    [[PAIOUnit sharedUnit] setSpeckState:YES];
    
    
    //放在渲染之后
    if([AppDelegate sharedDefault].isDoorBellAlarm){//门铃推送,点按开关说话
        self.isTalking = YES;
        [self.pressView setHidden:NO];
        [[PAIOUnit sharedUnit] setSpeckState:NO];
    }else{
        self.isTalking = NO;
        [self.pressView setHidden:YES];
        [[PAIOUnit sharedUnit] setSpeckState:YES];
    }
    //竖屏对讲按钮
    UIButton *talkButtonH = (UIButton *)[self.bottomToolHView viewWithTag:TALK_BUTTON_H_TAG];
    if([AppDelegate sharedDefault].isDoorBellAlarm){//门铃推送
        talkButtonH.selected = YES;
    }else{
        talkButtonH.selected = NO;
    }
    //横屏对讲按钮
//    TouchButton *controllerTalkBtn = (TouchButton *)[self.controllBar viewWithTag:CONTROLLER_BTN_TAG_PRESS_TALK];
    //非本地设备
    NSInteger deviceType1 = [AppDelegate sharedDefault].contact.contactType;
    //本地设备
    NSInteger deviceType2 = [[FListManager sharedFList] getType:[[P2PClient sharedClient] callId]];
    
    
    NSString *callId = [[P2PClient sharedClient] callId];
    NSString *callPassword = [[P2PClient sharedClient] callPassword];
    [[P2PClient sharedClient]getDefenceState:callId password:callPassword];
    
    
    //判断设备是否支持变倍变焦(38)
    [[P2PClient sharedClient] getNpcSettingsWithId:callId password:callPassword];
}



#pragma mark - 屏幕Autorotate

- (void)forceOrientationLandscape
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=YES;
    appdelegate.isForcePortrait=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)forceOrientationPortrait
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForcePortrait=YES;
    appdelegate.isForceLandscape=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)releaseOrientation{
    
}




@end
