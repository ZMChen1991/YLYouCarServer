//
//  YLCarStatusView.h
//  YLYouCarServer
//
//  Created by lm on 2018/11/28.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLAllOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YLCarStatusViewDelegate <NSObject>
- (void)changeCarState:(NSString *)state;
@end

@interface YLCarStatusView : UIView

@property (nonatomic, strong) YLAllOrderModel *model;
@property (nonatomic, weak) id<YLCarStatusViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
