//
//  YLInputMessageController.m
//  YLYouCarServer
//
//  Created by lm on 2018/12/4.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLInputMessageController.h"
#import "YLMessageHeaderView.h"
#import "YLMessageFooterView.h"
#import "YLRequest.h"
#import "YLImageUploadController.h"
#import "YLImageModel.h"
#import "YLChangeMessageController.h"
#import "YLSaleCarWriteCell.h"
#import "YLSaleCarChoiceCell.h"
#import "YLYearMonthPicker.h"
#import "YLDetailModel.h"
#import "YLTransferView.h"
#import "YLColorView.h"
#import "YLMessageModel.h"

#define YLCheckTimePath(detailId) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"CheckTime-%@", detailId]]

#define YLCertificatePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"certificate.txt"]

#define YLDetailImagePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"detailImage.txt"]

#define YLBlemishPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"blemish.txt"]


@interface YLInputMessageController () <YLMessageFooterViewDelegate>

@property (nonatomic, strong) NSArray *titles; // 左标题
@property (nonatomic, strong) NSArray *groupTitles; // 组头标题
@property (nonatomic, strong) NSMutableArray *detailTitles;// 右详情

@property (nonatomic, strong) NSMutableArray *certificates;
@property (nonatomic, strong) NSMutableArray *detailImages;

@property (nonatomic, strong) NSArray *licenses;// 证件
@property (nonatomic, strong) NSArray *vehicles;// 细节
@property (nonatomic, strong) NSArray *blemishs;// 瑕疵

@property (nonatomic, strong) YLMessageFooterView *footer;
@property (nonatomic, strong) YLMessageHeaderView *header;

@property (nonatomic, strong) NSMutableArray *params;
@property (nonatomic, strong) YLDetailModel *detailModel;

@end

@implementation YLInputMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车辆信息";
    
    self.titles = @[@[@"车牌所在地",@"上牌时间",@"表显里程(单位:万公里)",@"过户次数(单位:次)",@"年检到期",@"交强险到期",@"商业险到期",@"车身颜色"],
                    @[@"内饰", @"外观", @"底盘", @"车身骨架", @"电子设备", @"发动机舱"],
                    @[@"证件图片(单位:张)",@"细节图片(单位:张)",@"瑕疵图片(单位:张)"],
                    @[@"卖家定价(单位:万)",@"卖家底价(单位:万)"]];

    self.groupTitles = @[@"基本信息", @"车辆状况", @"相关图片", @"价格"];
    [self setupUI];
    [self loadDate];
}

- (void)yl__initData {
    
    self.titles = @[@[@"车牌所在地",@"上牌时间",@"表显里程(单位:万公里)",@"过户次数(单位:次)",@"年检到期",@"交强险到期",@"商业险到期",@"车身颜色"],
                    @[@"内饰", @"外观", @"底盘", @"车身骨架", @"电子设备", @"发动机舱"],
                    @[@"证件图片(单位:张)",@"细节图片(单位:张)",@"瑕疵图片(单位:张)"],
                    @[@"卖家定价(单位:万)",@"卖家底价(单位:万)"]];
    
    NSArray *keys = @[@[@"localtion",@"上licenseTime",@"course",@"transfer",@"annualInspection",@"trafficInsurance",@"commercialInsurance",@"color"],
                      @[@"interior", @"appearance", @"chassis", @"body", @"electronics", @"发动机舱"],
                      @[@"license",@"vechile",@"blemish"],
                      @[@"price",@"floorPrice"]];
    NSArray *details = @[@[@"请输入",@"请选择",@"请输入",@"0次",@"请选择",@"请选择",@"请选择",@"请选择"],
                         @[@"0",@"0",@"0",@"0",@"0",@"0"],
                         @[@"0",@"0",@"0"],
                         @[@"请输入",@"请输入"]];
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        NSArray *arr = self.titles[i];
        NSArray *key = keys[i];
        NSArray *detail = details[i];
        for (NSInteger j = 0; j < arr.count; j++) {
            YLMessageModel *model = [[YLMessageModel alloc] init];
            model.title = arr[j];
            model.key = key[j];
            model.param = detail[j];
        }
    }
}

