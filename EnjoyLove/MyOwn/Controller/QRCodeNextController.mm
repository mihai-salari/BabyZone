//
//  QRCodeNextController.m
//  Yoosee
//
//  Created by guojunyi on 14-9-18.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import "QRCodeNextController.h"
#import "Constants.h"
#import "FListManager.h"
#import "WiFiConnectView.h"
#import "elian.h"
#import "WiFiConnectView.h"
#import "GCDAsyncUdpSocket.h"
#import "OCMethod.h"
#import "P2PClient.h"
#import "ContactDAO.h"
#import "Contact.h"
#import "FListManager.h"
#import "MD5Manager.h"
#import "EnjoyLove-Swift.h"

#define ALERT_TAG_SET_FAILED 0
#define ALERT_TAG_SET_SUCCESS 1

enum
{
    conectType_Intelligent,
//    conectType_qrcode
};

@interface QRCodeNextController (){
    void *_context;
}
@property (nonatomic,copy) NSString *contactID;
@property (nonatomic,assign) NSInteger flag;
@property (nonatomic,assign) NSInteger type;
@property (strong,nonatomic) NSMutableDictionary *addresses;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,strong) NSString *uuidString;
@property (nonatomic,strong) NSString *wifiPwd;

@property (nonatomic) BOOL isNotFirst;
@property (nonatomic) BOOL isWaiting;//YES表示发包设置wifi后，在等待局域网添加设备
@property (nonatomic) BOOL isFinish;
@property (strong, nonatomic) GCDAsyncUdpSocket *socket;
@property (assign) BOOL isRun;
@property (nonatomic) BOOL isShowSuccessAlert;
@property (assign) BOOL isPrepared;
@property (nonatomic) int conectType;        //1-二维码扫描 0-智能联机

@property (nonatomic, strong) WiFiConnectView *connectionView;

@property (strong, nonatomic) NSString *lastSetPassword;
@property (nonatomic, copy) NSString *contactIp;//added a code here

@property (nonatomic, assign) BOOL stopFetch;
@property (nonatomic, assign) BOOL wifiInitialized;

@property (nonatomic, assign) NetworkStatus networkStatus;

@end

@implementation QRCodeNextController

-(void)dealloc{
    self.uuidString = nil;
    self.wifiPwd = nil;
    self.address = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self navigationBarItemWithNavigationTitle:@"连接设备" isImage:NO leftSelector:nil leftImage:nil letfTitle:nil leftItemSize:CGSizeZero rightSelector:nil rightImage:nil rightTitle:nil rightItemSize:CGSizeZero];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteMessage:) name:RECEIVE_REMOTE_MESSAGE object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ack_receiveRemoteMessage:) name:ACK_RECEIVE_REMOTE_MESSAGE object:nil];
    
    if (self.conectType == conectType_Intelligent)
    {
        //        [HMHUD showHud:@"正在连接..." onView:self.view];
        [self startSetWifiLoop];//给设备设置wifi
        
        [self onBottomButtom1Press];//直接调用，不用点击“听到了”按钮
    }
    self.isFinish = NO;
}




-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isRun = YES;
    self.isPrepared = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(self.isRun){//不断广播获取设置好WIFI的设备
            if(!self.isPrepared){
                [self prepareSocket];
            }
            usleep(1000000);
        }
    });
}


- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    self.addresses = [[NSMutableDictionary alloc] initWithCapacity:1];
    self.conectType = conectType_Intelligent;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChange:) name:NET_WORK_CHANGE object:nil];
    [self initComponent];
    [self getWiFiLoop];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVE_REMOTE_MESSAGE object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NET_WORK_CHANGE object:nil];
    
    if (self.conectType == conectType_Intelligent){//startSetWifiLoop
        if (_context){
            elianStop(_context);
            elianDestroy(_context);
            _context = NULL;
        }
    }
    
    self.isWaiting = NO;//isWaiting is NO
    self.isFinish = YES;
    self.isRun = NO;
    self.stopFetch = YES;
    if(self.socket){
        [self.socket close];
        self.socket=nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)networkStatusChange:(NSNotification *)notification{
    NSNumber *networkNumer = notification.userInfo[@"status"];
    self.networkStatus = (NetworkStatus)networkNumer.intValue;
}

- (void)setNetworkStatus:(NetworkStatus)networkStatus{
    if (_networkStatus != networkStatus) {
        self.wifiInitialized = NO;
    }
    _networkStatus = networkStatus;
}

