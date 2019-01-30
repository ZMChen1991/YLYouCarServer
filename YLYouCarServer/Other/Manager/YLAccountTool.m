//
//  YLAccountTool.m
//  YLYouCarServer
//
//  Created by lm on 2019/1/2.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLAccountTool.h"

@implementation YLAccountTool

+ (void)saveAccount:(YLAccount *)account {
    NSLog(@"%@", YLAccountPath);
    [NSKeyedArchiver archiveRootObject:account toFile:YLAccountPath];
}

+ (YLAccount *)account {
    YLAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:YLAccountPath];
    return account;
}

+ (void)loginOut {
    YLAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:YLAccountPath];
    account = nil;
    [self saveAccount:account];
}

@end