- (void)loadDate {
    
    __weak typeof(self) weakSelf = self;
    // 录入验车信息
    NSString *urlString1 = @"http://ucarjava.bceapp.com/sell?method=info";
    NSMutableDictionary *param1 = [NSMutableDictionary dictionary];
    [param1 setObject:self.allOrderModel.detail.carID forKey:@"id"];
    [YLRequest GET:urlString1 parameters:param1 success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            NSLog(@"请求成功");
            [weakSelf keyedArchiverObject:responseObject toFile:YLCheckTimePath(weakSelf.allOrderModel.detail.carID)];
            [weakSelf getDetailData];
        }
    } failed:nil];
    
//    // 获取图片
//    // license证件 vehicle车身 blemish瑕疵 video视频 必传
//    NSString *urlString = @"http://ucarjava.bceapp.com/image?method=list";
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:self.allOrderModel.detailId forKey:@"detailId"];
//    [param setObject:@"license" forKey:@"group"];
//    __weak typeof(self) weakSelf = self;
//    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
//        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
//            [weakSelf keyedArchiverObject:responseObject toFile:YLCertificatePath];
//            [weakSelf getLoactionData];
//        } else {
//            NSLog(@"%@", responseObject[@"message"]);
//        }
//    } failed:nil];
//
//    NSMutableDictionary *param1 = [NSMutableDictionary dictionary];
//    [param1 setObject:self.allOrderModel.detailId forKey:@"detailId"];
//    [param1 setObject:@"vehicle" forKey:@"group"];
//    [YLRequest GET:urlString parameters:param1 success:^(id  _Nonnull responseObject) {
//        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
//            [weakSelf keyedArchiverObject:responseObject toFile:YLDetailImagePath];
//            [weakSelf getVehicle];
//        } else {
//            NSLog(@"%@", responseObject[@"message"]);
//        }
//    } failed:nil];
//
//    NSMutableDictionary *param2 = [NSMutableDictionary dictionary];
//    [param2 setObject:self.allOrderModel.detailId forKey:@"detailId"];
//    [param2 setObject:@"blemish" forKey:@"group"];
//    [YLRequest GET:urlString parameters:param2 success:^(id  _Nonnull responseObject) {
//        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
//            [weakSelf keyedArchiverObject:responseObject toFile:YLBlemishPath];
//            [weakSelf getBlemish];
//        } else {
//            NSLog(@"%@", responseObject[@"message"]);
//        }
//    } failed:nil];
    
}

// 获取车辆具体详情配置
- (void)getDetailData {
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLCheckTimePath(self.allOrderModel.detail.carID)];
    YLDetailModel *model = [YLDetailModel mj_objectWithKeyValues:dict[@"data"]];
    self.detailModel = model;
    // 替换右标题详情
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.detailTitles[0]];
    if (model.location) {
        [arr replaceObjectAtIndex:0 withObject:model.location];
    }
    if (![model.licenseTime isEqualToString:@""]) {
        [arr replaceObjectAtIndex:1 withObject:model.licenseTime];
    }
    if (![model.course isEqualToString:@""]) {
        [arr replaceObjectAtIndex:2 withObject:model.course];
    }
    if (![model.transfer isEqualToString:@""]) {
        NSLog(@"model.transfer:%@", model.transfer);
        [arr replaceObjectAtIndex:3 withObject:model.transfer];
    }
    if (![model.annualInspection isEqualToString:@""]) {
        [arr replaceObjectAtIndex:4 withObject:model.annualInspection];
    }
    if (![model.trafficInsurance isEqualToString:@""]) {
        [arr replaceObjectAtIndex:5 withObject:model.trafficInsurance];
    }
    if (![model.commercialInsurance isEqualToString:@""]) {
        [arr replaceObjectAtIndex:6 withObject:model.commercialInsurance];
    }
    if (![model.color isEqualToString:@""]) {
        [arr replaceObjectAtIndex:7 withObject:model.color];
    }
    [self.detailTitles replaceObjectAtIndex:0 withObject:arr];
    
    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:self.detailTitles[2]];
    if (![model.license isEqualToString:@""]) {
         [arr1 replaceObjectAtIndex:0 withObject:model.license];
    }
    if (![model.vehicle isEqualToString:@""]) {
        [arr1 replaceObjectAtIndex:1 withObject:model.vehicle];
    }
    if (![model.blemish isEqualToString:@""]) {
        [arr1 replaceObjectAtIndex:2 withObject:model.blemish];
    }
    [self.detailTitles replaceObjectAtIndex:2 withObject:arr1];
    
    NSMutableArray *arr2 = [NSMutableArray arrayWithArray:self.detailTitles[3]];
    if (![model.price isEqualToString:@""]) {
        NSString *price = [NSString stringWithFormat:@"%ld", [model.price integerValue] / 10000];
        [arr2 replaceObjectAtIndex:0 withObject:price];
    }
    if (![model.floorPrice isEqualToString:@""]) {
        NSString *floorPrice = [NSString stringWithFormat:@"%ld", [model.floorPrice integerValue] / 10000];
        [arr2 replaceObjectAtIndex:1 withObject:floorPrice];
    }
    [self.detailTitles replaceObjectAtIndex:3 withObject:arr2];
    [self.tableView reloadData];
    
    self.header.title = model.title;
    self.footer.detailModel = model;
}

