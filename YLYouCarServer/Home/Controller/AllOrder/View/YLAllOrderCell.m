//
//  YLAllOrderCell.m
//  YLYouCarServer
//
//  Created by lm on 2018/11/28.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLAllOrderCell.h"

@interface YLAllOrderCell ()

@property (nonatomic, strong) UILabel *orderTime;
@property (nonatomic, strong) UILabel *telephone;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *checkTime;
@property (nonatomic, strong) UILabel *licenseTime;
@property (nonatomic, strong) UILabel *course;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *line1;


@end

@implementation YLAllOrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YLAllOrderCell";
    YLAllOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YLAllOrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.layer.cornerRadius = 10.f;
//        self.layer.masksToBounds = YES;
//        self.layer.borderWidth = 0.5;
//        self.layer.borderColor = [UIColor grayColor].CGColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *timeL = [[UILabel alloc] init];
    timeL.textAlignment = NSTextAlignmentLeft;
    timeL.text = @"2018-10-10 12:12";
    timeL.font = [UIFont systemFontOfSize:14];
    [self addSubview:timeL];
    self.orderTime = timeL;
    
    UILabel *telephoneL = [[UILabel alloc] init];
    telephoneL.textAlignment = NSTextAlignmentRight;
    telephoneL.font = [UIFont systemFontOfSize:14];
    telephoneL.text = @"13800000000";
//    telephoneL.backgroundColor = [UIColor redColor];
    [self addSubview:telephoneL];
    self.telephone = telephoneL;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    titleL.numberOfLines = 0;
//    titleL.backgroundColor = [UIColor redColor];
    titleL.text = @"比亚迪 秦 2018款 1.5TI双离合 智联风尚版";
    [titleL sizeToFit];
    [self addSubview:titleL];
    self.title = titleL;

    UILabel *checkTime = [[UILabel alloc] init];
    checkTime.font = [UIFont systemFontOfSize:14];
    checkTime.textAlignment = NSTextAlignmentLeft;
    checkTime.text = @"10-10 10:10";
    [self addSubview:checkTime];
    self.checkTime = checkTime;
    
    UILabel *licenseTime = [[UILabel alloc] init];
    licenseTime.font = [UIFont systemFontOfSize:14];
    licenseTime.textAlignment = NSTextAlignmentLeft;
    licenseTime.text = @"2018-10-10";
    [self addSubview:licenseTime];
    self.licenseTime = licenseTime;
 
    UILabel *course = [[UILabel alloc] init];
    course.font = [UIFont systemFontOfSize:14];
    course.textAlignment = NSTextAlignmentLeft;
    course.text = @"3.7万公里";
    [self addSubview:course];
    self.course = course;
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line1];
    self.line1 = line1;
    
}

- (void)setCellFrame:(YLAllOrderCellFrame *)cellFrame {
    
    _cellFrame = cellFrame;
    self.orderTime.frame = cellFrame.orderTimeF;
    self.telephone.frame = cellFrame.telephoneF;
    self.title.frame = cellFrame.titleF;
    self.checkTime.frame = cellFrame.checkTimeF;
    self.licenseTime.frame = cellFrame.licenseTimeF;
    self.course.frame = cellFrame.courseF;
    self.line.frame = cellFrame.lineF;
    self.line1.frame = cellFrame.line1F;
    
    self.orderTime.text = cellFrame.model.createAt;
    self.telephone.text = cellFrame.model.telephone;
    self.title.text = cellFrame.model.detail.title;
    self.checkTime.text = [NSString stringWithFormat:@"验车时间: %@", cellFrame.model.examineTime];
    self.licenseTime.text = [NSString stringWithFormat:@"上牌时间: %@", cellFrame.model.detail.licenseTime];
    self.course.text = [NSString stringWithFormat:@"行驶里程: %@万公里", cellFrame.model.detail.course];
    
}
@end
