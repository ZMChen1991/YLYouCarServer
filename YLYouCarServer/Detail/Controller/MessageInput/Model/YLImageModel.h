//
//  YLImageModel.h
//  YLYouCarServer
//
//  Created by lm on 2019/1/12.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLImageModel : NSObject

@property (nonatomic, strong) NSString *createAt;
@property (nonatomic, strong) NSString *detailId;
@property (nonatomic, strong) NSString *group;
@property (nonatomic, strong) NSString *imgId;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *sortNo;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *updateAt;
@property (nonatomic, assign) BOOL isUpdata;

@end

NS_ASSUME_NONNULL_END