- (void)getLoactionData {
    
    NSDictionary *dict1 = [NSKeyedUnarchiver unarchiveObjectWithFile:YLCertificatePath];
    self.licenses = [YLImageModel mj_objectArrayWithKeyValuesArray:dict1[@"data"]];
    NSLog(@"%ld", self.licenses.count);
}

- (void)getVehicle {
    NSDictionary *dict2 = [NSKeyedUnarchiver unarchiveObjectWithFile:YLDetailImagePath];
    self.vehicles = [YLImageModel mj_objectArrayWithKeyValuesArray:dict2[@"data"]];
    NSLog(@"%ld", self.vehicles.count);
}

- (void)getBlemish {
    NSDictionary *dict3 = [NSKeyedUnarchiver unarchiveObjectWithFile:YLBlemishPath];
    self.blemishs = [YLImageModel mj_objectArrayWithKeyValuesArray:dict3[@"data"]];
    NSLog(@"%ld", self.blemishs.count);
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
    
    YLMessageHeaderView *header = [[YLMessageHeaderView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, 60)];
    self.tableView.tableHeaderView = header;
    self.header = header;
    
    YLMessageFooterView *footer = [[YLMessageFooterView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, 300)];
    footer.delegate = self;
    self.tableView.tableFooterView = footer;
    self.footer = footer;
}

#pragma mark YLMessageFooterViewDelegate
- (void)commitMessage {
    NSLog(@"提交验车信息");
}
- (void)saveMessage {
    NSLog(@"保存验车信息");
//    NSString *urlString = @"ucarjava.bceapp.com/sell?method=write&detailId=xxx&typeId=xxx&licenseTime=xxx&location=xxx&course=xxx&transfer=xxx&annualInspection=xxx&trafficInsurance=xxx&commercialInsurance=xxx&color=xxx&price=xxx&floorPrice=xxx&isBargain=xxx&status=xxx";
    NSString *urlString = [NSString stringWithFormat:@"%@/sell?method=write", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.allOrderModel.detailId forKey:@"detailId"];
    [param setObject:self.detailModel.typeId forKey:@"typeId"];
    [param setObject:self.allOrderModel.status forKey:@"status"];
    // 判断self.detailTitles其他值是否为空或者是请选择或者是请输入
    for (NSInteger i = 0; i < self.detailTitles.count; i++) {
        if (i == 2) {
            break;
        }
        NSArray *arr = self.detailTitles[i];
        for (NSInteger j = 0; j < arr.count; j++) {
            if (arr) {
                
            }
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 2) {
            YLSaleCarWriteCell *cell = [YLSaleCarWriteCell cellWithTableView:tableView];
            cell.writeBlock = ^(NSString * _Nonnull detailTitle) {
                NSLog(@"detailTitle:%@", detailTitle);
                NSMutableArray *arr = [NSMutableArray arrayWithArray:self.detailTitles[indexPath.section]];
                if (![detailTitle isEqualToString:@""]) {
                    [arr replaceObjectAtIndex:indexPath.row withObject:detailTitle];
                } else {
                    [arr replaceObjectAtIndex:indexPath.row withObject:@"请输入"];
                }
                [self.detailTitles replaceObjectAtIndex:indexPath.section withObject:arr];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            cell.title = self.titles[indexPath.section][indexPath.row];
            cell.detailTitle = self.detailTitles[indexPath.section][indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            YLSaleCarChoiceCell *cell = [YLSaleCarChoiceCell cellWithTableView:tableView];
            cell.choiceBlock = ^{
                UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
                UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, YLScreenHeight)];
                cover.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
                [window addSubview:cover];
                if (indexPath.row == 3) {
                    YLTransferView *transfer = [[YLTransferView alloc] initWithFrame:CGRectMake(0, 200, YLScreenWidth, 259)];
                    transfer.cancelBlock = ^{
                        [cover removeFromSuperview];
                    };
                    transfer.transferBlock = ^(NSString * _Nonnull transfer) {
                        NSLog(@"transfer:%@次", transfer);
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.detailTitles[indexPath.section]];
                        [arr replaceObjectAtIndex:indexPath.row withObject:transfer];
                        [self.detailTitles replaceObjectAtIndex:indexPath.section withObject:arr];
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        
                        [cover removeFromSuperview];
                    };
                    [cover addSubview:transfer];
                } else if (indexPath.row == 7) {
                    YLColorView *colorView = [[YLColorView alloc] initWithFrame:CGRectMake(0, 200, YLScreenWidth, 259)];
                    colorView.cancelBlock = ^{
                        [cover removeFromSuperview];
                    };
                    colorView.colorBlock = ^(NSString * _Nonnull color) {
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.detailTitles[indexPath.section]];
                        [arr replaceObjectAtIndex:indexPath.row withObject:color];
                        [self.detailTitles replaceObjectAtIndex:indexPath.section withObject:arr];
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        
                        [cover removeFromSuperview];
                    };
                    [cover addSubview:colorView];
                } else {
                    YLYearMonthPicker *picker = [[YLYearMonthPicker alloc] initWithFrame:CGRectMake(0, 250, YLScreenWidth, 150)];
                    picker.cancelBlock = ^{
                        [cover removeFromSuperview];
                    };
                    picker.sureBlock = ^(NSString * _Nonnull licenseTime) {
                        NSLog(@"licenseTime:%@", licenseTime);
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.detailTitles[indexPath.section]];
                        [arr replaceObjectAtIndex:indexPath.row withObject:licenseTime];
                        [self.detailTitles replaceObjectAtIndex:indexPath.section withObject:arr];
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [cover removeFromSuperview];
                    };
                    [cover addSubview:picker];
                }
                
            };
