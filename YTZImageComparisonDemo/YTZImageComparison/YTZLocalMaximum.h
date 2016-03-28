//
//  YTZLocalMaximum.h
//  YTZImageComparison
//
//  Created by 杨权 on 15/9/15.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface YTZLocalMaximum : NSObject


//图像分析的过程中发现局部最大值。我们需要这个类通过cell命中次数排序。


//命中次数
@property (assign, nonatomic) unsigned int hitCount;

//cell线性指数
@property (assign, nonatomic) unsigned int cellIndex;

//cell颜色平均值
@property (assign, nonatomic) double red;
@property (assign, nonatomic) double green;
@property (assign, nonatomic) double blue;

//最大颜色组件值的平均颜色
@property (assign, nonatomic) double brightness;


@end
