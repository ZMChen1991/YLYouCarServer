//
//  YLYearMonthPicker.h
//  YLYouka
//
//  Created by lm on 2018/12/1.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CancelBlock)(void);
typedef void(^SureBlock)(NSString *licenseTime);

typedef NS_ENUM(NSInteger, YLYearMonthType){
    YLYearMonthTypeBefore,
    YLYearMonthTypeFuture
};

@interface YLYearMonthPicker : UIView

@property (nonatomic, copy) CancelBlock cancelBlock;
@property (nonatomic, copy) SureBlock sureBlock;

@property (nonatomic, assign) YLYearMonthType type;

@end

NS_ASSUME_NONNULL_END
