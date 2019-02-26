//
//  YLHomeController.m
//  YLYouCarServer
//
//  Created by lm on 2018/11/28.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLHomeController.h"
#import "YLAllOrderController.h"
#import "YLReservationController.h"
#import "YLLookCarController.h"
#import "YLSettingController.h"

#import "YLSkipView.h"

@interface YLHomeController ()

@end

@implementation YLHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"优卡检测中心";
    [self setNav];
    [self addControllers];
    
}

- (void)addControllers {
    NSArray *titles = @[@"全部", @"待约定", @"待验车",@"已上架", @"买家看车", @"已交易", @"已下架"];
    YLAllOrderController *viewVC1 = [[YLAllOrderController alloc] init];
    viewVC1.status = @"";
    YLReservationController *viewVC2= [[YLReservationController alloc] init];
    viewVC2.status = @"1";
    YLAllOrderController *viewVC3 = [[YLAllOrderController alloc] init];
    viewVC3.status = @"2";
    YLAllOrderController *viewVC4 = [[YLAllOrderController alloc] init];
    viewVC4.status = @"3";
    YLLookCarController *viewVC5 = [[YLLookCarController alloc] init];
    viewVC5.status = @"11";
    YLAllOrderController *viewVC6 = [[YLAllOrderController alloc] init];
    viewVC6.status = @"4";
    YLAllOrderController *viewVC7 = [[YLAllOrderController alloc] init];
    viewVC7.status = @"0";
//    UIViewController *viewVC3 = [[UIViewController alloc] init];
//    viewVC3.view.backgroundColor = YLRandomColor;
//    UIViewController *viewVC4 = [[UIViewController alloc] init];
//    viewVC4.view.backgroundColor = YLRandomColor;
//    UIViewController *viewVC5 = [[UIViewController alloc] init];
//    viewVC5.view.backgroundColor = YLRandomColor;
//    UIViewController *viewVC6 = [[UIViewController alloc] init];
//    viewVC6.view.backgroundColor = YLRandomColor;
//    UIViewController *viewVC7 = [[UIViewController alloc] init];
//    viewVC7.view.backgroundColor = YLRandomColor;
    
    NSArray *contrls = @[viewVC1, viewVC2, viewVC3, viewVC4, viewVC5, viewVC6, viewVC7];
    YLSkipView *skip = [[YLSkipView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, YLScreenHeight)];
    skip.titles = titles;
    skip.controllers = contrls;
    [self.view addSubview:skip];
    
    [self addChildViewController:viewVC1];
    [self addChildViewController:viewVC2];
    [self addChildViewController:viewVC3];
    [self addChildViewController:viewVC4];
    [self addChildViewController:viewVC5];
    [self addChildViewController:viewVC6];
    [self addChildViewController:viewVC7];
    //    [self addChildViewController:viewVC8];
}

#pragma  私有方法
- (void)setNav {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    // 修改导航标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self setNavgationBarBackgroundImage];
}

- (void)rightBarButtonItemClick {
    NSLog(@"设置");
    YLSettingController *setting = [[YLSettingController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)setNavgationBarBackgroundImage {
    CGGradientRef gradient;// 颜色的空间
    size_t num_locations = 2;// 渐变中使用的颜色数
    CGFloat locations[] = {0.0, 1.0}; // 指定每个颜色在渐变色中的位置，值介于0.0-1.0之间, 0.0表示最开始的位置，1.0表示渐变结束的位置
    CGFloat colors[] = {
        13.0/255.0, 196.f/255.f, 255.f/255, 1.0,
        3.0/255.0, 141.f/255.f, 255.f/255, 1.0,
    }; // 指定渐变的开始颜色，终止颜色，以及过度色（如果有的话）
    gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), colors, locations, num_locations);
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(self.view.frame.size.width, 1.0);
    CGSize size = CGSizeMake(self.view.frame.size.width, 1.0);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%f-%f", image.size.width, image.size.height);
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}


//- (void)setNav {
//    // 添加右边搜索按钮
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YLNormalFont, NSFontAttributeName, nil] forState:UIControlStateNormal];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YLNormalFont, NSFontAttributeName, nil] forState:UIControlStateHighlighted];
//
//}
//
//- (void)setting {
//    NSLog(@"点击登录");
//
//}

@end
