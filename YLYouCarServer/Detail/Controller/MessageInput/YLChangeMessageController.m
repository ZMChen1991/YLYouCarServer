//
//  YLChangeMessageController.m
//  YLYouCarServer
//
//  Created by lm on 2019/1/12.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLChangeMessageController.h"
#import "YLMessageModel.h"
#import "YLSaleCarChoiceCell.h"
#import "YLSaleCarWriteCell.h"
#import "YLTransferView.h"
#import "YLColorView.h"
#import "YLYearMonthPicker.h"
#import "YLMessageChoiceCell.h"
#import "YLRequest.h"
#import "YLDetailModel.h"
#import "YLMessageFooterView.h"
#import "YLMessageHeaderView.h"
#import "YLImageUploadController.h"

#define YLCheckCarMessagePath(detailId) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"CheckTime-%@", detailId]]

@interface YLChangeMessageController () <UITableViewDelegate, UITableViewDataSource, YLMessageFooterViewDelegate>

@property (nonatomic, strong) NSMutableArray *params;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) YLDetailModel *messageModel;

@property (nonatomic, strong) YLMessageFooterView *footer;
@property (nonatomic, strong) YLMessageHeaderView *header;

@property (nonatomic, assign) BOOL isBargain;
@property (nonatomic, strong) NSString *remarks;

@property (nonatomic, strong) YLMessageModel *isBargainModel;
@property (nonatomic, strong) YLMessageModel *remarksModel;

@end

@implementation YLChangeMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"录入车辆信息";
    
    [self createTableView];
    [self yl__initData];
    [self loadData];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    // 录入验车信息
    NSString *urlString1 = [NSString stringWithFormat:@"%@/sell?method=info", YLCommandUrl];
    NSMutableDictionary *param1 = [NSMutableDictionary dictionary];
    [param1 setObject:self.allOrderModel.detail.carID forKey:@"id"];
    [YLRequest GET:urlString1 parameters:param1 success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            NSLog(@"请求成功");
            [weakSelf keyedArchiverObject:responseObject toFile:YLCheckCarMessagePath(weakSelf.allOrderModel.detail.carID)];
            [weakSelf getCheckCarMessage];
        }
    } failed:nil];
}

