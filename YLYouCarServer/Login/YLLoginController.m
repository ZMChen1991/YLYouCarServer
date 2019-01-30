//
//  YLLoginController.m
//  YLYouCarServer
//
//  Created by lm on 2019/1/2.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLLoginController.h"
#import "YLNavigationController.h"
#import "YLHomeController.h"
#import "YLRequest.h"
#import "YLAccount.h"
#import "YLAccountTool.h"

#define YLLeftMargin 15
#define YLScreenWidth [UIScreen mainScreen].bounds.size.width
#define YLScreenHeight [UIScreen mainScreen].bounds.size.height

@interface YLLoginController ()

@property (nonatomic, strong) UITextField *account;
@property (nonatomic, strong) UITextField *pwd;

@end

@implementation YLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self yl_initView];
    [self setNav];
}

- (void)yl_initView {
    
    UITextField *account = [[UITextField alloc] initWithFrame:CGRectMake(YLLeftMargin, YLLeftMargin, YLScreenWidth - 2 * YLLeftMargin, 40)];
    account.placeholder = @"请输入账号";
    account.font = YLNormalFont;
    account.layer.borderWidth = 0.5f;
    account.layer.borderColor = YLTitleGrayColor.CGColor;
    account.layer.cornerRadius = 5.f;
    account.layer.masksToBounds = YES;
    account.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    account.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:account];
    self.account = account;
    
    UITextField *pwd = [[UITextField alloc] initWithFrame:CGRectMake(YLLeftMargin, CGRectGetMaxY(account.frame) + YLLeftMargin, YLScreenWidth - 2 * YLLeftMargin, 40)];
    pwd.placeholder = @"请输入密码";
    pwd.font = YLNormalFont;
    pwd.layer.borderWidth = 0.5f;
    pwd.layer.borderColor = YLTitleGrayColor.CGColor;
    pwd.layer.cornerRadius = 5.f;
    pwd.layer.masksToBounds = YES;
    pwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    pwd.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:pwd];
    self.pwd = pwd;
    
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    login.frame = CGRectMake(YLLeftMargin, CGRectGetMaxY(pwd.frame) + YLLeftMargin, YLScreenWidth - 2 * YLLeftMargin, 40);
    login.backgroundColor = YLColor(8.f, 169.f, 255.f);
    login.layer.cornerRadius = 5.f;
    login.layer.masksToBounds = YES;
    login.titleLabel.font = YLNormalFont;
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
    
    NSString *string = @"提示:本客户端仅向优卡合作伙伴开放，如有合作意向，请联系优卡客服:0662-123456";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(YLLeftMargin, CGRectGetMaxY(login.frame) + YLLeftMargin, YLScreenWidth - 2 * YLLeftMargin, 40)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    label.text = string;
    label.textColor = YLColor(155.f, 155.f, 155.f);
    [self.view addSubview:label];
    
    self.account.text = @"100001";
    self.pwd.text = @"123456";
}

- (void)setNav {
    
    // 修改导航标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self setNavgationBarBackgroundImage];
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

- (void)loginClick {
    
    [self.account resignFirstResponder];
    [self.pwd resignFirstResponder];

    // 发送请求
    NSString *urlString = @"http://ucarjava.bceapp.com/center?method=login";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.account.text forKey:@"id"];
    [param setObject:self.pwd.text forKey:@"password"];
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            
            YLAccount *account = [YLAccount accountWithDict:responseObject[@"data"]];
            [YLAccountTool saveAccount:account];
            [NSString showMessageWithString:responseObject[@"message"]];
            YLHomeController *home = [[YLHomeController alloc] init];
            YLNavigationController *nav = [[YLNavigationController alloc] initWithRootViewController:home];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        } else {
            [NSString showMessageWithString:responseObject[@"message"]];
        }
    } failed:nil];
}

@end
