//
//  WiFiConnectView.m
//  EnjoyLove
//
//  Created by 黄漫 on 16/10/4.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

#import "WiFiConnectView.h"
#import "EnjoyLove-Swift.h"
@interface WiFiConnectView ()<UITextFieldDelegate>

@property (nonatomic, strong) Keyboard *passwordKeyboard;
@property (nonatomic, strong) UITextField *wifiTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, copy) void(^finishHandler)(BOOL finished, NSString *ssid, NSString *password);

@end

@implementation WiFiConnectView

- (instancetype)initWithFrame:(CGRect)frame completionHandler:(void (^)(BOOL, NSString *, NSString *))completionHandler{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        DeviceButton *btn = [DeviceButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(30, 20, SCREEN_WIDTH * (2 / 3.0), 50);
        
        [btn setImageSize:CGSizeMake(15, 15) titleS:CGSizeMake(btn.frame.size.width, btn.frame.size.height) normaImage:@"Two_Number.png" selectedImage:@"" normalTitle:@"确保看护器电源已连通\n并连接您的WiFi!" selectedTitle:@"" fontSize:15];
        [btn setCustomTitleColor:[UIColor hexStringToColor:@"#ba5460"]];
        btn.userInteractionEnabled = NO;
        [self addSubview:btn];
        
        CGFloat phoneImageWidth = CGRectGetWidth(self.frame) * (1 / 5.0);
        CGFloat phoneImageHeight = phoneImageWidth * (2 / 3.0);
        UIImageView *phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - phoneImageWidth) / 2.0, self.frame.size.height / 2.0 - phoneImageHeight * 2.0, phoneImageWidth, phoneImageHeight)];
        phoneImageView.image = [UIImage imageWithName:@"myOwnWiFi.png"];
        [self addSubview:phoneImageView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height * (3 / 5.0), self.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor hexStringToColor:@"#f7f1f2"];
        [self addSubview:line];
        
        self.wifiTF  = [UITextField textField:CGRectMake(10, CGRectGetMaxY(line.frame), CGRectGetWidth(line.frame), 40) title:@"WiFi账号" titleColor:[UIColor lightGrayColor] seperatorColor:[UIColor clearColor] holder:@"" left:YES right:NO rightView:nil];
        self.wifiTF.textColor = [UIColor lightGrayColor];
        self.wifiTF.userInteractionEnabled = NO;
        [self addSubview:self.wifiTF];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.wifiTF.frame), CGRectGetWidth(self.frame), 0.5)];
        line.backgroundColor = [UIColor hexStringToColor:@"f7f1f2"];
        [self addSubview:line];
        
        self.passwordTF = [UITextField textField:CGRectMake(CGRectGetMinX(self.wifiTF.frame), CGRectGetMaxY(self.wifiTF.frame), CGRectGetWidth(self.wifiTF.frame), CGRectGetHeight(self.wifiTF.frame)) title:@"WiFi密码" titleColor:[UIColor lightGrayColor] seperatorColor:[UIColor clearColor] holder:@"请输入WiFi密码" left:YES right:NO rightView:nil];
        [self.passwordTF addTarget:self action:@selector(passwordEditEvent:) forControlEvents:UIControlEventEditingChanged];
        self.passwordTF.delegate = self;
        self.passwordTF.textColor = [UIColor lightGrayColor];
        [self addSubview:self.passwordTF];
        
        self.passwordKeyboard = [[Keyboard alloc] initWithTargetView:self.passwordTF container:self hasNav:YES show:nil hide:nil];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.passwordTF.frame), CGRectGetWidth(self.frame), 0.5)];
        line.backgroundColor = [UIColor hexStringToColor:@"#f7f1f2"];
        [self addSubview:line];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(20, CGRectGetHeight(self.frame) - 60, CGRectGetWidth(self.frame) - 40, 40);
        loginButton.layer.cornerRadius = 20;
        loginButton.layer.masksToBounds = YES;
        loginButton.backgroundColor = [UIColor hexStringToColor:@"#b85562"];
        [loginButton setTitle:@"完成" forState:UIControlStateNormal];
        loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(nextConnectStepClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginButton];
        
        self.finishHandler = completionHandler;
    }
    return self;
}

#pragma mark - SETTER

- (void)setWiFi:(NSString *)WiFi{
    if (self.wifiTF) {
        self.wifiTF.text = WiFi;
    }
}


- (void)nextConnectStepClick{
    [self.passwordTF resignFirstResponder];
    if (_isWiFiAvalible == NO) {
        [HUD showText:@"请您先连接WiFi" onView:self delay:3.0];
        return;
    }
    
    NSString *ssidString = @"";
    if (self.wifiTF.text && [self.wifiTF.text isEqualToString:@""]) {
        [HUD showText:@"获取WiFi连接失败\n请检查手机网络状态" onView:self delay:3.0];
        return;
    }else{
        ssidString = self.wifiTF.text;
    }
    
    NSString *psd = @"";
    if (self.passwordTF.text && [self.passwordTF.text isEqualToString:@""]) {
        [HUD showText:@"请输入WiFi密码" onView:self delay:3.0];
        return;
    }else{
        psd = self.passwordTF.text;
    }
    
    if (![ssidString isEqualToString:@""] && ![psd isEqualToString:@""]) {
        if (self.finishHandler) {
            self.finishHandler(YES, ssidString, psd);
        }
    }
    
}

- (void)passwordEditEvent:(UITextField *)textField{
    if (self.wifiTF.text && [self.wifiTF.text isEqualToString:@""]) {
        [HUD showText:@"获取WiFi连接失败\n请检查手机网络状态" onView:self delay:3.0];
        return;
    }
    if (self.startInputHandler) {
        self.startInputHandler();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
