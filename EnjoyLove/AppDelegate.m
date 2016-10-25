//
//  AppDelegate.m
//  EnjoyLove
//
//  Created by HuangSam on 16/8/24.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

#import "AppDelegate.h"
#import "EnjoyLove-Swift.h"
#import "GeTuiSdk.h"

//MARK:___监控___
#import "UDManager.h"
#import "Constants.h"
#import "LoginResult.h"
#import "UDManager.h"
#import "NetManager.h"
#import "AccountResult.h"
#import "Reachability.h"
#import "Message.h"
#import "Utils.h"
#import "MessageDAO.h"
#import "FListManager.h"
#import "CheckNewMessageResult.h"
#import "GetContactMessageResult.h"
#import "CheckAlarmMessageResult.h"
#import "ContactDAO.h"
#import "GlobalThread.h"
#import "Contact.h"
#import "Toast+UIView.h"
#import "UncaughtExceptionHandler.h"
#import "Alarm.h"
#import "AlarmDAO.h"
#import "MPNotificationView.h"
#import "UDPManager.h"
#import "PAIOUnit.h"//rtsp监控界面弹出修改
#import "MD5Manager.h"
#import "P2PMonitorController.h"

//MARK:___个推___
#define kGtAppId           @"iMahVVxurw6BNr7XSn9EF2"
#define kGtAppKey          @"yIPfqwq6OMAPp6dkqgLpG5"
#define kGtAppSecret       @"G0aBqAD6t79JfzTB6Z5lo5"

@interface AppDelegate ()<GeTuiSdkDelegate>

@end

@implementation AppDelegate
@synthesize rootTabBarController = _rootTabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /**
     *  基本设置
     */
    [self preLogin];
    [self baseSetting];
    
    //MARK:高德地图
    [[GaoDe sharedInstance] uploadKey];
    
    //MARK:个推
    // 通过 appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册APNS
    [self registerUserNotification];
    
    return [self monitorSetting];
}

- (void)baseSetting{
        
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    _rootTabBarController = tabBarController;
    tabBarController.tabBar.backgroundImage = [UIImage imageFromColor:[UIColor clearColor] size:CGSizeMake([UIScreen mainScreen].bounds.size.height, 44)];
    tabBarController.tabBar.shadowImage = [UIImage imageFromColor:[UIColor clearColor] size:CGSizeMake([UIScreen mainScreen].bounds.size.height, 1)];
    
    
    UITabBarItem *item0 = tabBarController.tabBar.items[0];
    UITabBarItem *item1 = tabBarController.tabBar.items[1];
    UITabBarItem *item2 = tabBarController.tabBar.items[2];
    item0.selectedImage = [[UIImage imageNamed:@"tabbar_baby"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.image = [UIImage imageNamed:@"tabbar_baby"];
    
    item1.selectedImage = [[UIImage imageNamed:@"ipcamera_off"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [UIImage imageNamed:@"ipcamera_off"];
    
    item2.selectedImage = [[UIImage imageNamed:@"user_off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [UIImage imageNamed:@"user_off"];
    
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         @{NSForegroundColorAttributeName:[UIColor colorFromRGB:255 g:255 b:255]} forState:UIControlStateSelected];
    
}

- (void)preLogin{
    [[NSUserDefaults standardUserDefaults] setObject:SIGN forKey:SIGNKEY];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ALLORIENTATIONSKEY];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:APPTOKENKEY] == nil) {
        [AppToken sendAsyncAppToken:@"appstore" completionHandler:^(AppToken * _Null_unspecified token) {
            if (token) {
                if (token.appToken && ![token.appToken isEqualToString:@""]) {
                    [[NSUserDefaults standardUserDefaults] setObject:token.appToken forKey:APPTOKENKEY];
                }
            }
        }];
    }
}

#pragma mark - SETTER AND GETTER

//- (UITabBarController *)rootTabBarController{
//    return (UITabBarController *)self.window.rootViewController;
//}

#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用

/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:HMTOKENKEY];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0; // 标签
    
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // 处理APN
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}


