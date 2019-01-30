//
//  YLDetailController.m
//  YLYouCarServer
//
//  Created by lm on 2018/11/28.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLDetailController.h"
#import "YLDetailView.h"
#import "YLCarStatusView.h"
#import "YLRemarkView.h"
#import "YLInputMessageController.h"
#import "YLDetailModel.h"
#import "YLRequest.h"
#import "YLChangeMessageController.h"

#define YLDetailPath(detailId) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:detailId]
#define YLCheckTimePath(detailId) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"CheckTime-%@", detailId]]

@interface YLDetailController () <YLCarStatusViewDelegate>

@property (nonatomic, strong) YLDetailModel *carDetailModel;
@property (nonatomic, strong) YLAllOrderModel *detailModel;

@property (nonatomic, strong) YLDetailView *detailView;
@property (nonatomic, strong) YLCarStatusView *carStatusView;
@property (nonatomic, strong) YLRemarkView *remarkView;

@end

@implementation YLDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"订单详情";
    
    [self setNav];
    [self setupUI];
    
    [self getLoactionData];
    [self loadData];
}

- (void)loadData {
    
    // 获取车辆详情
    NSString *urlString = @"http://ucarjava.bceapp.com/sell?method=record";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.model.detailId forKey:@"detailId"];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            NSLog(@"请求成功");
            [weakSelf keyedArchiverObject:responseObject toFile:YLDetailPath(weakSelf.model.detailId)];
            [weakSelf getLoactionData];
        }
    } failed:nil];
}

- (void)getLoactionData {
    
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLDetailPath(self.model.detailId)];
    self.detailModel = [YLAllOrderModel mj_objectWithKeyValues:dict[@"data"]];
    self.detailView.model = self.detailModel;
    self.carStatusView.model = self.detailModel;
    self.remarkView.model = self.detailModel;
}

- (void)keyedArchiverObject:(id)obj toFile:(NSString *)filePath {
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    if (success) {
        NSLog(@"数据保存成功");
    } else {
        NSLog(@"保存失败");
    }
}

- (void)setupUI {
    
    YLDetailView *detail = [[YLDetailView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, 197)];
    [self.view addSubview:detail];
    self.detailView = detail;
    
    YLCarStatusView *carStatus = [[YLCarStatusView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detail.frame), YLScreenWidth, 85 + 30)];
    carStatus.delegate = self;
    [self.view addSubview:carStatus];
    self.carStatusView = carStatus;
    
    YLRemarkView *remark = [[YLRemarkView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(carStatus.frame), YLScreenWidth, 120 + 160 + 15)];
    [self.view addSubview:remark];
    self.remarkView = remark;
}

- (void)setNav {
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"录入验车信息" style:UIBarButtonItemStylePlain target:self action:@selector(inputInformation)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)inputInformation {
    
    NSLog(@"录入验车信息");
//    YLInputMessageController *input = [[YLInputMessageController alloc] init];
//    input.allOrderModel = self.detailModel; // 为了获取detailID
//    [self.navigationController pushViewController:input animated:YES];
    
    YLChangeMessageController *change = [[YLChangeMessageController alloc] init];
    change.allOrderModel = self.detailModel;
    [self.navigationController pushViewController:change animated:YES];
}

#pragma mark 代理
- (void)changeCarState:(NSString *)state {
    NSLog(@"changeCarState:%@", state);
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.detailsLabel.text = @"正在修改车辆状态,请稍后";
    [hub showAnimated:YES];
    [self.view addSubview:hub];
    
    NSString *urlString = @"http://ucarjava.bceapp.com/sell?method=handle";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.detailModel.detailId forKey:@"detailId"];
    [param setObject:self.detailModel.name forKey:@"name"];
    [param setObject:self.detailModel.remarks forKey:@"remarks"];
    [param setObject:state forKey:@"status"];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
//            NSLog(@"请求成功");
            [weakSelf loadData];
            [NSString showMessageWithString:@"状态修改成功"];
            [hub removeFromSuperview];
        } else {
            NSLog(@"%@", responseObject[@"message"]);
            [hub removeFromSuperview];
        }
    } failed:nil];
}

@end
