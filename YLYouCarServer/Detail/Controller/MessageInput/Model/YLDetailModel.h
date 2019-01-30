//
//  YLDetailModel.h
//  YLYouCarServer
//
//  Created by lm on 2019/1/10.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLDetailModel : NSObject

@property (nonatomic, strong) NSString *annualInspection; // 年检
@property (nonatomic, strong) NSString *appearance;//外观
@property (nonatomic, strong) NSString *approveAt;//审核时间
@property (nonatomic, strong) NSString *backReason;//退回原因
@property (nonatomic, strong) NSString *blemish;// 图片
@property (nonatomic, strong) NSString *bodyStructure;//车型
@property (nonatomic, strong) NSString *brand;//品牌
@property (nonatomic, strong) NSString *centerId;//检测中心ID
@property (nonatomic, strong) NSString *centerPhone;//检测中心电话
@property (nonatomic, strong) NSString *childSeatInterface;//儿童座椅接口
@property (nonatomic, strong) NSString *clickSum;//点击次数
@property (nonatomic, strong) NSString *color;//颜色
@property (nonatomic, strong) NSString *commercialInsurance;//商业险
@property (nonatomic, strong) NSString *country;//国别
@property (nonatomic, strong) NSString *course;//里程
@property (nonatomic, strong) NSString *createAt;//创建时间
@property (nonatomic, strong) NSString *displayImg;//列表显示图片
@property (nonatomic, strong) NSNumber *emission;//排放量
@property (nonatomic, strong) NSString *emissionStandard;//排放标准
@property (nonatomic, strong) NSString *firstPrice;//第一次价格
@property (nonatomic, strong) NSString *floorPrice;//卖家底价
@property (nonatomic, strong) NSString *fuelForm;//燃油方式/类型
@property (nonatomic, strong) NSString *gearbox;//变速箱
@property (nonatomic, strong) NSString *genuineLeather;//真皮/ 仿皮座椅
@property (nonatomic, strong) NSString *gps;//GPS导航
@property (nonatomic, strong) NSString *carID;//车辆ID
@property (nonatomic, strong) NSString *interior;//内饰
@property (nonatomic, strong) NSString *isBargain;//是否接受议价：1接受、2不接受
@property (nonatomic, strong) NSString *keylessEntrySystem;//
@property (nonatomic, strong) NSString *license;//上牌
@property (nonatomic, strong) NSString *licenseTime;//上牌时间
@property (nonatomic, strong) NSString *location;//车牌所在地
@property (nonatomic, strong) NSString *meetingPlace;//看车地点
@property (nonatomic, strong) NSString *operatingCondition;//工况
@property (nonatomic, strong) NSString *originalPrice;//新车价价
@property (nonatomic, strong) NSString *overInstall;//加装
@property (nonatomic, strong) NSString *panoramicSunroof;//全景天窗
@property (nonatomic, strong) NSString *parkingRadar;//倒车雷达
@property (nonatomic, strong) NSString *price;//价格
@property (nonatomic, strong) NSString *purpose;// 购车目的
@property (nonatomic, strong) NSString *remarks;//备注
@property (nonatomic, strong) NSString *reverseVideo;//倒车影像系统
@property (nonatomic, strong) NSString *seatsNum;//座位数
@property (nonatomic, strong) NSString *series;//车系
@property (nonatomic, strong) NSString *stabilityControl;//车身稳定控制
@property (nonatomic, strong) NSString *status;//状态：1待提交 2待审核 3上线 4退回 0下架
@property (nonatomic, strong) NSString *telephone;//电话
@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *trafficInsurance;//交强险
@property (nonatomic, strong) NSString *transfer;//过户次数
@property (nonatomic, strong) NSString *type;//车型
@property (nonatomic, strong) NSString *typeId;//车型ID
@property (nonatomic, strong) NSString *updateAt;//更新时间
@property (nonatomic, strong) NSString *vehicle;//检测中心ID
@property (nonatomic, strong) NSString *video;//检测中心ID
@property (nonatomic, assign) BOOL newCar;
@property (nonatomic, assign) BOOL zeroTransfer;

@end

NS_ASSUME_NONNULL_END
