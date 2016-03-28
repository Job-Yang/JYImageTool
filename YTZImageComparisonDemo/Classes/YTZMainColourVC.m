//
//  YTZMainColourVC.m
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 16/3/25.
//  Copyright © 2016年 Job-Yang. All rights reserved.
//

#import "YTZMainColourVC.h"
#import "YTZMainColour.h"

//屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface YTZMainColourVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(strong, nonatomic) NSArray<UIColor *> *colorArr;
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UICollectionView *collectionView;

@end

@implementation YTZMainColourVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self nextImage];
}


#pragma mark - setup methods

- (void)initUI {
    
    self.view.backgroundColor = [UIColor whiteColor];

    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-150-64)];
    [_imageView setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:_imageView];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(100, 100);
    flowLayout.minimumInteritemSpacing = 0.f;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-150, SCREEN_WIDTH, 100)collectionViewLayout:flowLayout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate   = self;
    [self.view addSubview:_collectionView];
    
    [self setButton:@"NEXT" frame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    
}

- (void)setButton:(NSString *)name frame:(CGRect)frame {
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    button.titleLabel.font = [UIFont systemFontOfSize:30.f];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextImage) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}

- (void)nextImage {
    //随机拿一张图。
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",(arc4random()%11)+1] ofType:@"png"];
    UIImage *currentImage = [UIImage imageWithContentsOfFile:imagePath];
    _imageView.image = currentImage;
    
    //得到主色
    _colorArr = [[YTZMainColour sharedMainColour] extractColorsFromImage:currentImage flags:5];
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _colorArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = _colorArr[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat *components = CGColorGetComponents(_colorArr[indexPath.row].CGColor);
    NSLog(@"R:%.1f\tG:%.1f\tB:%.1f\tA:%.1f",components[0]*255,components[1]*255,components[2]*255,components[3]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
