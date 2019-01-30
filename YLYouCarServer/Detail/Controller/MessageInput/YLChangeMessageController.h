//
//  YLChangeMessageController.h
//  YLYouCarServer
//
//  Created by lm on 2019/1/12.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLAllOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChangeMessageBlock)(NSString  *message);

@interface YLChangeMessageController : UIViewController

@property (nonatomic, strong) YLAllOrderModel *allOrderModel;
@property (nonatomic, copy) ChangeMessageBlock changeMessageBlock;

@end

NS_ASSUME_NONNULL_END
