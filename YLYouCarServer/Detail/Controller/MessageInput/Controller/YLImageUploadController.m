//
//  YLImageUploadController.m
//  YLYouCarServer
//
//  Created by lm on 2019/1/11.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLImageUploadController.h"
#import <Photos/Photos.h>
#import "YLImageModel.h"
#import "YLRequest.h"
#import <BaiduBCEBOS/BaiduBCEBOS.h>
#import <BaiduBCEBasic/BaiduBCEBasic.h>

#define YLGroupPath(detailId, group) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", group, detailId]]

static NSString *const accessKey = @"1d764fe72a6a4dee989c177f2e0a0246";
static NSString *const secretKey = @"529b5ddba8ac4d7597ec215e650c47f5";
//static NSString *const bucketName = @"image-public";
static NSString *const bucketName = @"ucar-images";


@interface YLImageUploadController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSInteger index;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *imagePaths;
@property (nonatomic, strong) NSMutableArray *imageRemarks;
@property (nonatomic, strong) NSMutableArray *imageModels;
@property (nonatomic, strong) UIButton *last;
@property (nonatomic, strong) UIButton *next;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *titleL1;
@property (nonatomic, strong) UILabel *remarks;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) BOSClient *client;

@property (nonatomic, strong) NSMutableArray *objImageUrls;


@end

@implementation YLImageUploadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleArray = @[@"主驾侧头部45度", @"前脸", @"副驾侧头部45度", @"主驾侧", @"主驾侧尾部45度", @"尾部", @"副驾侧尾部45度", @"主驾侧头灯", @"主驾侧尾灯", @"主驾侧前轮", @"钥匙", @"中控全景", @"方向盘", @"仪表盘", @"公里数", @"中控屏", @"空调", @"档杆", @"主驾座椅调节器", @"前排座椅", @"后排座椅", @"阅读灯", @"后备箱", @"发动机舱", @"发动机舱-副驾侧", @"发动机舱-主驾侧", @"底盘-前", @"底盘-后", @"底盘-主驾侧", @"底盘-副驾侧"];
    index = 0;
    
    // 初始化，存放30个图片模型
    for (NSInteger i = 0; i < 30; i++) {
        YLImageModel *model = [[YLImageModel alloc] init];
        model.sortNo = [NSString stringWithFormat:@"%ld", i];
        model.remarks = [NSString stringWithFormat:@"%ld", i];
        [self.imageModels addObject:model];
    }
    
//    [self yl_initView];
//    [self yl__initClient];
//    [self loadData];
    
    
    [self yl__initView1];
    [self yl__initClient];
    [self loadData];
}

