//
//  YLMessageHeaderView.m
//  YLYouCarServer
//
//  Created by lm on 2018/12/4.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLMessageHeaderView.h"

@interface YLMessageHeaderView () {
    CGFloat titleLW, titleW, titleH;
}

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YLMessageHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    titleLW = 70;
    titleH = 30;
    titleW  = YLScreenWidth - 3 * YLMargin - titleLW;
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.frame = CGRectMake(YLMargin, YLMargin, titleLW, titleH);
//    titleL.backgroundColor = [UIColor redColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont systemFontOfSize:16];
    titleL.text = @"具体车型";
    [self addSubview:titleL];
    
    UILabel *title = [[UILabel alloc] init];
//    title.backgroundColor = [UIColor yellowColor];
    title.frame = CGRectMake(CGRectGetMaxX(titleL.frame) + YLMargin, YLMargin, titleW, titleH);
    title.textAlignment = NSTextAlignmentLeft;
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:14];
    [self addSubview:title];
    self.titleLabel = title;
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleL.frame) + YLMargin, YLScreenWidth, 1)];
    line1.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line1];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    CGSize size = [title getSizeWithFont:[UIFont systemFontOfSize:14]];
    CGRect rect = self.titleLabel.frame;
    if (size.width > rect.size.width) {
        rect.size.height = 40;
        rect.origin.y = YLMargin - 5;
    }
    self.titleLabel.frame = rect;
    self.titleLabel.text = title;
}

@end