//            cell.title = self.titles[indexPath.section][indexPath.row];
//            cell.detailTitle = self.detailTitles[indexPath.section][indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else if (indexPath.section == 1) {
        static NSString *ID = @"YLInputMessageController";
        // 1.拿到一个标识先去缓存池中查找对应的cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 2.如果缓存池中没有，才需要传入一个标识创新的cell
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = YLColor(51.f, 51.f, 51.f);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = YLColor(51.f, 51.f, 51.f);
        cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
        NSLog(@"%ld--%ld", indexPath.section, indexPath.row);
        if (self.detailTitles[indexPath.section][indexPath.row]) {
            cell.detailTextLabel.text = self.detailTitles[indexPath.section][indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2) {
        static NSString *ID = @"YLInputMessageController";
        // 1.拿到一个标识先去缓存池中查找对应的cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 2.如果缓存池中没有，才需要传入一个标识创新的cell
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = YLColor(51.f, 51.f, 51.f);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = YLColor(51.f, 51.f, 51.f);
        cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
        if (self.detailTitles[indexPath.section][indexPath.row]) {
            cell.detailTextLabel.text = self.detailTitles[indexPath.section][indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        YLSaleCarWriteCell *cell = [YLSaleCarWriteCell cellWithTableView:tableView];
        cell.writeBlock = ^(NSString * _Nonnull detailTitle) {
            NSLog(@"detailTitle:%@", detailTitle);
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.detailTitles[indexPath.section]];
            if (![detailTitle isEqualToString:@""]) {
                [arr replaceObjectAtIndex:indexPath.row withObject:detailTitle];
            } else {
                [arr replaceObjectAtIndex:indexPath.row withObject:@"请输入"];
            }
            [self.detailTitles replaceObjectAtIndex:indexPath.section withObject:arr];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        cell.title = self.titles[indexPath.section][indexPath.row];
        cell.detailTitle = self.detailTitles[indexPath.section][indexPath.row];
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
    return self.groupTitles[section];
}

- (NSMutableArray *)detailTitles {
    if (!_detailTitles) {
        _detailTitles = [NSMutableArray arrayWithArray:@[@[@"请输入",@"请选择",@"请输入",@"0次",@"请选择",@"请选择",@"请选择",@"请选择"],
                                                         @[@"0",@"0",@"0",@"0",@"0",@"0"],
                                                         @[@"0",@"0",@"0"],
                                                         @[@"请输入",@"请输入"]]];
    }
    return _detailTitles;
}

- (NSMutableArray *)params {
    if (!_params) {
        _params = [NSMutableArray array];
    }
    return _params;
}

@end