- (void)yl__initView1 {
    
    CGSize screenSzie = [UIScreen mainScreen].bounds.size;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(0, 0, 114, 40);
    btn.center = CGPointMake(15 + 20, screenSzie.height - 57 - 15 - 64);
    btn.transform = CGAffineTransformRotate(btn.transform, M_PI_2);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"上一张" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = YLColor(8.f, 169.f, 255.f);
    [btn addTarget:self action:@selector(lastImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor redColor];
    btn1.frame = CGRectMake(0, 0, 114, 40);
    btn1.center = CGPointMake(15 + 40 + 15 + 20, screenSzie.height - 57 - 15 - 64);
    btn1.transform = CGAffineTransformRotate(btn1.transform, M_PI_2);
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn1 setTitle:@"下一张" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.backgroundColor = YLColor(8.f, 169.f, 255.f);
    [btn1 addTarget:self action:@selector(nextImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    NSLog(@"btn:%.f-%.f:btn1:%.f-%.f", btn.center.x, btn.center.y, btn1.center.x, btn1.center.y);
    
    UIButton *takePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    takePhoto.frame = CGRectMake(0, 0, 70, 70);
    takePhoto.center = CGPointMake(screenSzie.width / 2, screenSzie.height - 57 - 15 - 64);
    takePhoto.layer.cornerRadius = 35.f;
    takePhoto.layer.masksToBounds = YES;
    takePhoto.backgroundColor = YLColor(8.f, 169.f, 255.f);
    [takePhoto addTarget:self action:@selector(actionPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhoto];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(0, 0, 114, 40);
    btn3.center = CGPointMake(screenSzie.width - (15 + 40 + 15 + 20), screenSzie.height - 57 - 15 - 64);
    btn3.transform = CGAffineTransformRotate(btn3.transform, M_PI_2);
    btn3.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn3 setTitle:@"更多操作" forState:UIControlStateNormal];
    [btn3 setTitleColor:YLColor(8.f, 169.f, 255.f) forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor whiteColor];
    btn3.layer.borderColor = YLColor(8.f, 169.f, 255.f).CGColor;
    btn3.layer.borderWidth = 0.5;
//    [btn3 addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(0, 0, 114, 40);
    btn4.center = CGPointMake(screenSzie.width - (15 + 20), screenSzie.height - 57 - 15 - 64);
    btn4.transform = CGAffineTransformRotate(btn4.transform, M_PI_2);
    btn4.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn4 setTitle:@"资料上传" forState:UIControlStateNormal];
    [btn4 setTitleColor:YLColor(8.f, 169.f, 255.f) forState:UIControlStateNormal];
    btn4.backgroundColor = [UIColor whiteColor];
    btn4.layer.borderColor = YLColor(8.f, 169.f, 255.f).CGColor;
    btn4.layer.borderWidth = 0.5;
    [btn4 addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    CGFloat labelW = screenSzie.height - 15 * 3 - 114 - 64;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, labelW, 40);
    label.center = CGPointMake(35, labelW / 2 + 15);
    label.backgroundColor = [UIColor whiteColor];
    label.transform = CGAffineTransformRotate(label.transform, M_PI_2);
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = YLColor(233.f, 233.f, 233.f).CGColor;
    [self.view addSubview:label];
    self.remarks = label;
    NSLog(@"label:%.f-%.f", label.center.x, label.center.y);
    
    CGFloat imageW = screenSzie.width - 15 * 3 - 40;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, labelW, imageW);
    imageView.center = CGPointMake(screenSzie.width - imageW / 2 - 15, labelW / 2 + 15);
    imageView.transform = CGAffineTransformRotate(imageView.transform, M_PI_2);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    CGFloat labH = 30;
    CGFloat labW = 60;
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(0, 0, labW, labH);
    label1.center = CGPointMake(screenSzie.width - 15 - labH / 2 - 10, labW / 2 + 15 + 10);
    label1.backgroundColor = YLColor(8.f, 169.f, 255.f);
    label1.transform = CGAffineTransformRotate(label1.transform, M_PI_2);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.layer.cornerRadius = labH / 2;
    label1.layer.masksToBounds = YES;
    label1.textColor = [UIColor whiteColor];
    label1.text = @"第1张";
    label1.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label1];
    self.titleL = label1;
    
    CGSize detailTitleSize = [self.titleArray[0] getSizeWithFont:[UIFont systemFontOfSize:12]];
    UILabel *detailTitle = [[UILabel alloc] init];
    detailTitle.frame = CGRectMake(0, 0, detailTitleSize.width + 20, labH);
    detailTitle.center = CGPointMake(screenSzie.width - 15 - labH / 2 - 10, CGRectGetMaxY(imageView.frame) - 20 - detailTitleSize.width / 2);
    detailTitle.backgroundColor = YLColor(8.f, 169.f, 255.f);
    detailTitle.transform = CGAffineTransformRotate(detailTitle.transform, M_PI_2);
    detailTitle.textAlignment = NSTextAlignmentCenter;
    detailTitle.layer.cornerRadius = labH / 2;
    detailTitle.layer.masksToBounds = YES;
    detailTitle.textColor = [UIColor whiteColor];
    detailTitle.text = self.titleArray[0];
    detailTitle.font = [UIFont systemFontOfSize:12];
    detailTitle.hidden = YES;
    [self.view addSubview:detailTitle];
    self.titleL1 = detailTitle;
    
    if (self.type == YLImageControllerTypeVehicle) {
        self.titleL1.hidden = NO;
    }
}

- (void)loadData {
    // 获取图片
    // license证件 vehicle车身 blemish瑕疵 video视频 必传
    NSString *urlString = [NSString stringWithFormat:@"%@/image?method=list", YLCommandUrl];
//    NSString *urlString = @"http://ucarjava.bceapp.com/image?method=list";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.allOrderModel.detailId forKey:@"detailId"];
    [param setObject:self.group forKey:@"group"];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [weakSelf keyedArchiverObject:responseObject toFile:YLGroupPath(weakSelf.allOrderModel.detailId, weakSelf.group)];
            [weakSelf getLocaltionData];
        } else {
            NSLog(@"%@", responseObject[@"message"]);
        }
    } failed:nil];
}

