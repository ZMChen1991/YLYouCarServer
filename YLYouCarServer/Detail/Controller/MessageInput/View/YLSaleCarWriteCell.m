//
//  YLSaleCarWriteCell.m
//  YLFunction
//
//  Created by lm on 2019/1/21.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSaleCarWriteCell.h"
#import "NSString+Extension.h"

@interface YLSaleCarWriteCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *detailLabel;
//@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation YLSaleCarWriteCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *const cellID = @"YLSaleCarWriteCell";
    YLSaleCarWriteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[YLSaleCarWriteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.backgroundColor = [UIColor redColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = YLColor(51.f, 51.f, 51.f);
        [self addSubview:titleLabel];
        self.label = titleLabel;
        
        UITextField *detailLabel = [[UITextField alloc] init];
//        detailLabel.backgroundColor = [UIColor yellowColor];
        detailLabel.font = [UIFont systemFontOfSize:14];
        detailLabel.textColor = YLColor(51.f, 51.f, 51.f);
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.keyboardType = UIKeyboardTypeDefault;
        detailLabel.returnKeyType = UIReturnKeyDone;
        [detailLabel addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        detailLabel.delegate = self;
        [self addSubview:detailLabel];
        self.detailLabel = detailLabel;
//        UILabel *detailLabel = [[UILabel alloc] init];
//        [self addSubview:detailLabel];
//        self.detailLabel = detailLabel;
    }
    return self;
}

- (void)textFieldChanged:(UITextField *)textField {
//    NSLog(@"textField:%@", textField.text);
//    if (self.writeBlock) {
//        self.writeBlock(textField.text);
//    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.writeBlock) {
        self.writeBlock(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.writeBlock) {
        self.writeBlock(textField.text);
    }
    [self.detailLabel resignFirstResponder];
    return YES;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    CGSize titleSize = [title getSizeWithFont:[UIFont systemFontOfSize:14]];
    self.label.frame = CGRectMake(15, 0, titleSize.width, self.frame.size.height);
    self.label.text = title;
}

- (void)setDetailTitle:(NSString *)detailTitle {
    _detailTitle = detailTitle;
    
    CGFloat titleW = (YLScreenWidth - 2 * YLMargin)/ 2;
    self.detailLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 15 - titleW, 0, titleW, self.frame.size.height);
    if ([detailTitle isEqualToString:@"请输入"]) {
        self.detailLabel.placeholder = detailTitle;
    } else {
        self.detailLabel.text = detailTitle;
    }
    
}

- (void)setModel:(YLMessageModel *)model {
    _model = model;
    
    CGSize titleSize = [model.title getSizeWithFont:[UIFont systemFontOfSize:14]];
    self.label.frame = CGRectMake(15, 0, titleSize.width, self.frame.size.height);
    self.label.text = model.title;
    
    self.detailLabel.text = @"";
    self.detailLabel.placeholder = @"";
    
    CGFloat titleW = (YLScreenWidth - 2 * YLMargin)/ 2;
    self.detailLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 15 - titleW, 0, titleW, self.frame.size.height);
    if ([model.param isEqualToString:@"请输入"]) {
        self.detailLabel.placeholder = model.param;
//        NSLog(@"placeholder:%@ - %@", model.param, model.title);
    } else {
//        NSLog(@"text:%@ - %@", model.param, model.title);
        self.detailLabel.text = model.param;
    }
}

@end
