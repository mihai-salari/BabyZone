//
//  WiFiConnectView.h
//  EnjoyLove
//
//  Created by 黄漫 on 16/10/4.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WiFiConnectView : UIView
@property (nonatomic, copy, readwrite) NSString *WiFi;
@property (nonatomic, assign) BOOL isWiFiAvalible;
@property (nonatomic, copy) void(^startInputHandler)();

- (instancetype)initWithFrame:(CGRect)frame completionHandler:(void(^)(BOOL finished, NSString *ssid, NSString *password))completionHandler;

@end