- (void)getLocaltionData {
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLGroupPath(self.allOrderModel.detailId, self.group)];
    NSArray *arr = [YLImageModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    // 获取到数据，按sortNo进行排序存放
    for (NSInteger i = 0; i < self.imageModels.count; i++) {
        for (YLImageModel *model in arr) {
            if ([model.sortNo isEqualToString:[NSString stringWithFormat:@"%ld", i]]) {
                [self.imageModels replaceObjectAtIndex:i withObject:model];
            }
        }
    }
    // 默认显示第一个图片
    YLImageModel *model = self.imageModels[0];
    NSString *placeholder;
    if (!model.img) {
        placeholder = @"占位图";
    } else {
        placeholder = @"优卡二手车";
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:placeholder]];
    self.remarks.text = model.remarks;
}

- (void)keyedArchiverObject:(id)obj toFile:(NSString *)filePath {
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    if (success) {
        NSLog(@"数据保存成功");
    } else {
        NSLog(@"保存失败");
    }
}


- (void)yl__initClient {
    // 配置
    BCECredentials *credentials = [[BCECredentials alloc] init];
    credentials.accessKey = accessKey;
    credentials.secretKey = secretKey;
    BOSClientConfiguration *configuration = [[BOSClientConfiguration alloc] init];
    configuration.region = [BCERegion region:BCERegionGZ];
    configuration.credentials = credentials;
    BOSClient *client = [[BOSClient alloc] initWithConfiguration:configuration];
    self.client = client;
}

- (void)uploadImagePath:(NSString *)imagePath imageName:(NSString *)imageName {
    
    BOSObjectContent *content = [[BOSObjectContent alloc] init];
    content.objectData.file = imagePath;
    BOSPutObjectRequest *request = [[BOSPutObjectRequest alloc] init];
    request.bucket = bucketName;
    request.key = imageName;
    request.objectContent = content;
    __block BOSPutObjectResponse *response;
    BCETask *task1 = [self.client putObject:request];
    task1.then(^(BCEOutput *output){
        if (output.response) {
            response = (BOSPutObjectResponse *)output.response;
            NSLog(@"上传成功：%@", response.metadata.eTag);
        }
        if (output.error) {
            NSLog(@"打印错误：%@", output.error);
        }
        if (output.progress) {
            NSLog(@"打印进度：%@", output.progress);
        }
    });
    [task1 waitUtilFinished];
}

- (void)uploadImageData:(NSData *)imageData imageName:(NSString *)imageName {
    
    // -----------------------------------------------------------
    BOSObjectContent *content = [[BOSObjectContent alloc] init];
    content.objectData.data = imageData;
    BOSPutObjectRequest *request = [[BOSPutObjectRequest alloc] init];
    request.bucket = bucketName;
    request.key = imageName;
    request.objectContent = content;
    __block BOSPutObjectResponse *response;
    BCETask *task1 = [self.client putObject:request];
    task1.then(^(BCEOutput *output){
        if (output.response) {
            response = (BOSPutObjectResponse *)output.response;
            NSLog(@"上传成功：%@", response.metadata.eTag);
        }
        if (output.error) {
            NSLog(@"打印错误：%@", output.error);
        }
        if (output.progress) {
//            NSLog(@"打印进度：%@", output.progress);
        }
    });
    [task1 waitUtilFinished];
}

- (void)yl_initView {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(YLMargin, YLMargin, 100, 30)];
    title.backgroundColor = YLColor(233.f, 233.f, 233.f);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = [NSString stringWithFormat:@"第%ld张", index + 1];
    [self.view addSubview:title];
    self.titleL = title;
    
    if (self.type == YLImageControllerTypeVehicle) {
        UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame) + YLMargin, YLMargin, 200, 30)];
        title1.backgroundColor = YLColor(233.f, 233.f, 233.f);
        title1.textAlignment = NSTextAlignmentCenter;
        title1.text = [NSString stringWithFormat:@"%@", self.titleArray[0]];
        [self.view addSubview:title1];
        self.titleL1 = title1;
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(YLMargin, CGRectGetMaxY(title.frame) + YLMargin, YLScreenWidth - 2 * YLMargin, 300);
    imageView.backgroundColor = YLColor(233.f, 233.f, 233.f);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    UIButton *last = [UIButton buttonWithType:UIButtonTypeCustom];
    last.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + YLMargin, 100, 40);
    [last setTitle:@"上一张" forState:UIControlStateNormal];
    last.backgroundColor = [UIColor redColor];