UIBackgroundTaskIdentifier backgroundTask;

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if (self.isMonitoring) {
        if ([[P2PClient sharedClient] p2pCallState] == P2PCALL_STATUS_READY_P2P) {
            [[P2PClient sharedClient] setP2pCallState:P2PCALL_STATUS_NONE];
            [[PAIOUnit sharedUnit] stopAudio];
        }
        [[P2PClient sharedClient] p2pHungUp];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    UIApplication *app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier taskID;
    taskID = [app beginBackgroundTaskWithExpirationHandler:^{
        [[P2PClient sharedClient] p2pDisconnect];
        [app endBackgroundTask:taskID];
    }];
    
    if (taskID == UIBackgroundTaskInvalid) {
        [[P2PClient sharedClient] p2pDisconnect];
        NSLog(@"Failed to start background task!");
        return;
    }
    
    self.isGoBack = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (self.isGoBack) {
            DLog(@"run background");
            sleep(1.0);
            
        }
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    self.isGoBack = NO;
    
    BOOL isModeChanged = NO;
    int ap3cid = [[ShakeManager sharedDefault] ApModeGetID];
    if (self.dwApContactID != ap3cid) {
        if (ap3cid == 0 || self.dwApContactID == 0) {
            isModeChanged = YES;
        }
        self.dwApContactID = ap3cid;
        self.sWifi = [Utils currentWifiSSID];
    }
    if (isModeChanged)
    {
        [[P2PClient sharedClient]p2pDisconnect];
        if (self.dwApContactID != 0)
        {
            //联网模式->单机模式
            if (NO)
            {
//                MainController *mainController_ap = [[MainController alloc] init];
//                self.mainController_ap = mainController_ap;
            }
            else
            {
                BOOL result = [[P2PClient sharedClient] p2pConnectWithId:@"0517401" codeStr1:@"0" codeStr2:@"0"];
                NSLog(@"p2pConnectWithId %d", result);
                [[NSNotificationCenter defaultCenter] postNotificationName:AP_ENTER_FORCEGROUND_MESSAGE
                                                                    object:self
                                                                  userInfo:nil];
            }
//            [[P2PClient sharedClient]setDelegate:self.mainController_ap];
//            self.window.rootViewController = self.mainController_ap;
        }
        else
        {
            //单机模式->联网模式
            if([UDManager isLogin])
            {
                LoginResult *loginResult = [UDManager getLoginInfo];
                if (NO)
                {
//                    MainController *mainController = [[MainController alloc] init];
//                    self.mainController = mainController;
                }
                else
                {
                    __unused BOOL result = [[P2PClient sharedClient] p2pConnectWithId:loginResult.contactId codeStr1:loginResult.rCode1 codeStr2:loginResult.rCode2];
                }
//                [[P2PClient sharedClient]setDelegate:self.mainController];
//                self.window.rootViewController = self.mainController;
                [[NetManager sharedManager] getAccountInfo:loginResult.contactId sessionId:loginResult.sessionId callBack:^(id JSON){
                    AccountResult *accountResult = (AccountResult*)JSON;
                    loginResult.email = accountResult.email;
                    loginResult.phone = accountResult.phone;
                    loginResult.countryCode = accountResult.countryCode;
                    [UDManager setLoginInfo:loginResult];
                }];
            }
            else
            {
//                LoginController *loginController = [[LoginController alloc] init];
//                AutoNavigation *mainController = [[AutoNavigation alloc] initWithRootViewController:loginController];
//                self.window.rootViewController = mainController;
//                [loginController release];
//                [mainController release];
            }
        }
    }
    else
    {
        if ([[AppDelegate sharedDefault]dwApContactID])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:AP_ENTER_FORCEGROUND_MESSAGE
                                                                object:self
                                                              userInfo:nil];
        }
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if ([NSStringFromClass([[self topViewController] class]) isEqualToString: NSStringFromClass([P2PMonitorController class])]) {
        return UIInterfaceOrientationMaskLandscapeLeft | UIUserInterfaceLayoutDirectionLeftToRight;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

//获取界面最上层的控制器
- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
//一层一层的进行查找判断
- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nav = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:nav.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


//MARK:__个推注册__

#pragma mark - 用户通知(推送) _自定义方法

/** 注册用户通知 */
- (void)registerUserNotification {
    
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    
    // 判读系统版本是否是“iOS 8.0”以上
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
    }
}


#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}


/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    
    // [4]: 收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    NSLog(@"\n>>>[GexinSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    NSLog(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}


//MARK:____监控____