- (void)getCheckCarMessage {
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLCheckCarMessagePath(self.allOrderModel.detail.carID)];
    self.messageModel = [YLDetailModel mj_objectWithKeyValues:dict[@"data"]];
    self.header.title = self.messageModel.title;
    self.footer.detailModel = self.messageModel;
    NSLog(@"%@", self.messageModel);
    
    NSArray *arr = self.params[0];
    
    if (![self.messageModel.location isEqualToString:@""]) {
        for (YLMessageModel *model in arr) {
            if ([model.key isEqualToString:@"location"] ) {
                model.param = self.messageModel.location;
            }
        }
    }
    
    if (![self.messageModel.licenseTime isEqualToString:@""]) {
        for (YLMessageModel *model in arr) {
            if ([model.key isEqualToString:@"licenseTime"] ) {
                model.param = self.messageModel.licenseTime;
            }
        }
    }
    
    if (![self.messageModel.course isEqualToString:@""]) {
        for (YLMessageModel *model in arr) {
            if ([model.key isEqualToString:@"course"] ) {
                model.param = self.messageModel.course;
            }
        }
    }
    
    if (![self.messageModel.transfer isEqualToString:@""]) {
        for (YLMessageModel *model in arr) {
            if ([model.key isEqualToString:@"transfer"] ) {
                model.param = self.messageModel.transfer;
            }
        }
    }
    
    if (![self.messageModel.annualInspection isEqualToString:@""]) {
        for (YLMessageModel *model in arr) {
            if ([model.key isEqualToString:@"annualInspection"] ) {
                model.param = self.messageModel.annualInspection;
            }
        }
    }
    
    if (![self.messageModel.trafficInsurance isEqualToString:@""]) {
        for (YLMessageModel *model in arr) {
            if ([model.key isEqualToString:@"trafficInsurance"] ) {
                model.param = self.messageModel.trafficInsurance;
            }
        }
    }
    
    if (![self.messageModel.commercialInsurance isEqualToString:@""]) {
        for (YLMessageModel *model in arr) {
            if ([model.key isEqualToString:@"commercialInsurance"] ) {
                model.param = self.messageModel.commercialInsurance;
            }
        }
    }
    
    if (![self.messageModel.color isEqualToString:@""]) {
        for (YLMessageModel *model in arr) {
            if ([model.key isEqualToString:@"color"] ) {
                model.param = self.messageModel.color;
            }
        }
    }
    
    NSArray *arr1 = self.params[2];
    if (![self.messageModel.license isEqualToString:@""]) {
        for (YLMessageModel *model in arr1) {
            if ([model.key isEqualToString:@"license"] ) {
                model.param = self.messageModel.license;
            }
        }
    }
    
    if (![self.messageModel.vehicle isEqualToString:@""]) {
        for (YLMessageModel *model in arr1) {
            if ([model.key isEqualToString:@"vehicle"] ) {
                model.param = self.messageModel.vehicle;
            }
        }
    }
    
    if (![self.messageModel.blemish isEqualToString:@""]) {
        for (YLMessageModel *model in arr1) {
            if ([model.key isEqualToString:@"blemish"] ) {
                model.param = self.messageModel.blemish;
            }
        }
    }
    
    NSArray *arr2 = self.params[3];
    if (![self.messageModel.price isEqualToString:@""]) {
        for (YLMessageModel *model in arr2) {
            if ([model.key isEqualToString:@"price"] ) {
                NSString *price = [NSString stringWithFormat:@"%ld", [self.messageModel.price integerValue] / 10000];
                model.param = price;
            }
        }
    }
    
    if (![self.messageModel.floorPrice isEqualToString:@""]) {
        for (YLMessageModel *model in arr2) {
            if ([model.key isEqualToString:@"floorPrice"] ) {
                NSString *floorPrice = [NSString stringWithFormat:@"%ld", [self.messageModel.floorPrice integerValue] / 10000];
                model.param = floorPrice;
            }
        }
    }
    
    YLMessageModel *isBargainModel = [[YLMessageModel alloc] init];
    isBargainModel.title = @"议价";
    isBargainModel.param = self.messageModel.isBargain;
    isBargainModel.key = @"isBargain";
    self.isBargainModel = isBargainModel;
    
    YLMessageModel *remarksModel = [[YLMessageModel alloc] init];
    remarksModel.title = @"备注";
    remarksModel.param = self.messageModel.remarks;
    remarksModel.key = @"remarks";
    self.remarksModel = remarksModel;
    
    [self.tableView reloadData];
    NSLog(@"%@", self.messageModel);
}

- (void)keyedArchiverObject:(id)obj toFile:(NSString *)filePath {
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    if (success) {
        NSLog(@"数据保存成功");
    } else {
        NSLog(@"保存失败");
    }
}

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, YLScreenHeight - 64)];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    YLMessageHeaderView *header = [[YLMessageHeaderView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, 60)];
    self.tableView.tableHeaderView = header;
    self.header = header;
    
    YLMessageFooterView *footer = [[YLMessageFooterView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, 300)];
    footer.delegate = self;
    __weak typeof(self) weakSelf = self;
    footer.isBargainBlock = ^(NSString * _Nonnull isBargain) {
        weakSelf.isBargainModel.param = isBargain;
    };
    footer.remarksBlock = ^(NSString * _Nonnull remarks) {
        weakSelf.remarksModel.param = remarks;
    };
    self.tableView.tableFooterView = footer;
    self.footer = footer;
}

