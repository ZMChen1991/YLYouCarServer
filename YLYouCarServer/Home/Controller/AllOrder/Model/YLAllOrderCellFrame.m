//
//  YLAllOrderCellFrame.m
//  YLYouCarServer
//
//  Created by lm on 2018/12/4.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLAllOrderCellFrame.h"

@implementation YLAllOrderCellFrame

- (void)setModel:(YLAllOrderModel *)model {
    
    _model = model;
    
    CGFloat titleW = YLScreenWidth - 2 * YLMargin;
    CGFloat titleH = 0;
    CGSize size = [model.detail.title getSizeWithFont:[UIFont systemFontOfSize:16]];
    if (size.width > titleW - 10) {
        titleH = 50;
    } else {
        titleH = 22;
    }
    
    self.titleF = CGRectMake(YLMargin, 10, titleW, titleH);
    
    self.lineF = CGRectMake(0, CGRectGetMaxY(self.titleF) + 10, YLScreenWidth, 1);
    
    CGFloat timeW = (YLScreenWidth - 2 * YLMargin) / 2;
    CGFloat timeH = 20;
    self.orderTimeF = CGRectMake(YLMargin, CGRectGetMaxY(self.lineF) + 10, timeW, timeH);
    self.telephoneF = CGRectMake(CGRectGetMaxX(self.orderTimeF), CGRectGetMaxY(self.lineF) + 10, timeW, timeH);
    
    self.checkTimeF = CGRectMake(YLMargin * 2, CGRectGetMaxY(self.orderTimeF) + 10, titleW, 20);
    self.licenseTimeF = CGRectMake(YLMargin * 2, CGRectGetMaxY(self.checkTimeF)+ YLTopMargin, titleW, 20);
    self.courseF = CGRectMake(YLMargin * 2, CGRectGetMaxY(self.licenseTimeF)+ YLTopMargin, titleW, 20);
    self.line1F = CGRectMake(0, CGRectGetMaxY(self.courseF) + YLMargin, YLScreenWidth, 1);
    self.cellHeight = CGRectGetMaxY(self.line1F);
}

@end
