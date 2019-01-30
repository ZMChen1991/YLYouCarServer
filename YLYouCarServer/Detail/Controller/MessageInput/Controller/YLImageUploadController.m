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
static NSString *const bucketName = @"image-public";

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
    
    [self yl_initView];
    [self yl__initClient];
    [self loadData];
    
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
    for (YLImageModel *model in arr) {
        for (NSInteger i = 0; i < self.imagePaths.count; i++) {
            if ([model.sortNo isEqualToString:[NSString stringWithFormat:@"%ld", i]]) {
                [self.imagePaths replaceObjectAtIndex:i withObject:model.img];
            }
        }
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imagePaths[0]] placeholderImage:[UIImage imageNamed:@"优卡二手车"]];
    NSLog(@"imagePaths:%@", self.imagePaths);
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
    imageView.contentMode = UIViewContentModeScaleToFill;
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
}

- (void)commit {
    NSLog(@"提交图片");
    [self.imageModels removeAllObjects];
    for (NSInteger i = 0; i < self.imagePaths.count; i++) {
        YLImageModel *model = [[YLImageModel alloc] init];
        NSString *string = [NSString stringWithFormat:@"%@", self.imagePaths[i]];
        
        if ([string containsString:@"file://"]) {
            model.img = string;
            model.sortNo = [NSString stringWithFormat:@"%ld", i];
            model.remarks = @"123";
            [self.imageModels addObject:model];
        }
    }
    NSLog(@"self.imageModels.count:%ld", self.imageModels.count);
    
    // 上传图片到BOS
    for (NSInteger i = 0; i < self.imageModels.count; i++) {
        NSString *key = [NSString stringWithFormat:@"images/%@_%@_%ld", self.group, self.allOrderModel.detailId, i];
        NSLog(@"%@", key);
        YLImageModel *model = self.imageModels[i];
        if ([model.img containsString:@"file://"]) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.img]];
            [self uploadImageData:data imageName:key];
        }
        
    }
    
    // 上传相关信息到后台
//    NSString *urlString = @"ucarjava.bceapp.com/image?method=add&detailId=xxx&group=xxx&image=xxx";
//    NSString *image = []
    /**
     [{ \"remarks\":\"xxx\",\"sortNo\":0},{ \"remarks\":\"xxx\",\"sortNo\":1}]
     */
}

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
    self.titleL1.text = [NSString stringWithFormat:@"%@", self.titleArray[index]];
    [self.imageView sd_setImageWithURL:self.imagePaths[index] placeholderImage:[UIImage imageNamed:@"优卡二手车"]];
}

- (void)nextImage {
    
    index++;
    if (index > 29) {
        NSLog(@"最后一张图,不能再点击上一张按钮");
        index = 29;
    }
    self.titleL.text = [NSString stringWithFormat:@"第%ld张", index + 1];
    self.titleL1.text = [NSString stringWithFormat:@"%@", self.titleArray[index]];
    [self.imageView sd_setImageWithURL:self.imagePaths[index] placeholderImage:[UIImage imageNamed:@"优卡二手车"]];
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
                    [self.imagePaths replaceObjectAtIndex:(NSUInteger)self->index withObject:imageUrl];
//                    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
                    self.imageView.image = image;
                    NSLog(@"self.imagePaths: %@ -\n- imageUrl:%@", self.imagePaths, imageUrl);
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


- (void)setImageUrls:(NSArray *)imageUrls {
    _imageUrls = imageUrls;
    
    // 将传过来的数据解析
    for (YLImageModel *model in imageUrls) {
        // 替换数组里的成员
        [self.imagePaths replaceObjectAtIndex:[model.sortNo integerValue] withObject:model.img];
        NSLog(@"%@", model.img);
    }
    
}

- (NSMutableArray *)imagePaths {
    if (!_imagePaths) {
        _imagePaths = [NSMutableArray arrayWithObjects:@"",@"", @"", @"", @"", @"",@"", @"", @"", @"", @"",@"", @"", @"", @"", @"",@"", @"", @"", @"", @"",@"", @"", @"", @"", @"",@"", @"", @"", @"", nil];
        NSLog(@"_imagePaths.count:%ld", _imagePaths.count);
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
