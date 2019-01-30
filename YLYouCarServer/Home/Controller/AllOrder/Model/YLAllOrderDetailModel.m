//
//  YLAllOrderDetailModel.m
//  YLYouCarServer
//
//  Created by lm on 2018/12/4.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLAllOrderDetailModel.h"

@implementation YLAllOrderDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"carID":@"id"};
}

@end