- (void)getWiFiLoop{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (!self.stopFetch)
        {
            
            NSString *ssid = [WIFI getSSID];
              if(![ssid isEqualToString:@""])
            {
                if (!self.wifiInitialized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.connectionView) {
                            self.connectionView.WiFi = ssid;
                            self.connectionView.isWiFiAvalible = YES;
                        }
                        self.wifiInitialized = YES;
                        return ;
                    });
                }
            }
            else
            {
                if (self.wifiInitialized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.connectionView) {
                            self.connectionView.WiFi = @"获取WiFi失败";
                        }
                        self.wifiInitialized = NO;
                        return ;
                    });
                }
            }
            sleep(3);
        }
    });
}


-(BOOL)prepareSocket{
    GCDAsyncUdpSocket *socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    NSError *error = nil;
    
    
    if (![socket bindToPort:9988 error:&error])
    {
        //NSLog(@"Error binding: %@", [error localizedDescription]);
        return NO;
    }
    if (![socket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", [error localizedDescription]);
        return NO;
    }
    
    if (![socket enableBroadcast:YES error:&error])
    {
        NSLog(@"Error enableBroadcast: %@", [error localizedDescription]);
        return NO;
    }
    
    self.socket = socket;
    self.isPrepared = YES;
    return YES;
}

-(void)initComponent{
    
    __weak typeof(self) weakSelf = self;
    self.connectionView = [[WiFiConnectView alloc] initWithFrame:CGRectMake(VIEW_ORIGIN_X, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH - 2 * VIEW_ORIGIN_X, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT) completionHandler:^(BOOL finished, NSString *ssid, NSString *password) {
        weakSelf.uuidString = ssid;
        weakSelf.wifiPwd = password;
        [weakSelf startSetWifiLoop];//给设备设置wifi
        [weakSelf onBottomButtom1Press];//直接调用，不用点击“听到了”按钮
        self.isFinish = NO;
    }];
    self.connectionView.startInputHandler = ^(){
        weakSelf.stopFetch = YES;
    };
    [self.view addSubview:self.connectionView];
    self.isShowSuccessAlert = NO;
    
}


-(void)onBackPress{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 使用90秒来进行空中发包，给设备设置wifi
-(void)onBottomButtom1Press{
    if (!_context) {
        return;
    }
    [HMHUD showHud:@"" onView:self.view];
    self.isWaiting = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int index = 0;
        while(self.isWaiting){
            [HMHUD showHudTip:[NSString stringWithFormat:@"正在设置WiFi--%i(s)",(90 - index)] forView:self.view];
            NSLog(@"%i",index);
            index++;
            if (self.conectType == conectType_Intelligent){//startSetWifiLoop
                if (index >= 21 && index <= 30)
                {
                    if (index == 21)
                    {
                        elianStop(_context);
                    }
                }
                else if (index >= 51 && index <= 60)
                {
                    if (index == 51)
                    {
                        elianStop(_context);
                    }
                }
                else if (index >= 81)
                {
                    if (index == 81)
                    {
                        elianStop(_context);
                    }
                }
                else
                {
                    if (index==31 || index==61)
                    {
                        elianStart(_context);
                    }
                }
                if(index>=90)
                {//90
                    break;
                }
            }
            else
            {
                if(index>=60)
                {//60
                    break;
                }
            }
            sleep(1.0);
        }
        
        
        if(!self.isFinish){
            if (self.conectType == conectType_Intelligent){//startSetWifiLoop
                if (_context){
                    elianStop(_context);
                    elianDestroy(_context);
                    _context = NULL;
                }//设置WIFI失败，停止
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HMHUD hideHud:self.view];
                [HMHUD showText:@"连接WiFi失败" onView:self.view];
                self.isWaiting = NO;//isWaiting is NO
            });
            
        }
    });
}



#pragma mark - GCDAsyncUdpSocket
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"did send");
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"error %@", error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    [self searchDeviceWithUdpSocket:sock receivedData:data fromAddress:address withFilterContext:filterContext];
}

#pragma mark - 搜索设备

