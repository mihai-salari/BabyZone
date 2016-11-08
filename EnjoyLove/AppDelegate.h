//
//  AppDelegate.h
//  EnjoyLove
//
//  Created by HuangSam on 16/8/24.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"
#import "Reachability.h"
#import "Contact.h"//重新调整监控画面
#define NET_WORK_CHANGE @"NET_WORK_CHANGE"
#define ALERT_TAG_ALARMING 0
#define ALERT_TAG_MONITOR 1
#define ALERT_TAG_APP_UPDATE 2

#define ap_address      "192.168.1.1"
#define ap_p2p_id       @"1"
#define ap_p2p_password @"0"

@protocol GApplicationDelegate <NSObject>
@optional
-(void)gApplicationWithId:(NSString *)contactId password:(NSString *)password callType:(P2PCallType)type;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong, readonly) UITabBarController *rootTabBarController;

@property (nonatomic, assign, readonly) BOOL isUserLogin;

@property (nonatomic, assign) BOOL firstLaunch;

#pragma mark - 监控视频
@property (strong, nonatomic) Contact *contact;//重新调整监控画面
@property (nonatomic) NetworkStatus networkStatus;
+(AppDelegate*)sharedDefault;
+(CGRect)getScreenSizeHorizontal:(BOOL)isHorizontal;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *alarmContactId;
@property (strong, nonatomic) NSString *monitoredContactId;
//currentPushedContactId当前推送的ID，作用是，和下一个推送ID比较，若相等则不弹出推送框
@property (strong, nonatomic) NSString *currentPushedContactId;
//YES表示接收到推送，正在输入密码准备进行监控，此时不弹出任何推送
@property (nonatomic) BOOL isInputtingPwdToMonitor;
@property (nonatomic) long lastShowAlarmTimeInterval;
@property (nonatomic) BOOL isDoorBellAlarm;//在监控界面使用,区分门铃推送，其他推送
//YES表示正显示门铃推送界面，不弹出任何推送
@property (nonatomic) BOOL isShowingDoorBellAlarm;
//YES表示正处于视频通话中，不接收推送
@property (nonatomic) BOOL isBeingInP2PVideo;
@property (nonatomic) BOOL isMonitoring;//而且前提应该是只有监控、视频通话或呼叫状态下

@property (nonatomic) BOOL isGoBack;
@property (nonatomic) BOOL isNotificationBeClicked;//YES表示点击系统消息推送通知，将显示系统消息表

@property (strong, nonatomic) AVAudioPlayer * alarmRingPlayer;

@property (nonatomic) int  dwApContactID;
@property (strong, nonatomic) NSString *sWifi;

@property (nonatomic, assign) id<GApplicationDelegate> gApplicationDelegate;

/*
 appdelegate.isForcePortrait=YES;
 //    appdelegate.isForceLandscape=NO;
 */
@property (nonatomic, assign) BOOL isForcePortrait;
@property (nonatomic, assign) BOOL isForceLandscape;

//停止播放报警铃声
-(void)stopToPlayAlarmRing;

//当iOS系统>=9.3时，在APP将要退回登录界面时，注册远程推送，获取新的token
//原因是，iOS系统>=9.3时，注销远程推送再注册远程推送时，token变了;
-(void)reRegisterForRemoteNotifications;

@end

