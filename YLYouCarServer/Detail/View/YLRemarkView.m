//
//  YLRemarkView.m
//  YLYouCarServer
//
//  Created by lm on 2018/11/28.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLRemarkView.h"
#import "YLCondition.h"

@interface YLRemarkView ()

@property (nonatomic, strong) YLCondition *otherBtn;

@end

@implementation YLRemarkView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *other = [[UILabel alloc] initWithFrame:CGRectMake(YLMargin, YLTopMargin * 2, YLScreenWidth - YLMargin * 2, 20)];
    other.text = @"其他操作";
    other.font = YLTitleFont;
    other.textAlignment = NSTextAlignmentLeft;
    [self addSubview:other];
    
    YLCondition *otherBtn = [YLCondition buttonWithType:UIButtonTypeCustom];
    otherBtn.frame = CGRectMake(YLMargin, CGRectGetMaxY(other.frame) + YLTopMargin * 2, 100, 40);
    otherBtn.type = YLConditionTypeWhite;
    otherBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [otherBtn setTitle:@"预约看车" forState:UIControlStateNormal];
    [otherBtn addTarget:self action:@selector(orderCarNum) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:otherBtn];
    self.otherBtn = otherBtn;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(YLMargin,CGRectGetMaxY(otherBtn.frame) + YLTopMargin * 2, YLScreenWidth - YLMargin * 2, 20)];
    title.text = @"备注";
    title.font = YLTitleFont;
    title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:title];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(YLMargin, CGRectGetMaxY(title.frame) + 2 * YLTopMargin, YLScreenWidth - 2 * YLMargin, 80)];
    textView.layer.borderWidth = 0.5f;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    // 添加一个占位Label
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入内容";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [textView addSubview:placeHolderLabel];
    textView.font = YLNormalFont;
    placeHolderLabel.font = YLNormalFont;
    [textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    [self addSubview:textView];
    
    YLCondition *commit = [YLCondition buttonWithType:UIButtonTypeCustom];
    commit.type = YLConditionTypeBlue;
    commit.frame = CGRectMake(YLMargin, CGRectGetMaxY(textView.frame) + 40, YLScreenWidth - 2 * YLMargin, 40);
    [commit setTitle:@"提交" forState:UIControlStateNormal];
    commit.titleLabel.font = [UIFont systemFontOfSize:14];
    [commit addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commit];
}

- (void)commitClick {
    NSLog(@"提交");
}

- (void)orderCarNum {
    NSLog(@"查看预约看车人数");
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

- (void)setModel:(YLAllOrderModel *)model {
    _model = model;
    NSString *btnTitle;
    if (model.detail.lookSum > 0) {
        btnTitle =[NSString stringWithFormat:@"预约看车人数:%@", model.detail.lookSum];
    } else {
        btnTitle =[NSString stringWithFormat:@"预约看车人数:0"];
    }
    CGSize size = [btnTitle getSizeWithFont:[UIFont systemFontOfSize:14]];
    CGRect rect = self.otherBtn.frame;
    rect.size.width = size.width + 20;
    self.otherBtn.frame = rect;
    [self.otherBtn setTitle:btnTitle forState:UIControlStateNormal];
}

@end
