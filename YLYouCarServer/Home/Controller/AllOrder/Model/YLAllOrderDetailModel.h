//
//  YLAllOrderDetailModel.h
//  YLYouCarServer
//
//  Created by lm on 2018/12/4.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLAllOrderDetailModel : NSObject

@property (nonatomic, strong) NSString *carID;
@property (nonatomic, strong) NSString *centerId;
@property (nonatomic, strong) NSString *centerPhone;
@property (nonatomic, strong) NSString *clickSum;
@property (nonatomic, strong) NSString *course;
@property (nonatomic, strong) NSString *displayImg;
@property (nonatomic, strong) NSString *floorPrice;
@property (nonatomic, strong) NSString *isBargain;
@property (nonatomic, strong) NSString *licenseTime;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *lookSum;
@property (nonatomic, strong) NSString *originalPrice;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END