- (BOOL)monitorSetting{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteMessage:) name:RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSessionIdError:) name:NOTIFICATION_ON_SESSION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveAlarmMessage:) name:RECEIVE_ALARM_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveDoorbellAlarmMessage:) name:RECEIVE_DOORBELL_ALARM_MESSAGE object:nil];
    self.networkStatus = ReachableViaWWAN;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    NSString *remoteHostName = @"www.baidu.com";
    [[Reachability reachabilityWithHostName:remoteHostName] startNotifier];
    int ap3cid = [[ShakeManager sharedDefault] ApModeGetID];
    if (ap3cid != 0)
    {
        self.dwApContactID = ap3cid;
        self.sWifi = [Utils currentWifiSSID];
        [[UDPManager sharedDefault] ScanLanDevice];
        return YES;
    }
    else
    {
        self.dwApContactID = 0;
        self.sWifi = nil;
    }
    
    [[UDPManager sharedDefault] ScanLanDevice];
    return YES;
}


+ (AppDelegate*)sharedDefault
{
    
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

+(CGRect)getScreenSizeHorizontal:(BOOL)isHorizontal{
    CGRect rect = [UIScreen mainScreen].bounds;
    if(isHorizontal){
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.height, rect.size.width);
    }
    return rect;
}


- (void)receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    switch(key){
        case RET_RECEIVE_MESSAGE:
        {
            NSString *contactId = [parameter valueForKey:@"contactId"];
            NSString *messageStr = [parameter valueForKey:@"message"];
            LoginResult *loginResult = [UDManager getLoginInfo];
            MessageDAO *messageDAO = [[MessageDAO alloc] init];
            Message *message = [[Message alloc] init];
            
            message.fromId = contactId;
            message.toId = loginResult.contactId;
            message.message = [NSString stringWithFormat:@"%@",messageStr];
            message.state = MESSAGE_STATE_NO_READ;
            message.time = [NSString stringWithFormat:@"%ld",[Utils getCurrentTimeInterval]];
            message.flag = -1;
            [messageDAO insert:message];
            int lastCount = [[FListManager sharedFList] getMessageCount:contactId];
            [[FListManager sharedFList] setMessageCountWithId:contactId count:lastCount+1];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                    object:self
                                                                  userInfo:nil];
            });
            
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.soundName = @"message.mp3";
            notification.alertBody = [NSString stringWithFormat:@"%@:%@",contactId,messageStr];
            notification.applicationIconBadgeNumber = 1;
            notification.alertAction = NSLocalizedString(@"open", nil);
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
            break;
        case RET_GET_NPCSETTINGS_REMOTE_DEFENCE:
        {
            NSInteger state = [[parameter valueForKey:@"state"] intValue];
            NSString *contactId = [parameter valueForKey:@"contactId"];
            if(state==SETTING_VALUE_REMOTE_DEFENCE_STATE_ON){
                [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_ON];
            }else{
                [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_OFF];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                    object:self
                                                                  userInfo:nil];
            });
            DLog(@"RET_GET_NPCSETTINGS_REMOTE_DEFENCE");
            
        }
            break;
            
    }
    
}

