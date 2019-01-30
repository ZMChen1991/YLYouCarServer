//
//  YLColorView.h
//  YLYouCarServer
//
//  Created by lm on 2019/1/24.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YLColorBlock)(NSString *color);
typedef void(^CancelBlock)(void);

@interface YLColorView : UIView

@property (nonatomic, copy) YLColorBlock colorBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;

@end

NS_ASSUME_NONNULL_END
