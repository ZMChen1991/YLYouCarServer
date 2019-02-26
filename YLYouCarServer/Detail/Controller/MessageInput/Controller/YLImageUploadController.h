//
//  YLImageUploadController.h
//  YLYouCarServer
//
//  Created by lm on 2019/1/11.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLAllOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YLImageControllerType) {
    YLImageControllerTypeLicense,
    YLImageControllerTypeVehicle,
    YLImageControllerTypeBlemishs,
};

typedef void(^RefreshBlock)(void);

@interface YLImageUploadController : UIViewController

@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSString *group;
@property (nonatomic, assign) YLImageControllerType type;
@property (nonatomic, strong) YLAllOrderModel *allOrderModel;

@property (nonatomic, copy) RefreshBlock refreshBlock;


@end

NS_ASSUME_NONNULL_END