- (void)ack_receiveRemoteMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    int key   = [[parameter valueForKey:@"key"] intValue];
    int result   = [[parameter valueForKey:@"result"] intValue];
    NSString *contactId = [parameter valueForKey:@"contactId"];
    switch(key){
        case ACK_RET_SET_STOP_DOORBELL_PUSH:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==2){
                    [[P2PClient sharedClient] stopDoorbellPushWithId:self.alarmContactId];
                }
            });
        }
            break;
        case ACK_RET_SET_DELETE_ALARM_PUSHID:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==2){
                    [[P2PClient sharedClient] deleteAlarmPushIDWithId:self.alarmContactId];
                }
            });
        }
            break;
        case ACK_RET_SEND_MESSAGE:
        {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                int flag = [[parameter valueForKey:@"flag"] intValue];
                MessageDAO *messageDAO = [[MessageDAO alloc] init];
                if(result==0){
                    [messageDAO updateMessageStateWithFlag:flag state:MESSAGE_STATE_NO_READ];
                }else{
                    [messageDAO updateMessageStateWithFlag:flag state:MESSAGE_STATE_SEND_FAILURE];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                        object:self
                                                                      userInfo:nil];
                });
            });
            
            
            DLog(@"ACK_RET_GET_DEVICE_TIME:%i",result);
        }
            break;
        case ACK_RET_GET_DEFENCE_STATE:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                NSString *contactId = @"10000";
                if(result==1){
                    
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_WARNING_PWD];
                    if([[FListManager sharedFList] getIsClickDefenceStateBtn:contactId]){
                        [self.window makeToast:NSLocalizedString(@"device_password_error", nil)];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                            object:self
                                                                          userInfo:nil];
                    });
                }else if(result==2){
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_WARNING_NET];
                    if([[FListManager sharedFList] getIsClickDefenceStateBtn:contactId]){
                        [self.window makeToast:NSLocalizedString(@"net_exception", nil)];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                            object:self
                                                                          userInfo:nil];
                    });
                }else if (result==4){
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_NO_PERMISSION];
                    if([[FListManager sharedFList] getIsClickDefenceStateBtn:contactId]){
                        [self.window makeToast:NSLocalizedString(@"no_permission", nil)];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                            object:self
                                                                          userInfo:nil];
                    });
                }
                
                [[FListManager sharedFList] setIsClickDefenceStateBtnWithId:contactId isClick:NO];
                
            });
            
            DLog(@"ACK_RET_GET_DEFENCE_STATE:%i",result);
        }
            break;
        case ACK_RET_SET_NPCSETTINGS_REMOTE_DEFENCE:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result==1){
                    
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_WARNING_PWD];
                    if([[FListManager sharedFList] getIsClickDefenceStateBtn:contactId]){
                        [self.window makeToast:NSLocalizedString(@"device_password_error", nil)];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                            object:self
                                                                          userInfo:nil];
                    });
                }else if(result==2){
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_WARNING_NET];
                    if([[FListManager sharedFList] getIsClickDefenceStateBtn:contactId]){
                        [self.window makeToast:NSLocalizedString(@"net_exception", nil)];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                            object:self
                                                                          userInfo:nil];
                    });
                }else if (result==4){
                    [[FListManager sharedFList] setDefenceStateWithId:contactId type:DEFENCE_STATE_NO_PERMISSION];
                    if([[FListManager sharedFList] getIsClickDefenceStateBtn:contactId]){
                        [self.window makeToast:NSLocalizedString(@"no_permission", nil)];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage"
                                                                            object:self
                                                                          userInfo:nil];
                    });
                }else{
                    ContactDAO *contactDAO = [[ContactDAO alloc] init];
                    Contact *contact = [contactDAO isContact:contactId];
                    if(nil!=contact){
                        [[P2PClient sharedClient] getDefenceState:contact.contactId password:contact.contactPassword];
                    }
                    
                }
                
                [[FListManager sharedFList] setIsClickDefenceStateBtnWithId:contactId isClick:NO];
                
            });
            DLog(@"ACK_RET_GET_DEFENCE_STATE:%i",result);
        }
            break;
    }
    
}

-(void)onSessionIdError:(id)sender{
    [[P2PClient sharedClient] p2pHungUp];
    
    [UDManager setIsLogin:NO];
    
    [[GlobalThread sharedThread:NO] kill];
    [[FListManager sharedFList] setIsReloadData:YES];
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    //APP将返回登录界面时，注册新的token，登录时传给服务器
    [[AppDelegate sharedDefault] reRegisterForRemoteNotifications];
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, NULL);
    dispatch_async(queue, ^{
        [[P2PClient sharedClient] p2pDisconnect];
        DLog(@"p2pDisconnect.");
    });
}

