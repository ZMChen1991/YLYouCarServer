//
//  YLOrderModel.h
//  YLYouCarServer
//
//  Created by lm on 2019/1/10.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLOrderModel : NSObject

@property (nonatomic, strong) NSString *appointTime;
@property (nonatomic, strong) NSString *centerId;
@property (nonatomic, strong) NSString *createAt;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *detailId;
@property (nonatomic, strong) NSString *finalPrice;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *initialPrice;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *updateAt;

@end

NS_ASSUME_NONNULL_END
