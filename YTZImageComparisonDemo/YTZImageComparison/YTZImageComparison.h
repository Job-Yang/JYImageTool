//
//  YTZImageComparison.h
//  ColorCubeDemo
//
//  Created by 杨权 on 15/9/15.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "YTZLocalMaximum.h"


//这些标志决定如何提取颜色
typedef enum Flags: NSUInteger
{
    //这会忽略所有比阈值暗的像素
    OnlyBrightColors   = 1 << 0,
    
    //这会忽略所有比阈值亮的像素
    OnlyDarkColors     = 1 << 1,
    
    //这个过滤的结果数组中只存放区别度很大的颜色
    OnlyDistinctColors = 1 << 2,
    
    //如果没有进行特殊的设置，结果数组将按照颜色鲜艳度排序(第一个颜色鲜艳度最高)
    //颜色按出现频率排序(第一个颜色出现最频繁)
    OrderByBrightness  = 1 << 3,
    
    //如果没有进行特殊的设置，结果数组将按照颜色灰度排序(第一个颜色鲜艳度最低)
    //颜色按出现频率排序(第一个颜色出现最频繁)
    OrderByDarkness    = 1 << 4,
    
    //如果他们太接近白色,则从结果中删除颜色
    AvoidWhite         = 1 << 5,
    
    //如果他们太接近黑色,则从结果中删除颜色
    AvoidBlack         = 1 << 6
    
} Flags;


//颜色集Cell
typedef struct CubeCell {
    
    //命中计数（该值除以累加器给出的平均值）
    unsigned int hitCount;
    
    //累加器的颜色分量
    double redAcc;
    double greenAcc;
    double blueAcc;
    
} CubeCell;


//这个类实现了一个简单的方法来提取图像的优势色。
//它是如何做的:它将所有像素图像投射到三维网格(“立方体”)
//然后找在网格当前最大值，并返回这些“最大cell”的平均颜色
//他们的命中次数（“颜色频率”）排序。
//你应该开启一个后台线程执行这些方法。方法执行的时间取决于图像大小

@interface YTZImageComparison : NSObject


- (BOOL)isEqualToImage:(UIImage *)imageOne andImageTwo:(UIImage *)imageTwo;


- (BOOL)isSimilarToImage:(UIImage *)imageOne andImageTwo:(UIImage *)imageTwo;


- (UIColor*)getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image formImageRect:(CGRect)Rect;

//提取并返回image的优势色（数组中存放UIColor对象）。结果可能为空。
- (NSArray *)extractColorsFromImage:(UIImage *)image flags:(NSUInteger)flags;


//同上，但避免了色彩与指定的颜色太接近。
//重要提示：avoidColor必须是RGB色彩空间，所以用的UIColor的colorWithRed方法来创建它！
- (NSArray *)extractColorsFromImage:(UIImage *)image flags:(NSUInteger)flags avoidColor:(UIColor*)avoidColor;


//从image中获得鲜艳的色彩，指定的一个忽略的颜色（avoidColor不为空）。
//重要提示：avoidColor必须是RGB色彩空间，所以用的UIColor的colorWithRed方法来创建它！
//返回数组的长度可能会小于count值
- (NSArray *)extractBrightColorsFromImage:(UIImage *)image avoidColor:(UIColor*)avoidColor count:(NSUInteger)count;


//从image中获得暗淡的色彩，指定的一个忽略的颜色（avoidColor不为空）。
//重要提示：avoidColor必须是RGB色彩空间，所以用的UIColor的colorWithRed方法来创建它！
//返回数组的长度可能会小于count值
- (NSArray *)extractDarkColorsFromImage:(UIImage *)image avoidColor:(UIColor*)avoidColor count:(NSUInteger)count;

//获得image的颜色总数
//返回数组的长度可能会小于count值
- (NSArray *)extractColorsFromImage:(UIImage *)image flags:(NSUInteger)flags count:(NSUInteger)count;


@end