- (void)commitMessage {
    NSLog(@"commitMessage");
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.allOrderModel.detailId forKey:@"detailId"];
    [param setObject:self.messageModel.typeId forKey:@"typeId"];
    [param setObject:@"2" forKey:@"status"];
    for (NSInteger i = 0; i < self.params.count; i++) {
        NSArray *arr = self.params[i];
        for (YLMessageModel *model in arr) {
            if ([model.key isEqualToString:@"price"]) {
                NSString *price = [NSString stringWithFormat:@"%ld", [model.param integerValue] * 10000];
                [param setObject:price forKey:model.key];
            } else if ([model.key isEqualToString:@"floorPrice"]) {
                NSString *floorPrice = [NSString stringWithFormat:@"%ld", [model.param integerValue] * 10000];
                [param setObject:floorPrice forKey:model.key];
            } else {
                [param setObject:model.param forKey:model.key];
            }
            
        }
    }
     NSLog(@"%@", param);
    [param setObject:self.isBargainModel.param forKey:self.isBargainModel.key];
    [param setObject:self.remarksModel.param forKey:self.remarksModel.key];
    
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.detailsLabel.text = @"正在提交,请稍后";
    [hub showAnimated:YES];
    [self.view addSubview:hub];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/sell?method=write", YLCommandUrl];
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [hub removeFromSuperview];
            [NSString showMessageWithString:@"提交成功"];
            
        } else {
            NSString *error = responseObject[@"message"];
            [hub removeFromSuperview];
            [NSString showMessageWithString:error];
            
        }
        
    } failed:nil];
}

- (void)saveMessage {
    NSLog(@"saveMessage");
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.allOrderModel.detailId forKey:@"detailId"];
    [param setObject:self.messageModel.typeId forKey:@"typeId"];
    [param setObject:@"1" forKey:@"status"];
    for (NSInteger i = 0; i < self.params.count; i++) {
        NSArray *arr = self.params[i];
        for (YLMessageModel *model in arr) {
            if ([model.key isEqualToString:@"price"]) {
                NSString *price = [NSString stringWithFormat:@"%ld", [model.param integerValue] * 10000];
                [param setObject:price forKey:model.key];
            } else if ([model.key isEqualToString:@"floorPrice"]) {
                NSString *floorPrice = [NSString stringWithFormat:@"%ld", [model.param integerValue] * 10000];
                [param setObject:floorPrice forKey:model.key];
            } else {
                [param setObject:model.param forKey:model.key];
            }
            
        }
    }
    NSLog(@"%@", param);
    [param setObject:self.isBargainModel.param forKey:self.isBargainModel.key];
    [param setObject:self.remarksModel.param forKey:self.remarksModel.key];
    
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.detailsLabel.text = @"正在提交,请稍后";
    [hub showAnimated:YES];
    [self.view addSubview:hub];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/sell?method=write", YLCommandUrl];
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [hub removeFromSuperview];
            [NSString showMessageWithString:@"提交成功"];
            
        } else {
            NSString *error = responseObject[@"message"];
            [hub removeFromSuperview];
            [NSString showMessageWithString:error];
            
        }
        
    } failed:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.params.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.params[section] count];
}

