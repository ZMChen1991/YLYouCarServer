//
//  YLAccountTool.h
//  YLYouCarServer
//
//  Created by lm on 2019/1/2.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLAccount.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLAccountTool : NSObject

+ (void)saveAccount:(YLAccount *)account;

+ (YLAccount *)account;

+ (void) loginOut;

@end

NS_ASSUME_NONNULL_END
