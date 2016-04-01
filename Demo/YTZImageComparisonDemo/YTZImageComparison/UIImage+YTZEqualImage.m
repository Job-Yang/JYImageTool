//
//  UIImage+YTZEqualImage.m
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 16/4/1.
//  Copyright © 2016年 Job-Yang. All rights reserved.
//

#import "UIImage+YTZEqualImage.h"
#import "YTZMainColour.h"
#import "YTZMacro.h"

@implementation UIImage (YTZEqualImage)

//对比两张图片是否相等
+ (BOOL)isEqualToImage:(UIImage *)imageOne imageTwo:(UIImage *)imageTwo {
    //图片压缩尺寸
    CGRect rect = CGRectMake(0, 0, COLOR_CUBE_RESOLUTION, COLOR_CUBE_RESOLUTION);
    
    //获得第一张图片的ARGB信息
    CGImageRef ImageOneRef = imageOne.CGImage;
    CGContextRef cgctxOne = [[YTZMainColour sharedMainColour] createARGBBitmapContextFromImage:ImageOneRef imageRect:rect];
    CGContextDrawImage(cgctxOne, rect, ImageOneRef);
    unsigned char* dataOne = CGBitmapContextGetData (cgctxOne);
    
    //释放cgctxOne
    CGContextRelease(cgctxOne);
    
    //获得第二张图片的ARGB信息
    CGImageRef ImageTwoRef = imageTwo.CGImage;
    CGContextRef cgctxTwo = [[YTZMainColour sharedMainColour] createARGBBitmapContextFromImage:ImageTwoRef imageRect:rect];
    CGContextDrawImage(cgctxTwo, rect, ImageTwoRef);
    unsigned char* dataTwo = CGBitmapContextGetData (cgctxTwo);
    
    //释放cgctxTwo
    CGContextRelease(cgctxTwo);
    
    //相等像素数
    int EqualCount = 0;
    
    //遍历重绘尺寸的每个像素点
    for (int i = 0; i < COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION - 1; i++) {
        
        float redOne = dataOne[4*i+1]/255.0;
        float greenOne = dataOne[4*i+2]/255.0;
        float blueOne = dataOne[4*i+3]/255.0;
        
        float redTwo = dataTwo[4*i+1]/255.0;
        float greenTwo = dataTwo[4*i+2]/255.0;
        float blueTwo = dataTwo[4*i+3]/255.0;
        
        //颜色空间距离，距离表示色差大小
        float difference = pow( pow((redOne - redTwo), 2) + pow((greenOne - greenTwo), 2) + pow((blueOne - blueTwo), 2), 0.5 );
        
        //色差小于阀值
        if (difference < DISTINCT_COLOR_THRESHOLD) {
            EqualCount ++;
        }
    }
    
    //释放dataOne与dataTwo
    free(dataOne);
    free(dataTwo);
    
    NSLog(@"匹配度：%d/%d",EqualCount,COLOR_CUBE_RESOLUTION * COLOR_CUBE_RESOLUTION);
    
    //大于相等条件即为相等
    if (EqualCount > COLOR_CUBE_RESOLUTION * COLOR_CUBE_RESOLUTION * EQUAL_HRESHOLD) {
        return YES;
    }
    else{
        return NO;
    }
}


@end
