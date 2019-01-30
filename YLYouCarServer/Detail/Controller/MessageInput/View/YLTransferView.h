//
//  YLTransferView.h
//  YLYouCarServer
//
//  Created by lm on 2019/1/23.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YLTransferBlock)(NSString *transfer);
typedef void(^CancelBlock)(void);

@interface YLTransferView : UIView

@property (nonatomic, copy) YLTransferBlock transferBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;


@end

NS_ASSUME_NONNULL_END
