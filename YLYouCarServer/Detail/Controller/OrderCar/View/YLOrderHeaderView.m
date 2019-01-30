//
//  YLOrderHeaderView.m
//  YLYouCarServer
//
//  Created by lm on 2019/1/10.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLOrderHeaderView.h"

@implementation YLOrderHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *title = [[UILabel alloc] init];
    [self addSubview:title];
    UILabel *name = [[UILabel alloc] init];
    [self addSubview:name];
    UILabel *telephone = [[UILabel alloc] init];
    [self addSubview:telephone];
    UILabel *examineTime = [[UILabel alloc] init];
    [self addSubview:examineTime];
    UILabel *licenseTime = [[UILabel alloc] init];
    [self addSubview:licenseTime];
    UILabel *course = [[UILabel alloc] init];
    [self addSubview:course];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

- (void)setModel:(NSArray *)model {
    
}

@end
