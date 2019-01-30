//
//  YLNavigationController.m
//  YLYouCarServer
//
//  Created by lm on 2018/11/28.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLNavigationController.h"

@interface YLNavigationController ()

@end

@implementation YLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        leftBtn.backgroundColor = [UIColor redColor];
        leftBtn.frame = CGRectMake(0, 0, 50, 30);
        leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
        //        [leftBtn setEnlargeEdgeWithTop:0 right:10 bottom:10 left:50];
        [leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
        [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        UIBarButtonItem *nagetiveSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        nagetiveSpace.width = -50;
        viewController.navigationItem.leftBarButtonItems = @[nagetiveSpace, leftBarButtonItem];
        //        viewController.navigationItem.leftBarButtonItems = @[ leftBarButtonItem];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
    [self popViewControllerAnimated:YES];
}

@end