//    [last setUserInteractionEnabled:NO];
    [last addTarget:self action:@selector(lastImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:last];
    self.last = last;
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    next.frame = CGRectMake(200, CGRectGetMaxY(imageView.frame) + YLMargin, 100, 40);
    [next setTitle:@"下一张" forState:UIControlStateNormal];
    next.backgroundColor = [UIColor redColor];
    [next addTarget:self action:@selector(nextImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:next];
    self.next = next;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, CGRectGetMaxY(last.frame) + YLMargin, 100, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"拍照" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(200, CGRectGetMaxY(last.frame) + YLMargin, 100, 40);
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"提交" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UILabel *remarks = [[UILabel alloc] initWithFrame:CGRectMake(YLMargin, CGRectGetMaxY(btn1.frame) + YLMargin, 200, 40)];
    remarks.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self.view addSubview:remarks];
    self.remarks = remarks;
}

- (void)commit {
    NSLog(@"提交图片");
    
    // 显示菊花
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.detailsLabel.text = @"正在上传中，请稍后";
    [hub showAnimated:YES];
    [self.view addSubview:hub];
    
    // 上传图片到BOS
    NSInteger count = 0;
    for (NSInteger i = 0; i < self.imageModels.count; i++) {
        
        YLImageModel *model = self.imageModels[i];
        if ([model.img containsString:@"file://"]) {
            NSString *key = [NSString stringWithFormat:@"images/%@_%@_%ld", self.group, self.allOrderModel.detailId, i];
            if (!model.isUpdata) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.img]];
                [self uploadImageData:data imageName:key];
                NSLog(@"%ld", count);
                count++;
                model.isUpdata = YES;
            }
        }
    }
    
    // 提交信息到后台
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i = 0; i < self.imageModels.count; i++) {
        YLImageModel *model = self.imageModels[i];
        if ([model.img containsString:@"file://"]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (!model.remarks) {
                [dict setObject:@"" forKey:@"remarks"];
            } else {
                [dict setObject:model.remarks forKey:@"remarks"];
            }
            
            [dict setObject:model.sortNo forKey:@"sortNo"];
            [images addObject:dict];
        }
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:images options:NSJSONReadingMutableLeaves error:nil];
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"dataString:%@", dataString);
    NSString *urlString = [NSString stringWithFormat:@"%@/image?method=add", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.allOrderModel.detailId forKey:@"detailId"];
    [param setObject:self.group forKey:@"group"];
    [param setObject:dataString forKey:@"image"];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        
        [hub removeFromSuperview];
        [NSString showMessageWithString:@"提交成功"];
        
        if (weakSelf.refreshBlock) {
            weakSelf.refreshBlock();
        }
    } failed:nil];
    
}

// 获取图片网址
//- (void)yl__getObjectUrlwithObjectKey:(NSString *)objectKey {
//    
//    __block BOSGeneratePresignedUrlResponse *generateObjectUrlResponse = nil;
//    BCEOutput *output = [self.client generatePresignedUrl:bucketName objectKey:objectKey expirationInSeconds:-1];// -1是永久不失效，没有配置expirationInSeconds，默认是1800s
//    if (output.response) {
//        generateObjectUrlResponse = (BOSGeneratePresignedUrlResponse *)output.response;
//        NSLog(@"get url success, the usrlstting is : %@", [generateObjectUrlResponse.objectUrl absoluteString]);
//    }
//    if (output.error) {
//        NSLog(@"get url failure, error : %@:", output.error);
//    }
//    
//}

- (void)lastImage {

    index--;
    if (index < 0) {
        NSLog(@"这是第一张图,不能再点击上一张按钮");
        index = 0;
    }
    self.titleL.text = [NSString stringWithFormat:@"第%ld张", index + 1];
    
    
    CGFloat labH = 30;
    CGSize screenSzie = [UIScreen mainScreen].bounds.size;
    CGSize detailTitleSize = [self.titleArray[index] getSizeWithFont:[UIFont systemFontOfSize:12]];
    self.titleL1.transform = CGAffineTransformRotate(self.titleL1.transform, -M_PI_2);
    self.titleL1.frame = CGRectMake(0, 0, detailTitleSize.width + 20, labH);
    self.titleL1.center = CGPointMake(screenSzie.width - 15 - labH / 2 - 10, CGRectGetMaxY(self.imageView.frame) - 20 - detailTitleSize.width / 2);
    self.titleL1.transform = CGAffineTransformRotate(self.titleL1.transform, M_PI_2);
    self.titleL1.text = [NSString stringWithFormat:@"%@", self.titleArray[index]];
    
    
    YLImageModel *model = self.imageModels[index];
    NSString *placeholder;
    if (!model.img) {
        placeholder = @"占位图";
    } else {
        placeholder = @"优卡二手车";
    }
    self.remarks.text = model.remarks;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:placeholder]];
}

