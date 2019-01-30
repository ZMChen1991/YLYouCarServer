//
//  YLDetailModel.m
//  YLYouCarServer
//
//  Created by lm on 2019/1/10.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLDetailModel.h"

@implementation YLDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"carID":@"id"};
}

@end
