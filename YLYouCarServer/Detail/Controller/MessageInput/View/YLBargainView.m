//
//  YLBargainView.m
//  YLYouCarServer
//
//  Created by lm on 2019/1/24.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLBargainView.h"

@interface YLBargainView ()

@property (nonatomic, strong) UILabel *bg;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YLBargainView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    CGFloat labelW = 20;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelW, labelW)];
    label.layer.borderWidth = 1;
    label.layer.borderColor = YLColor(200.f, 200.f, 200.f).CGColor;
    label.layer.cornerRadius = labelW / 2;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor whiteColor];
    [self addSubview:label];
    self.bg = label;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(label.frame) + 7, 0, 200, labelW)];
    title.textColor = YLColor(51.f, 51.f, 51.f);
    title.font = [UIFont systemFontOfSize:14];
    [self addSubview:title];
    self.titleLabel = title;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (isSelect) {
        self.bg.backgroundColor = YLColor(8.f, 169.f, 255.f);
    } else {
        self.bg.backgroundColor = [UIColor whiteColor];
    }
}

@end