- (void)onReceiveAlarmMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    
    //contact name
    NSString *contactId   = [parameter valueForKey:@"contactId"];
    ContactDAO *contactDAO = [[ContactDAO alloc] init];
    Contact *contact = [contactDAO isContact:contactId];
    NSString *contactName = contact.contactName;
    
    //YES 表示删除绑定的报警推送ID,显示“解绑”按钮
    __unused BOOL isSupportDelAlarmPushId = [[parameter valueForKey:@"isSupportDelAlarmPushId"] boolValue];
    
    //contact type
    int type   = [[parameter valueForKey:@"type"] intValue];
    
    //防区、通道
    int group   = [[parameter valueForKey:@"group"] intValue];
    int item   = [[parameter valueForKey:@"item"] intValue];
    
    //推送提示消息
    NSString *message2 = @"";//addgroupItem
    NSString *leftSpace = @"                ";//16;
    
    
    //根据报警类型显示文字
    NSString *typeStr = @"";
    BOOL isUnknownType = NO;
    switch(type){
        case 1:
        {
            typeStr = NSLocalizedString(@"extern_alarm", nil);
            if (group>=1 && group<=8) {//addgroupItem
                message2 = [NSString stringWithFormat:@"%@%@ :%@\n%@%@ :%d",leftSpace,NSLocalizedString(@"defence_group", nil),[self groupName:group],leftSpace,NSLocalizedString(@"defence_item", nil),item+1];
            }
        }
            break;
        case 2:
        {
            typeStr = NSLocalizedString(@"motion_dect_alarm", nil);
        }
            break;
        case 3:
        {
            typeStr = NSLocalizedString(@"emergency_alarm", nil);
        }
            break;
        case 4:
        {
            typeStr = NSLocalizedString(@"debug_alarm", nil);
        }
            break;
        case 5:
        {
            typeStr = NSLocalizedString(@"ext_line_alarm", nil);
        }
            break;
        case 6:
        {
            typeStr = NSLocalizedString(@"low_vol_alarm", nil);
        }
            break;
        case 7:
        {
            typeStr = NSLocalizedString(@"pir_alarm", nil);
        }
            break;
        case 8:
        {
            typeStr = NSLocalizedString(@"defence_alarm", nil);
        }
            break;
        case 9:
        {
            typeStr = NSLocalizedString(@"defence_disable_alarm", nil);
        }
            break;
        case 10:
        {
            typeStr = NSLocalizedString(@"battery_low_vol", nil);
        }
            break;
        case 11:
        {
            typeStr = NSLocalizedString(@"update_to_ser", nil);
        }
            break;
        case 13://门铃报警类型
        {
            typeStr = NSLocalizedString(@"somebody_visit", nil);
        }
            break;
        default:
        {
            //未知类型
            typeStr = [NSString stringWithFormat:@"%d",type];
            isUnknownType = YES;
        }
            break;
    }
    
    
    //APP在后台
    if(self.isGoBack){
        UILocalNotification *alarmNotify = [[UILocalNotification alloc] init];
        alarmNotify.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        alarmNotify.timeZone = [NSTimeZone defaultTimeZone];
        alarmNotify.soundName = [self playAlarmMessageRingWithAlarmType:type isBeBackground:YES];
        if ([contactId isEqualToString:contactName] || contactName == nil) {
            alarmNotify.alertBody = [NSString stringWithFormat:@"%@:%@",contactId,typeStr];
        }else{
            alarmNotify.alertBody = [NSString stringWithFormat:@"%@:%@",contactName,typeStr];
        }
        alarmNotify.applicationIconBadgeNumber = 1;
        alarmNotify.alertAction = NSLocalizedString(@"open", nil);
        [[UIApplication sharedApplication] scheduleLocalNotification:alarmNotify];
    }
    
    
    //YES表示正处于视频通话中，不接收推送
    if (self.isBeingInP2PVideo) {
        return;
    }
    
    
    //alarmContactId正处于被监控状态,不作推送
    if ([self.monitoredContactId isEqualToString:contactId]) {
        return;
    }
    
    
    //alarmContactId正处于弹出状态,不作推送
    if ([self.currentPushedContactId isEqualToString:contactId]) {
        return;
    }
    
    
    //YES表示接收到推送，正在输入密码准备进行监控，此时不弹出任何推送
    if (self.isInputtingPwdToMonitor) {
        return;
    }
    
    
    //YES表示正显示门铃推送界面，不弹出任何推送
    if (self.isShowingDoorBellAlarm) {
        return;
    }
    
    
    //isCanShow = NO表示监控中
    P2PCallState p2pCallState = [[P2PClient sharedClient] p2pCallState];
    BOOL isCanShow = NO;
    if(p2pCallState==P2PCALL_STATUS_NONE){
        isCanShow = YES;
    }else{
        isCanShow = NO;
    }
    
    //上一次与当前推送的时间间隔,超过10秒，则弹出推送框
    BOOL isTimeAfter = NO;
    if(([Utils getCurrentTimeInterval]-self.lastShowAlarmTimeInterval)>10){
        isTimeAfter = YES;
        
    }else{
        isTimeAfter = NO;
    }
    
    
    
    //弹出推送提示框，一是门铃推送，二是其他
    if(isTimeAfter&&!self.isGoBack){//alarmAlertview   isCanShow&&
        [self playAlarmMessageRingWithAlarmType:type isBeBackground:NO];//播放推送铃声
        
        self.alarmContactId = contactId;
        self.currentPushedContactId = contactId;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (type == 13 && isCanShow) {//为门铃推送,isCanShow为YES表示不在监控中...
                self.isDoorBellAlarm = YES;//在监控界面使用,区分门铃推送，其他推送
                self.isShowingDoorBellAlarm = YES;//表示正显示门铃推送界面
                
            }else{//为其他推送
                if (type == 13 && !isCanShow) {//为门铃推送,isCanShow为NO表示在监控中...
                    self.isDoorBellAlarm = YES;//在监控界面使用,区分门铃推送，其他推送
                }else{
                    self.isDoorBellAlarm = NO;//在监控界面使用,区分门铃推送，其他推送
                }
                
                
            }
        });//alarmAlertview
    }
}

