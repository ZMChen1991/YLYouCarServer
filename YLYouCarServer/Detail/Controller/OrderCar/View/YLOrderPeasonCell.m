//
//  YLOrderPeasonCell.m
//  YLYouCarServer
//
//  Created by lm on 2019/1/10.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLOrderPeasonCell.h"
#import "YLCondition.h"

@interface YLOrderPeasonCell ()

@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation YLOrderPeasonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)yl_initView {
    
    UILabel *name = [[UILabel alloc] init];
    [self.contentView addSubview:name];
    
    UILabel *telephone = [[UILabel alloc] init];
    [self.contentView addSubview:telephone];
    
    UILabel *appointTime = [[UILabel alloc] init];
    [self.contentView addSubview:appointTime];
    
    UILabel *finalPrice = [[UILabel alloc] init];
    [self.contentView addSubview:finalPrice];
    
    UILabel *state = [[UILabel alloc] init];
    state.text = @"更改状态";
    [self.contentView addSubview:state];
    
    NSArray *array = @[@"待约定", @"已约定", @"已签合同", @"已复检", @"已交易", @"已取消"];
    for (NSInteger i = 0; i < array.count; i++) {
        YLCondition *btn = [YLCondition buttonWithType:UIButtonTypeCustom];
        btn.type = YLConditionTypeWhite;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [self.btns addObject:btn];
    }
}

- (void)setModel:(NSArray *)model {
    
}

- (NSMutableArray *)btns {
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

@end
