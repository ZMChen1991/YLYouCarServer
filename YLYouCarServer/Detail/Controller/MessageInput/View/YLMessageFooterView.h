//
//  YLMessageFooterView.h
//  YLYouCarServer
//
//  Created by lm on 2018/12/4.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SaveBlock)(void);
typedef void(^CommitBlock)(void);
typedef void(^IsBargainBlock)(NSString *isBargain);
typedef void(^RemarksBlock)(NSString *remarks);

@protocol YLMessageFooterViewDelegate <NSObject>

- (void)commitMessage;
- (void)saveMessage;

@end


@interface YLMessageFooterView : UIView

@property (nonatomic, copy) SaveBlock saveBlock;
@property (nonatomic, copy) CommitBlock commitBlock;
@property (nonatomic, copy) IsBargainBlock isBargainBlock;
@property (nonatomic, copy) RemarksBlock remarksBlock;

@property (nonatomic, strong) YLDetailModel *detailModel;
@property (nonatomic, weak) id<YLMessageFooterViewDelegate> delegate;
//@property (nonatomic, strong) NSString *titles;

@end

NS_ASSUME_NONNULL_END