- (UIImage *)rescaleImage:(UIImage *)image Size:(CGSize)size {
    
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];  // scales image to rect
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImage;
}

- (void)nextImage {
    
    index++;
    if (index > 29) {
        NSLog(@"最后一张图,不能再点击上一张按钮");
        index = 29;
    }
    self.titleL.text = [NSString stringWithFormat:@"第%ld张", index + 1];
    
    CGFloat labH = 30;
    CGSize screenSzie = [UIScreen mainScreen].bounds.size;
    CGSize detailTitleSize = [self.titleArray[index] getSizeWithFont:[UIFont systemFontOfSize:12]];
    self.titleL1.transform = CGAffineTransformRotate(self.titleL1.transform, -M_PI_2);
    self.titleL1.frame = CGRectMake(0, 0, detailTitleSize.width + 20, labH);
    self.titleL1.center = CGPointMake(screenSzie.width - 15 - labH / 2 - 10, CGRectGetMaxY(self.imageView.frame) - 20 - detailTitleSize.width / 2);
    self.titleL1.transform = CGAffineTransformRotate(self.titleL1.transform, M_PI_2);
    self.titleL1.text = [NSString stringWithFormat:@"%@", self.titleArray[index]];
    
    YLImageModel *model = self.imageModels[index];
    NSString *placeholder;
    if (!model.img) {
        placeholder = @"占位图";
    } else {
        placeholder = @"优卡二手车";
    }
    self.remarks.text = model.remarks;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:placeholder]];
}

- (void)actionPhoto {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        NSLog(@"没有摄像头");
    }
}

- (void)saveImageToLocation:(UIImage *)image {
    NSMutableArray *images = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        // 记录本地标识
        [images addObject:req.placeholderForCreatedAsset.localIdentifier];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@", success, error);
        if (success) {
            __block PHAsset *imageAsset = nil;
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:images options:nil];
            [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                imageAsset = obj;
                *stop = YES;
            }];
            if (imageAsset) {
                // 加载图片数据
                [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    NSURL *imageUrl = [info valueForKey:@"PHImageFileURLKey"];
                    YLImageModel *model = [[YLImageModel alloc] init];
                    model.img = [NSString stringWithFormat:@"%@", imageUrl];
                    model.sortNo = [NSString stringWithFormat:@"%ld", self->index];
                    model.remarks = [NSString stringWithFormat:@"%ld", self->index];
                    [self.imageModels replaceObjectAtIndex:self->index withObject:model];
                    self.imageView.image = image;
                }];
            }
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSLog(@"finish");
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        [self saveImageToLocation:image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


//- (void)setImageUrls:(NSArray *)imageUrls {
//    _imageUrls = imageUrls;
//
//    // 将传过来的数据解析
//    for (YLImageModel *model in imageUrls) {
//        // 替换数组里的成员
//        [self.imagePaths replaceObjectAtIndex:[model.sortNo integerValue] withObject:model.img];
//        NSLog(@"%@", model.img);
//    }
//
//}

- (NSMutableArray *)imagePaths {
    if (!_imagePaths) {
        _imagePaths = [NSMutableArray arrayWithObjects:@"",@"", @"", @"", @"", @"",@"", @"", @"", @"", @"",@"", @"", @"", @"", @"",@"", @"", @"", @"", @"",@"", @"", @"", @"", @"",@"", @"", @"", @"", nil];
//        NSLog(@"_imagePaths.count:%ld", _imagePaths.count);
    }
    return _imagePaths;
}
- (NSMutableArray *)imageRemarks {
    if (!_imageRemarks) {
        _imageRemarks = [NSMutableArray arrayWithObjects:@"",@"", @"", @"", @"", @"",@"", @"", @"", @"", @"",@"", @"", @"", @"", @"",@"", @"", @"", @"", @"",@"", @"", @"", @"", @"",@"", @"", @"", @"", nil];
    }
    return _imageRemarks;
}
- (NSMutableArray *)imageModels {
    if (!_imageModels) {
        _imageModels = [NSMutableArray array];
    }
    return _imageModels;
}

- (NSMutableArray *)objImageUrls {
    if (!_objImageUrls) {
        _objImageUrls = [NSMutableArray array];
    }
    return _objImageUrls;
}

- (void)setType:(YLImageControllerType)type {
    _type = type;
}

- (void)setAllOrderModel:(YLAllOrderModel *)allOrderModel {
    _allOrderModel = allOrderModel;
}

- (void)setGroup:(NSString *)group {
    _group = group;
}

@end
