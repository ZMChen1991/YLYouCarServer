//
//  YLAccount.h
//  YLYouCarServer
//
//  Created by lm on 2019/1/2.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLAccount : NSObject <NSCoding>

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *passworld;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *centerId;

+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
