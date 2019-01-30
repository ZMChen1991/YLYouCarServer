//
//  YLSettingController.m
//  YLYouCarServer
//
//  Created by lm on 2019/1/10.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSettingController.h"
#import "YLCondition.h"
#import "YLAccountTool.h"
#import "YLLoginController.h"
#import "YLNavigationController.h"

@interface YLSettingController ()

@end

@implementation YLSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    YLCondition *logout = [YLCondition buttonWithType:UIButtonTypeCustom];
    logout.type = YLConditionTypeBlue;
    logout.frame = CGRectMake(YLMargin, 100, YLScreenWidth - 2 * YLMargin, 40);
    [logout setTitle:@"退出" forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logout];
}

- (void)logoutClick {
    NSLog(@"退出登录");
    [YLAccountTool loginOut];
    YLLoginController *login = [[YLLoginController alloc] init];
    YLNavigationController *nav = [[YLNavigationController alloc] initWithRootViewController:login];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = nav;
}

@end
