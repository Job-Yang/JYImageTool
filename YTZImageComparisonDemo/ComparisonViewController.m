//
//  ComparisonViewController.m
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 15/9/16.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "ComparisonViewController.h"

@interface ComparisonViewController ()

@end

/*----利用 isEqualToImage和isSimilarToImage 方法判断图片相同或者相似----*/

@implementation ComparisonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.i = 0;
    self.j = 0;
    [self imageComparison];
}

- (void)imageComparison {
    
    UIImage *imageOne = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",self.j + 101]];
    self.ImageOne.image = imageOne;
    
    UIImage *imageTwo = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",self.i + 101]];
    self.ImageTwo.image = imageTwo;
    
    //创建一个YTZImageComparison对象
    YTZImageComparison *comparison = [[YTZImageComparison alloc]init];
    
    //先使用isEqualToImage方法判断图片是否相等
    if ([comparison isEqualToImage:imageOne andImageTwo:imageTwo]) {
        self.Label.backgroundColor = [UIColor greenColor];
        self.Label.text = @"相同图片";
    }
    //再使用isEqualToImage方法判断图片是否相似
    else if ([comparison isSimilarToImage:imageOne andImageTwo:imageTwo]) {
        self.Label.backgroundColor = [UIColor blueColor];
        self.Label.text = @"相似图片";
    }
    else {
        self.Label.backgroundColor = [UIColor redColor];
        self.Label.text = @"无关图片";
    }
}

- (IBAction)NextAction:(id)sender {
    if (self.i < 6) {
        self.i ++;
    }
    else{
        self.j ++;
        self.i = 0;
    }
        if (self.j == 6) {
            self.j = 0;
        }
    [self imageComparison];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
