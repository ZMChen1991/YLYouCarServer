//
//  YLAllOrderCell.h
//  YLYouCarServer
//
//  Created by lm on 2018/11/28.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLAllOrderCellFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLAllOrderCell : UITableViewCell

@property (nonatomic, strong) YLAllOrderCellFrame *cellFrame;

+ (instancetype)cellWithTableView:(UITableView *)table;

@end

NS_ASSUME_NONNULL_END
