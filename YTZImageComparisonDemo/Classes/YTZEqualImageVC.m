//
//  YTZEqualImageVC.m
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 16/3/25.
//  Copyright © 2016年 Job-Yang. All rights reserved.
//

#import "YTZEqualImageVC.h"
#import "YTZEqualImage.h"

//屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface YTZEqualImageVC ()

@property(strong, nonatomic) UIImageView *imageViewOne;
@property(strong, nonatomic) UIImageView *imageViewTwo;
@property(strong, nonatomic) UILabel *label;

@end

@implementation YTZEqualImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self nextImage];
}

#pragma mark - setup methods

- (void)initUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageViewOne = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 64, SCREEN_WIDTH, SCREEN_HEIGHT/2-50)];
    [_imageViewOne setContentMode:UIViewContentModeScaleAspectFill];
    _imageViewOne.layer.masksToBounds = YES;
    [self.view addSubview:_imageViewOne];
    
    _imageViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2-50, SCREEN_WIDTH, SCREEN_HEIGHT/2-50)];
    [_imageViewTwo setContentMode:UIViewContentModeScaleAspectFill];
    _imageViewTwo.layer.masksToBounds = YES;
    [self.view addSubview:_imageViewTwo];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-80, 200, 60)];
    [_label setTextColor:[UIColor whiteColor]];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:35.f];
    [self.view addSubview:_label];
    
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
    //随机拿2张图。
    NSString *imagePath1 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",(arc4random()%11)+1] ofType:@"png"];
    NSString *imagePath2 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",(arc4random()%11)+1] ofType:@"png"];
    _imageViewOne.image = [UIImage imageWithContentsOfFile:imagePath1];
    _imageViewTwo.image = [UIImage imageWithContentsOfFile:imagePath2];
    
    //判断是否相同
    YTZEqualImage *equalImage = [[YTZEqualImage alloc]init];
    BOOL isEqual = [equalImage isEqualToImage:_imageViewOne.image imageTwo:_imageViewTwo.image];
    if (isEqual) {
        _label.backgroundColor = [UIColor greenColor];
        _label.text = @"相同图片";
    }
    else {
        _label.backgroundColor = [UIColor redColor];
        _label.text = @"不同图片";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
