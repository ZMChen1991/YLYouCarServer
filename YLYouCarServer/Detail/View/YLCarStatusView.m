//
//  YLCarStatusView.m
//  YLYouCarServer
//
//  Created by lm on 2018/11/28.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLCarStatusView.h"
#import "YLCondition.h"

@interface YLCarStatusView ()

//@property (nonatomic, strong) YLCondition *converBtn;
//@property (nonatomic, strong) YLCondition *checkOutBtn;
//@property (nonatomic, strong) YLCondition *dealBtn;
//@property (nonatomic, strong) YLCondition *cancelBtn;

@property (nonatomic, strong) YLCondition *selectBtn;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) UILabel *state;

@end

@implementation YLCarStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *state = [[UILabel alloc] initWithFrame:CGRectMake(YLMargin, YLTopMargin * 2, YLScreenWidth - 2 * YLMargin, 20)];
    state.text = @"当前状态:";
    [self addSubview:state];
    self.state = state;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(YLMargin, CGRectGetMaxY(state.frame) + YLTopMargin * 2, YLScreenWidth - 2 * YLMargin, 20)];
    title.text = @"汽车状态";
    [self addSubview:title];
    
    NSArray *titles = @[@"待约定", @"待验车", @"已上架", @"已下架"];
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame), YLScreenWidth, 55)];
    for (NSInteger i = 0; i < titles.count; i++) {
        YLCondition *btn = [YLCondition buttonWithType:UIButtonTypeCustom];
        btn.type = YLConditionTypeWhite;
        btn.tag = 100 + i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:btn];
        [self.btns addObject:btn];
//        if (i == 0) {
//            self.selectBtn = btn;
//            self.selectBtn.type = YLConditionTypeBlue;
//        }
    }
    [self addSubview:btnView];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnView.frame), YLScreenWidth, 1)];
    line1.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line1];
}

- (void)btnClick:(YLCondition *)sender {
    
    
    NSString *state;
    NSInteger index = sender.tag - 100;
    switch (index) {
        case 0:
            state = [NSString stringWithFormat:@"1"];
            break;
        case 1:
            state = [NSString stringWithFormat:@"2"];
            break;
        case 2:
            state = [NSString stringWithFormat:@"3"];
            break;
        case 3:
            state = [NSString stringWithFormat:@"0"];
            break;
            
        default:
            break;
    }
    
    if (index == 2) {
        
    } else {
        // 原选中的按钮还原成白色
        self.selectBtn.type = YLConditionTypeWhite;
        self.selectBtn = sender;
        self.selectBtn.type = YLConditionTypeBlue;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeCarState:)]) {
        NSLog(@"%@", state);
        [self.delegate changeCarState:state];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat margin = 8;
    CGFloat width = (YLScreenWidth - 2 * YLMargin - 3 * margin) / 4;
    CGFloat height = 32;
    for (NSInteger i = 0; i < self.btns.count; i++) {
        YLCondition *btn = self.btns[i];
        btn.frame = CGRectMake((width + margin) * i + YLMargin, 2 * YLTopMargin, width, height);
    }
}


- (void)setModel:(YLAllOrderModel *)model {
    _model = model;
    
    self.selectBtn.type = YLConditionTypeWhite;
    NSInteger index = [model.status integerValue];
    if (index == 0) { // 下架
        self.selectBtn = self.btns[3];
    } else if (index == 1) { // 待约定
        self.selectBtn = self.btns[0];
    } else if (index == 2) {// 待验车
        self.selectBtn = self.btns[1];
    } else if (index == 3) {// 上架
        self.selectBtn = self.btns[2];
    } else { // 交易完成
        self.selectBtn = self.btns[3];
    }
    self.selectBtn.type = YLConditionTypeBlue;
    self.state.text = [NSString stringWithFormat:@"当前状态:%@", self.selectBtn.titleLabel.text];
    NSLog(@"当前状态：%@--%ld", self.selectBtn.titleLabel.text, index);
}

- (NSMutableArray *)btns {
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

@end
