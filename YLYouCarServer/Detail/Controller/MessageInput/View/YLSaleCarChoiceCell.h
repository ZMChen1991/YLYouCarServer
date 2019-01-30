//
//  YLSaleCarChoiceCell.h
//  YLFunction
//
//  Created by lm on 2019/1/21.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLMessageModel.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^ChoiceBlock)(void);
@interface YLSaleCarChoiceCell : UITableViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detailTitle;
@property (nonatomic, copy) ChoiceBlock choiceBlock;
@property (nonatomic, strong) YLMessageModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
