//
//  YLAllOrderModel.h
//  YLYouCarServer
//
//  Created by lm on 2018/11/28.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLAllOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLAllOrderModel : NSObject

@property (nonatomic, strong) YLAllOrderDetailModel *detail;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *centerId;
@property (nonatomic, strong) NSString *examineTime;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *book;
@property (nonatomic, strong) NSString *createAt;
@property (nonatomic, strong) NSString *detailId;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
