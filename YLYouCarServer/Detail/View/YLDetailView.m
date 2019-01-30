//
//  YLDetailView.m
//  YLYouCarServer
//
//  Created by lm on 2018/11/28.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLDetailView.h"

@interface YLDetailView ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *telephone;
@property (nonatomic, strong) UILabel *checkTime;
@property (nonatomic, strong) UILabel *licenseTime;
@property (nonatomic, strong) UILabel *course;


@end

@implementation YLDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(YLMargin, YLTopMargin * 2, YLScreenWidth - 2 * YLMargin, 22)];
    titleL.text = @"比亚迪 秦 2018款 1.5TI双离合 智联风尚版";
    titleL.numberOfLines = 0;
//    titleL.backgroundColor = [UIColor redColor];
    titleL.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self addSubview:titleL];
    self.title = titleL;
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(YLMargin * 2, CGRectGetMaxY(titleL.frame) + 2 * YLTopMargin, 100, 20)];
    name.text = @"先生 / 小姐";
//    name.backgroundColor = [UIColor redColor];
    name.textAlignment = NSTextAlignmentLeft;
    name.font = YLNormalFont;
    [self addSubview:name];
    self.name = name;
    
    UILabel *telephone = [[UILabel alloc] initWithFrame:CGRectMake(YLMargin * 2, CGRectGetMaxY(name.frame) + 2 * YLTopMargin, YLScreenWidth - 2 * YLMargin - 80, 20)];
    telephone.text = @"13800000000";
    telephone.font = YLNormalFont;
    [self addSubview:telephone];
    self.telephone = telephone;
    
    UILabel *checkTime = [[UILabel alloc] initWithFrame:CGRectMake(YLMargin * 2, CGRectGetMaxY(telephone.frame) + 2 * YLTopMargin, YLScreenWidth - 2 * YLMargin - 80, 20)];
    checkTime.text = @"10-10 10:10";
    checkTime.font = YLNormalFont;
    [self addSubview:checkTime];
    self.checkTime = checkTime;
    
    UILabel *licenseTime = [[UILabel alloc] initWithFrame:CGRectMake(YLMargin * 2, CGRectGetMaxY(checkTime.frame) + 2 * YLTopMargin, YLScreenWidth - 2 * YLMargin - 80, 20)];
    licenseTime.text = @"2018-10-10";
    licenseTime.font = YLNormalFont;
    [self addSubview:licenseTime];
    self.licenseTime = licenseTime;
    
    UILabel *course = [[UILabel alloc] initWithFrame:CGRectMake(YLMargin * 2, CGRectGetMaxY(licenseTime.frame) + 2 * YLTopMargin, YLScreenWidth - 2 * YLMargin - 80, 20)];
    course.text = @"9.8万公里";
    course.font = YLNormalFont;
    [self addSubview:course];
    self.course = course;
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(course.frame) + YLMargin, YLScreenWidth, 1)];
    line1.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line1];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

- (void)setModel:(YLAllOrderModel *)model {
    _model = model;
    if (!model) {
        return;
    }
    self.title.text = model.detail.title;
//    self.name.text = model.name;
    self.telephone.text = [NSString stringWithFormat:@"联系方式: %@", model.telephone];
    self.checkTime.text = [NSString stringWithFormat:@"验车时间: %@", model.examineTime];
    self.licenseTime.text = [NSString stringWithFormat:@"上牌时间: %@", model.detail.licenseTime];
    self.course.text = [NSString stringWithFormat:@"行驶里程: %@", model.detail.course];
}

@end