#pragma mark 循环利用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLMessageModel *model = self.params[indexPath.section][indexPath.row];
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 2) {
            YLSaleCarWriteCell *cell = [YLSaleCarWriteCell cellWithTableView:tableView];
            cell.writeBlock = ^(NSString * _Nonnull detailTitle) {
                model.param = detailTitle;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            YLSaleCarChoiceCell *cell = [YLSaleCarChoiceCell cellWithTableView:tableView];
            cell.choiceBlock = ^{
                UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
                UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, YLScreenHeight)];
                cover.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
                [window addSubview:cover];
                if (indexPath.row == 7) {
                    YLColorView *colorView = [[YLColorView alloc] initWithFrame:CGRectMake(0, 200, YLScreenWidth, 259)];
                    colorView.cancelBlock = ^{
                        [cover removeFromSuperview];
                    };
                    colorView.colorBlock = ^(NSString * _Nonnull color) {
                        model.param = color;
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [cover removeFromSuperview];
                    };
                    [cover addSubview:colorView];
                } else if (indexPath.row == 3) {
                    YLTransferView *transfer = [[YLTransferView alloc] initWithFrame:CGRectMake(0, 200, YLScreenWidth, 259)];
                    transfer.cancelBlock = ^{
                        [cover removeFromSuperview];
                    };
                    transfer.transferBlock = ^(NSString * _Nonnull transfer) {
                        NSLog(@"transfer:%@次", transfer);
                        model.param = transfer;
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [cover removeFromSuperview];
                    };
                    [cover addSubview:transfer];
                    
                } else {
                    
                    YLYearMonthPicker *picker = [[YLYearMonthPicker alloc] initWithFrame:CGRectMake(0, 250, YLScreenWidth, 150)];
                    if (indexPath.row == 1) {
                        picker.type = YLYearMonthTypeBefore;
                    } else {
                        picker.type = YLYearMonthTypeFuture;
                    }
                    picker.cancelBlock = ^{
                        [cover removeFromSuperview];
                    };
                    picker.sureBlock = ^(NSString * _Nonnull licenseTime) {
                        NSLog(@"licenseTime:%@", licenseTime);
                        model.param = licenseTime;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [cover removeFromSuperview];
                    };
                    [cover addSubview:picker];
                }
            };
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else if (indexPath.section == 3) {
        YLSaleCarWriteCell *cell = [YLSaleCarWriteCell cellWithTableView:tableView];
        cell.writeBlock = ^(NSString * _Nonnull detailTitle) {
            model.param = detailTitle;
        };
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        YLSaleCarChoiceCell *cell = [YLSaleCarChoiceCell cellWithTableView:tableView];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        YLImageUploadController *imageUpload = [[YLImageUploadController alloc] init];
        imageUpload.allOrderModel = self.allOrderModel;
        if (indexPath.row == 0) {
            imageUpload.title = @"证件图片";
            imageUpload.group = @"license";
            imageUpload.type = YLImageControllerTypeLicense;
        } else if (indexPath.row == 1) {
            imageUpload.title = @"细节图片";
            imageUpload.group = @"vehicle";
            imageUpload.type = YLImageControllerTypeVehicle;
        } else {
            imageUpload.title = @"瑕疵图片";
            imageUpload.group = @"blemish";
            imageUpload.type = YLImageControllerTypeBlemishs;
        }
        [self.navigationController pushViewController:imageUpload animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.groups[section];
}

- (void)yl__initData {

    NSArray *titles = @[@[@"车牌所在地",@"上牌时间",@"表显里程(单位:万公里)",@"过户次数(单位:次)",@"年检到期",@"交强险到期",@"商业险到期",@"车身颜色"],
                    @[@"内饰", @"外观", @"底盘", @"车身骨架", @"电子设备", @"发动机舱"],
                    @[@"证件图片(单位:张)",@"细节图片(单位:张)",@"瑕疵图片(单位:张)"],
                    @[@"卖家定价(单位:万)",@"卖家底价(单位:万)"]];
    
    NSArray *keys = @[@[@"location",@"licenseTime",@"course",@"transfer",@"annualInspection",@"trafficInsurance",@"commercialInsurance",@"color"],
                      @[@"interior", @"appearance", @"chassis", @"body", @"electronics", @"engine"],
                      @[@"license",@"vehicle",@"blemish"],
                      @[@"price",@"floorPrice"]];
    
    NSArray *details = @[@[@"请输入",@"请选择",@"请输入",@"0次",@"请选择",@"请选择",@"请选择",@"请选择"],
                         @[@"0",@"0",@"0",@"0",@"0",@"0"],
                         @[@"0",@"0",@"0"],
                         @[@"请输入",@"请输入"]];
    self.groups = @[@"基本信息", @"车辆状况", @"相关图片", @"价格"];
    for (NSInteger i = 0; i < titles.count; i++) {
        NSArray *arr = titles[i];
        NSArray *key = keys[i];
        NSArray *detail = details[i];
        NSMutableArray *models = [NSMutableArray array];
        for (NSInteger j = 0; j < arr.count; j++) {
            YLMessageModel *model = [[YLMessageModel alloc] init];
            model.title = arr[j];
            model.key = key[j];
            model.param = detail[j];
            [models addObject:model];
        }
        [self.params addObject:models];
    }
    
    
    
    [self.tableView reloadData];
}

- (NSMutableArray *)params {
    if (!_params) {
        _params = [NSMutableArray array];
    }
    return _params;
}

@end
