//
//  YLAccount.m
//  YLYouCarServer
//
//  Created by lm on 2019/1/2.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLAccount.h"
#import "YLAccountTool.h"

@implementation YLAccount

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

+ (instancetype)accountWithDict:(NSDictionary *)dict {
    YLAccount *account = [YLAccountTool account];
    if (!account) {
        account = [[self alloc] init];
    }
    account.ID = dict[@"id"];
    account.status = dict[@"status"];
    account.passworld = dict[@"passworld"];
    account.centerId = dict[@"centerId"];
    return account;
}

/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.passworld forKey:@"passworld"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.centerId forKey:@"centerId"];
    
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.passworld = [aDecoder decodeObjectForKey:@"passworld"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.centerId = [aDecoder decodeObjectForKey:@"centerId"];
    }
    return self;
}

@end
