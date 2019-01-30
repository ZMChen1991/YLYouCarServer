//
//  YLInputMessageController.h
//  YLYouCarServer
//
//  Created by lm on 2018/12/4.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDetailModel.h"
#import "YLAllOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLInputMessageController : UITableViewController

//@property (nonatomic, strong) YLDetailModel *detailModel;
@property (nonatomic, strong) YLAllOrderModel *allOrderModel;

@end

NS_ASSUME_NONNULL_END
