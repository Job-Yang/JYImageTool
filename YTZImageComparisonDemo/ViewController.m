//
//  ViewController.m
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 15/9/15.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

/*----利用 extractBrightColorsFromImage 方法进行图片主色提取----*/


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.i = 0;
    [self dominantColorPicker];
}

- (void)dominantColorPicker {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",self.i + 101]];
    self.ImageView.image = image;
    
    //创建一个YTZImageComparison对象
    YTZImageComparison *comparison = [[YTZImageComparison alloc]init];
    
    //提取image优势色，无忽略色，取4个优势色
    NSArray *arr = [comparison extractBrightColorsFromImage:image avoidColor:nil count:4];
    
    //设置view1-view4背景色，由于每一次取出符合要求的颜色可能小小于count，故给没有取到颜色的色块刷新为白色
    if (arr.count == 1) {
        self.view1.backgroundColor = arr[0];
        self.view2.backgroundColor = [UIColor whiteColor];
        self.view3.backgroundColor = [UIColor whiteColor];
        self.view4.backgroundColor = [UIColor whiteColor];
    }
    else if (arr.count == 2) {
        self.view1.backgroundColor = arr[0];
        self.view2.backgroundColor = arr[1];
        self.view3.backgroundColor = [UIColor whiteColor];
        self.view4.backgroundColor = [UIColor whiteColor];
    }
    else if (arr.count == 3) {
        self.view1.backgroundColor = arr[0];
        self.view2.backgroundColor = arr[1];
        self.view3.backgroundColor = arr[2];
        self.view4.backgroundColor = [UIColor whiteColor];
    }
    else if (arr.count == 4) {
        self.view1.backgroundColor = arr[0];
        self.view2.backgroundColor = arr[1];
        self.view3.backgroundColor = arr[2];
        self.view4.backgroundColor = arr[3];
    }
    else {
        self.view1.backgroundColor = [UIColor whiteColor];
        self.view2.backgroundColor = [UIColor whiteColor];
        self.view3.backgroundColor = [UIColor whiteColor];
        self.view4.backgroundColor = [UIColor whiteColor];
    }
}

- (IBAction)NextActon:(id)sender {
    if (self.i < 6) {
        self.i ++;
    }
    else{
        self.i = 0;
    }
    
    [self dominantColorPicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
