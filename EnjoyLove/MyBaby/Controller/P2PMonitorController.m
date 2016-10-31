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
    BOOL _isOkFirstRenderVideoFrame;//YES表示第一次成功渲染图像
    BOOL _isOkRenderVideoFrame;
    BOOL _isPlaying;
}

@property (nonatomic, strong) OpenGLView *remoteView;
@property (nonatomic) BOOL isReject;
@property (nonatomic, assign) BOOL isCancelClick;

@property (nonatomic, assign) BOOL isTalking;

@property (nonatomic) BOOL isDefenceOn;//重新调整监控画面

@property(nonatomic) BOOL isShowLeftView;

@property(nonatomic) int lastGroup;
@property(nonatomic) int lastPin;
@property(nonatomic) int lastValue;
@property(nonatomic) int *lastTime;


//竖屏控件
@property (nonatomic,strong) UIView *canvasView;    //显示监控画面的载体
//YES表示当前处于监控中，且接收到推送，点击观看监控
@property (assign,nonatomic) BOOL isIntoMonitorFromMonitor;


//@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *musicButton;
@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIView *buttonContainerView;
//YES表示图像渲染出来了
@property (nonatomic, assign) BOOL isOkRenderVideoFrame;


@end

@implementation P2PMonitorController

- (void)dealloc{
    self.cameraButton = nil;
    self.videoButton = nil;
    self.musicButton = nil;
    self.voiceButton = nil;
    self.buttonContainerView = nil;
    self.remoteView = nil;
}

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
        self.isReject = NO;
        
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rejectNotification:) name:[[BabyZoneConfig shared] videoRejectNotification]object:nil];
    
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
    [self.remoteView setCaptureFinishScreen:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    //rtsp监控界面弹出修改
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MONITOR_START_RENDER_MESSAGE object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[[BabyZoneConfig shared] videoRejectNotification] object:nil];
    
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
    cancelButton.userInteractionEnabled = NO;
    [self.canvasView addSubview:cancelButton];
    
    CGFloat contanerViewHeight = BUTTON_PADDING * 3 + BUTTON_WIDTH * 4;
    UIView *buttonContainerView = [[UIView alloc] initWithFrame:CGRectMake(width - 80, (height - contanerViewHeight) / 2, BUTTON_WIDTH, contanerViewHeight)];
    [self.canvasView addSubview:buttonContainerView];
    
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraButton.frame = CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_WIDTH);
    self.cameraButton.tag = BUTTON_CAMERA_TAG;
    [self.cameraButton setImage:[UIImage imageWithName:@"baby_camera_normal.png"] forState:UIControlStateNormal];
    [self.cameraButton setImage:[UIImage imageWithName:@"baby_camera_selected.png"] forState:UIControlStateHighlighted];
    [self.cameraButton addTarget:self action:@selector(horizontalButtonClick:) forControlEvents:UIControlEventTouchDown];
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
    
    [self swipeGestures];
}

- (void)swipeGestures{
    //上划手势
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    [swipeGestureUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeGestureUp setCancelsTouchesInView:YES];
    [swipeGestureUp setDelaysTouchesEnded:YES];
    [_remoteView addGestureRecognizer:swipeGestureUp];
    
    //下划手势
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    [swipeGestureDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [swipeGestureDown setCancelsTouchesInView:YES];
    [swipeGestureDown setDelaysTouchesEnded:YES];
    [_remoteView addGestureRecognizer:swipeGestureDown];
    
    //左划手势
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeGestureLeft setCancelsTouchesInView:YES];
    [swipeGestureLeft setDelaysTouchesEnded:YES];
    [_remoteView addGestureRecognizer:swipeGestureLeft];
    
    //右划手势
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeGestureRight setCancelsTouchesInView:YES];
    [swipeGestureRight setDelaysTouchesEnded:YES];
    [_remoteView addGestureRecognizer:swipeGestureRight];

}

- (void)swipeUp:(id)sender {
    [[P2PClient sharedClient] sendCommandType:USR_CMD_PTZ_CTL
                                    andOption:USR_CMD_OPTION_PTZ_TURN_DOWN];
}

- (void)swipeDown:(id)sender {
    [[P2PClient sharedClient] sendCommandType:USR_CMD_PTZ_CTL
                                    andOption:USR_CMD_OPTION_PTZ_TURN_UP];
}

- (void)swipeLeft:(id)sender {
    [[P2PClient sharedClient] sendCommandType:USR_CMD_PTZ_CTL
                                    andOption:USR_CMD_OPTION_PTZ_TURN_LEFT];
}

- (void)swipeRight:(id)sender {
    [[P2PClient sharedClient] sendCommandType:USR_CMD_PTZ_CTL
                                    andOption:USR_CMD_OPTION_PTZ_TURN_RIGHT];
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
            if (!self.isOkRenderVideoFrame) {
                self.isOkRenderVideoFrame = YES;
                _isOkFirstRenderVideoFrame = YES;
            }
            [self.remoteView render:m_pAVFrame];
            vReleaseVideoFrame();
        }
        usleep(10000);
    }
    
    
    _isPlaying = NO;
}

