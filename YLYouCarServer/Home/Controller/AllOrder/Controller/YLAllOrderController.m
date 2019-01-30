//
//  YLAllOrderController.m
//  YLYouCarServer
//
//  Created by lm on 2018/11/28.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLAllOrderController.h"
#import "YLAllOrderCell.h"
#import "YLDetailController.h"
#import "YLRequest.h"
#import "YLAccount.h"
#import "YLAccountTool.h"
#import "YLAllOrderModel.h"
#import "YLAllOrderCellFrame.h"

#define YLAllOrderPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"AllOrder.text"]

@interface YLAllOrderController ()

@property (nonatomic, strong) NSMutableArray *allOrders;

@end

@implementation YLAllOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    self.tableView.frame = CGRectMake(0, 0, YLScreenWidth, YLScreenHeight - 50 - 64);
    
    [self getLoactionData];
    [self loadData];
    
}


- (void)loadData {
    
    YLAccount *account = [YLAccountTool account];
    NSString *urlString = [NSString stringWithFormat:@"%@/sell?method=list", YLCommandUrl];
//    NSString *urlString = @"http://ucarjava.bceapp.com/sell?method=list";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.centerId forKey:@"centerId"];
    [param setValue:@"" forKey:@"status"];
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            NSLog(@"请求成功");
            [self keyedArchiverObject:responseObject toFile:YLAllOrderPath];
            [self getLoactionData];
            
        }
    } failed:nil];
}

- (void)getLoactionData {
    
    [self.allOrders removeAllObjects];
    
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLAllOrderPath];
    NSArray *allOrder = [YLAllOrderModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    for (YLAllOrderModel *model in allOrder) {
        YLAllOrderCellFrame *cellFrame = [[YLAllOrderCellFrame alloc] init];
        cellFrame.model = model;
        [self.allOrders addObject:cellFrame];
    }
    [self.tableView reloadData];
}

- (void)keyedArchiverObject:(id)obj toFile:(NSString *)filePath {
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    if (success) {
        NSLog(@"数据保存成功");
    } else {
        NSLog(@"保存失败");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allOrders.count;
}

#pragma mark 循环利用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLAllOrderCell *cell = [YLAllOrderCell cellWithTableView:tableView];
    YLAllOrderCellFrame *cellFrame = self.allOrders[indexPath.row];
    cell.cellFrame = cellFrame;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLAllOrderCellFrame *cellFrame = self.allOrders[indexPath.row];
    return cellFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"跳转订单详情");
    YLAllOrderCellFrame *cellFrame = self.allOrders[indexPath.row];
    YLAllOrderModel *model = cellFrame.model;
    YLDetailController *detailVC = [[YLDetailController alloc] init];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSMutableArray *)allOrders {
    if (!_allOrders) {
        _allOrders = [NSMutableArray array];
    }
    return _allOrders;
}

@end
