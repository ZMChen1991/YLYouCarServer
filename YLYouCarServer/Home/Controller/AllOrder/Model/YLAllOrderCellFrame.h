//
//  YLAllOrderCellFrame.h
//  YLYouCarServer
//
//  Created by lm on 2018/12/4.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLAllOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLAllOrderCellFrame : NSObject

@property (nonatomic, strong) YLAllOrderModel *model;

@property (nonatomic, assign) CGRect orderTimeF;
@property (nonatomic, assign) CGRect telephoneF;
@property (nonatomic, assign) CGRect titleF;
@property (nonatomic, assign) CGRect checkTimeF;
@property (nonatomic, assign) CGRect licenseTimeF;
@property (nonatomic, assign) CGRect courseF;

@property (nonatomic, assign) CGRect lineF;
@property (nonatomic, assign) CGRect line1F;

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
