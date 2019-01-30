//
//  YLImageUploadModel.h
//  YLYouCarServer
//
//  Created by lm on 2019/1/11.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLImageUploadModel : NSObject

@property (nonatomic, strong) NSString *group;
@property (nonatomic, strong) NSString *sortNo;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, assign) BOOL isUploaded;

@end

NS_ASSUME_NONNULL_END