- (void)searchDeviceWithUdpSocket:(GCDAsyncUdpSocket *)sock receivedData:(NSData *)data
                      fromAddress:(NSData *)address
                withFilterContext:(id)filterContext{
    if (data) {
        Byte receiveBuffer[1024];
        [data getBytes:receiveBuffer length:1024];
        
        if(receiveBuffer[0]==1){
            NSString *host = nil;
            uint16_t port = 0;
            [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
            
            int contactId = *(int*)(&receiveBuffer[16]);
            int type = *(int*)(&receiveBuffer[20]);
            int flag = *(int*)(&receiveBuffer[24]);
            
            self.contactID = [NSString stringWithFormat:@"%d",contactId];
            self.type = type;
            self.flag = flag;
            [self.addresses setObject:host forKey:[NSString stringWithFormat:@"%i",contactId]];
            
            
            if(self.isShowSuccessAlert){
                return;
            }
            
            
            if(self.isWaiting){
                self.isWaiting = NO;//isWaiting is NO
                self.isShowSuccessAlert = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isFinish = YES;
                    [HMHUD hideHud:self.view];
                    if (!self.isNotFirst) {
                        if (self.conectType == conectType_Intelligent){//startSetWifiLoop
                            if (_context){
                                elianStop(_context);
                                elianDestroy(_context);
                                _context = NULL;
                            }//设置WIFI成功，停止
                        }
#pragma mark -  搜索成功后操作
                        
                        NSString *alertTitle = [self.contactID isEqualToString:@""] || self.contactID == nil ? @"设置失败" : @"设置成功";
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
                        
                        __weak typeof(self) weakSelf = self;
                        
                        if (self.contactID) {
                            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                weakSelf.address = [weakSelf.addresses objectForKey:weakSelf.contactID];
                                NSArray *stringArray = [weakSelf.address componentsSeparatedByString:@"."];
                                NSString *targetAdress = [NSString stringWithFormat:@"%@",[stringArray lastObject]];
                                weakSelf.contactIp = targetAdress;
                                
                                Contact *contact = [[Contact alloc] init];
                                contact.contactId = weakSelf.contactID;
                                contact.contactName = [NSString stringWithFormat:@"宝宝看护器%@",weakSelf.contactID];
                                if ([weakSelf.contactID characterAtIndex:0] != '0') {
                                    contact.contactPassword = DEVICE_PASSWORD;
                                    contact.contactType = CONTACT_TYPE_UNKNOWN;
                                }else{
                                    contact.contactType = CONTACT_TYPE_PHONE;
                                }
                                [(FListManager *)[FListManager sharedFList] insert: contact];
                                
                                [[P2PClient sharedClient] getContactsStates:[NSArray arrayWithObject:contact.contactId]];
                                [[P2PClient sharedClient] getDefenceState:contact.contactId password:contact.contactPassword];
                                [Equipments sendAsyncAddEquitment:contact.contactName eqmType:@"1" eqmDid:contact.contactId eqmAccount:[[NSUserDefaults standardUserDefaults] objectForKey:[[BabyZoneConfig shared] UserPhoneKey]] eqmPwd:contact.contactPassword eqmStatus:contact.onLineState  completionHandler:^(NSString * _Nullable errorCode, NSString * _Nullable msg) {
                                    if (errorCode && [errorCode isEqualToString:[[BabyZoneConfig shared] UserPhoneKey]]) {
                                        
                                    }
                                }];
                                DevicesViewController *devices = [[DevicesViewController alloc] init];
                                [self.navigationController pushViewController:devices animated:YES];
                            }];
                            [alertController addAction:confirmAction];
                            self.isNotFirst = YES;
                        }else{
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            [alertController addAction:cancelAction];
                        }
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                });
                
            }
        }
    }
}


#pragma mark - 空中发包，给设备设置wifi
- (void)startSetWifiLoop
{
    if (self.uuidString == nil) {
        return;
    }
    //ssid
    const char *ssid = [self.uuidString cStringUsingEncoding:NSUTF8StringEncoding];
    //authmode
    int authmode = 9;//delete
    //pwd
    const char *password = [self.wifiPwd cStringUsingEncoding:NSUTF8StringEncoding];//NSASCIIStringEncoding
    //target
    unsigned char target[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
    
    _context = elianNew(NULL, 0, target, ELIAN_SEND_V1 | ELIAN_SEND_V4);
    elianPut(_context, TYPE_ID_AM, (char *)&authmode, 1);//delete
    elianPut(_context, TYPE_ID_SSID, (char *)ssid, strlen(ssid));
    elianPut(_context, TYPE_ID_PWD, (char *)password, strlen(password));
    
    elianStart(_context);
}

@end
