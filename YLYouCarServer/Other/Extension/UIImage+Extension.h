//
//  UIImage+Extension.h
//  YLYouCarServer
//
//  Created by lm on 2019/1/26.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

- (UIImage *)scaleToWidth:(CGFloat)width;

+ (UIImage *)getScreenImage;

@end

NS_ASSUME_NONNULL_END