#pragma mark - 透传门铃（安尔发...）
-(void)onReceiveDoorbellAlarmMessage:(NSNotification *)notification{
    NSDictionary *parameter = [notification userInfo];
    
    NSString *cmd = [parameter valueForKey:@"cmd"];
    
    if ([cmd isEqualToString:@"anerfa:disconnect"]) {
        NSString *contactId = [parameter valueForKey:@"contactId"];
        ContactDAO *contactDAO = [[ContactDAO alloc] init];
        Contact *contact = [contactDAO isContact:contactId];
        [[P2PClient sharedClient] sendCustomCmdWithId:contactId password:contact.contactPassword cmd:@"IPC1anerfa:disconnect"];
        
    }else if ([[cmd substringToIndex:11] isEqualToString:@"anerfa:call"]) {
        NSString *contactId = [parameter valueForKey:@"contactId"];
        ContactDAO *contactDAO = [[ContactDAO alloc] init];
        Contact *contact = [contactDAO isContact:contactId];
        NSString *contactName = contact.contactName;
        
        NSString *typeStr = NSLocalizedString(@"somebody_visit", nil);
        
        //后台推送
        if(self.isGoBack){
            UILocalNotification *alarmNotify = [[UILocalNotification alloc] init];
            alarmNotify.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
            alarmNotify.timeZone = [NSTimeZone defaultTimeZone];
            alarmNotify.soundName = [self playAlarmMessageRingWithAlarmType:13 isBeBackground:YES];
            if ([contactId isEqualToString:contactName] || contactName == nil) {
                alarmNotify.alertBody = [NSString stringWithFormat:@"%@:%@",contactId,typeStr];
            }else{
                alarmNotify.alertBody = [NSString stringWithFormat:@"%@:%@",contactName,typeStr];
            }
            alarmNotify.applicationIconBadgeNumber = 1;
            alarmNotify.alertAction = NSLocalizedString(@"open", nil);
            [[UIApplication sharedApplication] scheduleLocalNotification:alarmNotify];
        }
        
        
        //YES表示正处于视频通话中，不接收推送
        if (self.isBeingInP2PVideo) {
            return;
        }
        
        
        //alarmContactId正处于被监控状态,不作推送
        if ([self.monitoredContactId isEqualToString:contactId]) {
            return;
        }
        
        
        //alarmContactId正处于弹出状态,不作推送
        if ([self.currentPushedContactId isEqualToString:contactId]) {
            return;
        }
        
        
        //YES表示接收到推送，正在输入密码准备进行监控，此时不弹出任何推送
        if (self.isInputtingPwdToMonitor) {
            return;
        }
        
        
        //YES表示正显示门铃推送界面，不弹出任何推送
        if (self.isShowingDoorBellAlarm) {
            return;
        }
        
        
        //isCanShow = NO表示监控中
        P2PCallState p2pCallState = [[P2PClient sharedClient] p2pCallState];
        BOOL isCanShow = NO;
        if(p2pCallState==P2PCALL_STATUS_NONE){
            isCanShow = YES;
        }else{
            isCanShow = NO;
        }
        
        
        //上一次与当前推送的时间间隔,超过10秒，则弹出推送框
        BOOL isTimeAfter = NO;
        if(([Utils getCurrentTimeInterval]-self.lastShowAlarmTimeInterval)>10){
            isTimeAfter = YES;
            
        }else{
            isTimeAfter = NO;
        }
        
        
        
        if(isTimeAfter&&!self.isGoBack){//alarmAlertview
            [self playAlarmMessageRingWithAlarmType:13 isBeBackground:NO];//播放推送铃声
            
            self.alarmContactId = contactId;
            self.currentPushedContactId = contactId;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isCanShow) {//为门铃推送,isCanShow为YES表示不在监控中...
                    self.isDoorBellAlarm = YES;//在监控界面使用,区分门铃推送，其他推送
                    self.isShowingDoorBellAlarm = YES;//表示正显示门铃推送界面
                    
                    
                    
                }else{//为门铃推送,isCanShow为NO表示在监控中...
                    self.isDoorBellAlarm = YES;//在监控界面使用,区分门铃推送，其他推送
                    
                }
                
            });
        }//alarmAlertview
    }else{
        //unknown error
    }
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    self.networkStatus = [curReach currentReachabilityStatus];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameter setObject:[NSNumber numberWithInt:self.networkStatus] forKey:@"status"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NET_WORK_CHANGE
                                                        object:self
                                                      userInfo:parameter];
}

