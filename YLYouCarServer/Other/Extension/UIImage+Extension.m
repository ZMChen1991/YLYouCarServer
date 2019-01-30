//
//  UIImage+Extension.m
//  YLYouCarServer
//
//  Created by lm on 2019/1/26.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

- (UIImage *)scaleToWidth:(CGFloat)width {
    // c如果传入的宽度比当前宽度还要大，就直接返回
    if (width >self.size.width) {
        return self;
    }
    
    // 计算缩放之后的高度
    CGFloat height = (width / self.size.width) * self.size.height;
    CGRect rect = CGRectMake(0, 0, width, height);
    // 开启图形上下文
    UIGraphicsBeginImageContext(rect.size);
    // 画到上下文中
    [self drawInRect:rect];
    // 取到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return image;
    
}

+ (UIImage *)getScreenImage {
    // 获取主窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 开启图形上下文
    UIGraphicsBeginImageContext(window.frame.size);
    // 将window里面的内容画到上下文中
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
    // 取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
