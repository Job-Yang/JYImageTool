//
//  YTZGetColourVC.m
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 16/3/25.
//  Copyright © 2016年 Job-Yang. All rights reserved.
//

#import "YTZGetColourVC.h"
#import "YTZImageComparison.h"

//屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface YTZGetColourVC ()

@property(strong, nonatomic) UIImageView *imageView;

@end

@implementation YTZGetColourVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self nextImage];
}

#pragma mark - setup methods

- (void)initUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 114, SCREEN_WIDTH-100, SCREEN_HEIGHT-100-114)];
    [_imageView setContentMode:UIViewContentModeScaleToFill];
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActon:)];
    [_imageView addGestureRecognizer:tap];
    [self.view addSubview:_imageView];
    
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

- (void)tapActon:(UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:_imageView];
    
    //得到对应点颜色
    YTZGetColour *getColour = [[YTZGetColour alloc]init];
    self.view.backgroundColor = [getColour getPixelColorAtLocation:point inImage:_imageView.image formImageRect:_imageView.frame];
}

- (void)nextImage {
    //随机拿一张图。
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",(arc4random()%11)+1] ofType:@"png"];
    UIImage *currentImage = [UIImage imageWithContentsOfFile:imagePath];
    _imageView.image = currentImage;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
