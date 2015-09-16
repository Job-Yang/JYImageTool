//
//  getColorViewController.m
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 15/9/16.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "getColorViewController.h"

@interface getColorViewController ()

@end

/*----利用 getPixelColorAtLocation 方法进行图片相应点颜色的提取----*/

@implementation getColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.i = 0;
    [self imageColorPicker];

}

- (void)imageColorPicker {
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",self.i + 101]];
    self.ImageView.image = image;
    
    //在ImageView上添加一个手势，取得当前点击的坐标
    //由于ImageView本身默认不响应事件，故应将interation属性设置为YES（我在storyboard中设置）
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActon:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.ImageView addGestureRecognizer:tap];
}

- (void)tapActon:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.ImageView];
    
    //创建一个YTZImageComparison对象
    YTZImageComparison *comparison = [[YTZImageComparison alloc]init];
    self.view.backgroundColor = [comparison getPixelColorAtLocation:point inImage:self.ImageView.image formImageRect:self.ImageView.frame];
}

- (IBAction)NextAction:(id)sender {
    if (self.i < 6) {
        self.i ++;
    }
    else{
        self.i = 0;
    }
    [self imageColorPicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