-(NSString *)groupName:(int)group{//addgroupItem
    NSString *groupName = @"";
    switch(group){
        case 1:
        {
            groupName = NSLocalizedString(@"hall", nil);
        }
            break;
        case 2:
        {
            groupName = NSLocalizedString(@"window", nil);
        }
            break;
        case 3:
        {
            groupName = NSLocalizedString(@"balcony", nil);
        }
            break;
        case 4:
        {
            groupName = NSLocalizedString(@"bedroom", nil);
        }
            break;
        case 5:
        {
            groupName = NSLocalizedString(@"kitchen", nil);
        }
            break;
        case 6:
        {
            groupName = NSLocalizedString(@"courtyard", nil);
        }
            break;
        case 7:
        {
            groupName = NSLocalizedString(@"door_lock", nil);
        }
            break;
        case 8:
        {
            groupName = NSLocalizedString(@"other", nil);
        }
            break;
    }
    return groupName;
}

#pragma mark - 报警铃声播放
-(NSString *)playAlarmMessageRingWithAlarmType:(int)alarmType isBeBackground:(BOOL)isBackground{
    NSURL *ringUrl = nil;
    //return @"default";//关闭前台铃声，恢复后台默认铃声
    switch(alarmType){
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        {
            return @"default";//关闭前台铃声，恢复后台默认铃声
            
            if(isBackground){
                return @"alarm_push_ring.caf";
            }
            
            ringUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"alarm_push_ring" ofType:@"caf"]];
        }
            break;
        case 13:
        {
            if(isBackground){
                return @"door_bell_ring.caf";
            }
            
            //门铃报警类型
            ringUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"door_bell_ring" ofType:@"caf"]];
        }
            break;
        default:
        {
            return @"default";//关闭前台铃声，恢复后台默认铃声
            
            if(isBackground){
                return @"unknown_push_ring.caf";
            }
            
            //未知类型
            ringUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"unknown_push_ring" ofType:@"caf"]];
        }
            break;
    }
    
    //为什么从监控退出后，AVAudioPlayer的声音变小了
    //解决方法：
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //音频播放器加载音乐
    self.alarmRingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:ringUrl error:nil];
    //准备播放
    [self.alarmRingPlayer prepareToPlay];
    //设置声音
    self.alarmRingPlayer.volume = 1.0;
    //播放次数
    self.alarmRingPlayer.numberOfLoops = 0;
    //开始播放
    [self.alarmRingPlayer play];
    
    return nil;
}

#pragma mark - 停止播放报警铃声
-(void)stopToPlayAlarmRing{
    if(self.alarmRingPlayer.isPlaying){
        [self.alarmRingPlayer stop];
        
        
        P2PCallState p2pCallState = [[P2PClient sharedClient] p2pCallState];
        if(p2pCallState!=P2PCALL_STATUS_NONE){//表示监控中
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        }
    }
}

#pragma mark - APP将返回登录界面时，注册新的token，登录时传给服务器
-(void)reRegisterForRemoteNotifications{
    if (CURRENT_VERSION>=9.3) {
        if(CURRENT_VERSION>=8.0){//8.0以后使用这种方法来注册推送通知
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
        }else{
            //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
        }
    }
}


@end