- (void)rejectNotification:(NSNotification *)note{
    if(!self.isReject){
        self.isReject = !self.isReject;
        while (_isPlaying) {
            usleep(50*1000);
        }
    }
    _isOkRenderVideoFrame = NO;
    if (!self.isCancelClick) {
        [self monitorP2PCall];
    }
}

-(void)onScreenShotted:(UIImage *)image{
    UIImage *tempImage = [[UIImage alloc] initWithCGImage:image.CGImage];
    NSData *imgData = [NSData dataWithData:UIImagePNGRepresentation(tempImage)];
    [Utils saveScreenshotFile:imgData];
    if (self.isCancelClick == false) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideHud:self.view];
            [HUD showText:@"截图成功" onView:self.view];
        });
    }
}

- (void)setIsOkRenderVideoFrame:(BOOL)aisOkRenderVideoFrame{
    _isOkRenderVideoFrame = aisOkRenderVideoFrame;
    if (aisOkRenderVideoFrame) {
        UIButton *cancelButton = [self.canvasView viewWithTag:BUTTON_CANCEL_TAG];
        cancelButton.userInteractionEnabled = YES;
        self.videoButton.userInteractionEnabled = YES;
        self.cameraButton.userInteractionEnabled = YES;
        self.musicButton.userInteractionEnabled = YES;
        self.voiceButton.userInteractionEnabled = YES;
    }else{
        UIButton *cancelButton = [self.canvasView viewWithTag:BUTTON_CANCEL_TAG];
        cancelButton.userInteractionEnabled = YES;
        self.videoButton.userInteractionEnabled = NO;
        self.cameraButton.userInteractionEnabled = NO;
        self.musicButton.userInteractionEnabled = NO;
        self.voiceButton.userInteractionEnabled = NO;
    }
}


- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    switch(key){
        case RET_GET_FOCUS_ZOOM:
        {
        }
            break;
        case RET_SET_GPIO_CTL:
        {
        }
            break;
        case RET_GET_LIGHT_SWITCH_STATE:
        {
        }
            break;
        case RET_SET_LIGHT_SWITCH_STATE:
        {
        }
            break;
        case RET_DEVICE_NOT_SUPPORT:
        {
        }
            break;
        case RET_GET_NPCSETTINGS_REMOTE_DEFENCE:
        {
            NSInteger state = [[parameter valueForKey:@"state"] intValue];
            if(state==SETTING_VALUE_REMOTE_DEFENCE_STATE_ON)
            {
                
                self.isDefenceOn = YES;
                
            }
            else
            {
                
                
                self.isDefenceOn = NO;
                
            }
        }
            break;
            
        case RET_SET_NPCSETTINGS_REMOTE_DEFENCE:
        {
            NSInteger state = [[parameter valueForKey:@"state"] intValue];
            if(state==SETTING_VALUE_REMOTE_DEFENCE_STATE_ON)
            {
                self.isDefenceOn = YES;
            }
            else
            {
                self.isDefenceOn = NO;
            }
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
                    
                }else if(result==2){
                    DLog(@"resend do device update");
//                    NSString *contactId = [[P2PClient sharedClient] callId];
//                    NSString *contactPassword = [[P2PClient sharedClient] callPassword];
                    
//                    if (self.isLightSwitchOn) {//灯正开着
//                        [[P2PClient sharedClient] setLightStateWithDeviceId:contactId password:contactPassword switchState:0];//关灯
//                    }else{
//                        [[P2PClient sharedClient] setLightStateWithDeviceId:contactId password:contactPassword switchState:1];//开灯
//                    }
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
            }
        }
            break;
    }
    
}



#pragma mark 按下按钮时，响应

- (void)horizontalButtonClick:(UIButton *)btn{
    
    switch (btn.tag) {
        case BUTTON_CAMERA_TAG:
        {
            [HUD showHud:@"正在截图" onView:self.view];
            [self.remoteView setIsScreenShotting:YES];
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
            if (btn.selected) {
                [[PAIOUnit sharedUnit] setSpeckState:YES];
            }else{
                [[PAIOUnit sharedUnit] setSpeckState:NO];
            }
            btn.selected = !btn.selected;
        }
            break;
        case BUTTON_CANCEL_TAG:
        {
            self.isCancelClick = YES;
            if(!self.isReject){
                self.isReject = !self.isReject;
                while (_isPlaying) {
                    usleep(50*1000);
                }
                [[PAIOUnit sharedUnit] setSpeckState:NO];
                [[P2PClient sharedClient] p2pHungUp];
                self.remoteView.isQuitMonitorInterface = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.monitorRefreshHandler && self.isCancelClick && self.remoteView) {
                        self.monitorRefreshHandler([self.remoteView glToUIImage]);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
            break;
        default:
            break;
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
        [[PAIOUnit sharedUnit] setSpeckState:NO];
    }else{
        self.isTalking = NO;
        [[PAIOUnit sharedUnit] setSpeckState:YES];
    }
    //非本地设备
//    NSInteger deviceType1 = [AppDelegate sharedDefault].contact.contactType;
//    //本地设备
//    NSInteger deviceType2 = [[FListManager sharedFList] getType:[[P2PClient sharedClient] callId]];
    
    
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

- (BOOL)shouldAutorotate{
    return YES;
}



@end
