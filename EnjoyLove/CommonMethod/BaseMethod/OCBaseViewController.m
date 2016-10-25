//
//  OCBaseViewController.m
//  EnjoyLove
//
//  Created by 黄漫 on 16/10/7.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

#import "OCBaseViewController.h"
#import "OCMethod.h"
#import "P2PMonitorController.h"

@interface OCBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation OCBaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    UIImage *image = [UIImage imageFromColor:[UIColor clearColor] andSize:CGSizeMake(SCREEN_WIDTH, 64)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage imageFromColor:[UIColor clearColor] andSize:CGSizeMake(SCREEN_WIDTH, 1)];
    
    self.tabBarController.tabBar.backgroundImage = [UIImage imageFromColor:[UIColor clearColor] andSize:CGSizeMake(SCREEN_WIDTH, 49)];
    self.tabBarController.tabBar.shadowImage = [UIImage imageFromColor:[UIColor clearColor] andSize:CGSizeMake(SCREEN_WIDTH, 1)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    gradientLayer.colors = @[(id)[UIColor colorFromHexString:@"#da5a7b"].CGColor, (id)[UIColor colorFromHexString:@"#e27360"].CGColor];
    gradientLayer.locations = @[[NSNumber numberWithFloat:0.1], [NSNumber numberWithFloat:0.9]];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    if ([self isKindOfClass: [P2PMonitorController class]]) {
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
