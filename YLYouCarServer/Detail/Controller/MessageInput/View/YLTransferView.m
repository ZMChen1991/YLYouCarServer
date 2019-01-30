//
//  YLTransferView.m
//  YLYouCarServer
//
//  Created by lm on 2019/1/23.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLTransferView.h"

static NSString *const cellID = @"YLTransferView";

@interface YLTransferView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;

@end

@implementation YLTransferView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    CGFloat titleH = 40;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.bounds.size.width - 60 - YLMargin, 0, 60, titleH);
//    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn setTitleColor:YLColor(51.f, 51.f, 51.f) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    CGFloat titleW = 100.f;
    CGFloat titleX = YLScreenWidth / 2 - titleW / 2;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 0, titleW, titleH)];
    title.text = @"过户次数";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = YLColor(51.f, 51.f, 51.f);
    [self addSubview:title];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame) - 1, self.bounds.size.width, 1)];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = YLMargin;
    CGFloat itemMargin = YLMargin;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 2 * margin - 2 * itemMargin) / 3;
    layout.itemSize = CGSizeMake(width, 36);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    CGRect rect = CGRectMake(0, titleH, YLScreenWidth, 219);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.bounces = NO;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self addSubview:collectionView];
    self.collectView = collectionView;
}

- (void)cancelClick {
    NSLog(@"点击关闭");
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.backgroundColor = YLColor(233.f, 233.f, 233.f);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%ld次", indexPath.row];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = YLColor(51.f, 51.f, 51.f);
    [cell.contentView addSubview:label];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSString *transfer = [NSString stringWithFormat:@"%ld", indexPath.row];
    if (self.transferBlock) {
        self.transferBlock(transfer);
    }
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}
@end
