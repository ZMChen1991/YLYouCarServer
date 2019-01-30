//
//  YLMessageFooterView.m
//  YLYouCarServer
//
//  Created by lm on 2018/12/4.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLMessageFooterView.h"
#import "YLCondition.h"
#import "YLBargainView.h"

@interface YLMessageFooterView () <UITextViewDelegate>

@property (nonatomic, strong) YLBargainView *accept;
@property (nonatomic, strong) YLBargainView *refuse;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSString *isBargain;

@end

@implementation YLMessageFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, 1)];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];

    
    YLBargainView *accept = [[YLBargainView alloc] initWithFrame:CGRectMake(YLMargin, YLMargin, self.bounds.size.width - 2 * YLMargin, 20)];
    accept.isSelect = YES;
    accept.title = @"接受议价";
    [accept setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acceptClick)];
    [accept addGestureRecognizer:tap];
    [self addSubview:accept];
    self.accept = accept;
    
    YLBargainView *refuse = [[YLBargainView alloc] initWithFrame:CGRectMake(YLMargin, CGRectGetMaxY(accept.frame) + YLMargin, self.bounds.size.width - 2 * YLMargin, 20)];
    refuse.isSelect = NO;
    refuse.title = @"拒绝议价";
    [refuse setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refuseClick)];
    [refuse addGestureRecognizer:tap1];
    [self addSubview:refuse];
    self.refuse = refuse;
    
    UILabel *other = [[UILabel alloc] initWithFrame:CGRectMake(YLMargin, CGRectGetMaxY(refuse.frame) + 10, YLScreenWidth / 2, 30)];
    other.text = @"其他描述";
    other.textAlignment = NSTextAlignmentLeft;
    other.font = [UIFont systemFontOfSize:16];
    [self addSubview:other];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(YLMargin, CGRectGetMaxY(other.frame) + YLMargin, YLScreenWidth - 2 * YLMargin, 100)];
    textView.layer.cornerRadius = 5;
    textView.layer.borderWidth = 0.6;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.masksToBounds = YES;
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = YLColor(51.f, 51.f, 51.f);
    [textView setPlaceholder:@"其他描述" placeholdColor:[UIColor grayColor]];
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeyDone;
    [self addSubview:textView];
    self.textView = textView;
    
    
    CGFloat btnW = (YLScreenWidth - 3 * YLMargin) / 2;
    CGFloat btnH = 40;
    YLCondition *save = [YLCondition buttonWithType:UIButtonTypeCustom];
    save.type = YLConditionTypeWhite;
    [save setTitle:@"保存" forState:UIControlStateNormal];
    save.titleLabel.font = [UIFont systemFontOfSize:14];
    save.frame = CGRectMake(YLMargin, CGRectGetMaxY(textView.frame) + YLMargin, btnW, btnH);
    [save addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:save];
    
    YLCondition *commit = [YLCondition buttonWithType:UIButtonTypeCustom];
    commit.type = YLConditionTypeBlue;
    [commit setTitle:@"提交" forState:UIControlStateNormal];
    commit.titleLabel.font = [UIFont systemFontOfSize:14];
    commit.frame = CGRectMake(CGRectGetMaxX(save.frame) + YLMargin, CGRectGetMaxY(textView.frame) + YLMargin, btnW, btnH);
    [commit addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commit];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.remarksBlock) {
        self.remarksBlock(self.textView.text);
    }
    return YES;
}

- (void)saveClick {
    NSLog(@"点击保存");
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveMessage)]) {
        [self.delegate saveMessage];
    }
}

- (void)commitClick {
    NSLog(@"点击提交");
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitMessage)]) {
        [self.delegate commitMessage];
    }
}

- (void)acceptClick {
    NSLog(@"接受议价");
    self.isBargain = @"1";
    self.accept.isSelect = YES;
    self.refuse.isSelect = NO;
    if (self.isBargainBlock) {
        self.isBargainBlock(self.isBargain);
    }
}

- (void)refuseClick {
    NSLog(@"拒绝议价");
    self.isBargain = @"0";
    self.accept.isSelect = NO;
    self.refuse.isSelect = YES;
    if (self.isBargainBlock) {
        self.isBargainBlock(self.isBargain);
    }
}

- (void)setDetailModel:(YLDetailModel *)detailModel {
    _detailModel = detailModel;
    
    
    self.isBargain = detailModel.isBargain;
    if ([self.isBargain isEqualToString:@"0"]) {
        self.accept.isSelect = NO;
        self.refuse.isSelect = YES;
    } else {// 接受议价
        self.accept.isSelect = YES;
        self.refuse.isSelect = NO;
    }
}

//- (void)setTitles:(NSString *)titles {
//    _titles = titles;
//    [self.textView setPlaceholder:titles placeholdColor:[UIColor grayColor]];
//}

@end
