//
//  YTZMainColour.h
//  YTZImageComparison
//
//  Created by 杨权 on 15/9/15.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//


#import <UIKit/UIKit.h>


/**
 *  取色方式Flags
 */
typedef NS_OPTIONS(NSInteger, Flags) {
    /**
     *  忽略所有比阈值暗的像素
     */
    OnlyBrightColors   = 1 << 0,
    /**
     *  忽略所有比阈值亮的像素
     */
    OnlyDarkColors     = 1 << 1,
    /**
     *  只保留区别度很大的颜色
     */
    OnlyDistinctColors = 1 << 2,
    /**
     *  如果没有进行特殊的设置，结果数组将按照颜色鲜艳度排序(第一个颜色鲜艳度最高)
     *  颜色按出现频率排序(第一个颜色出现最频繁)
     */
    OrderByBrightness  = 1 << 3,
    /**
     *  如果没有进行特殊的设置，结果数组将按照颜色灰度排序(第一个颜色鲜艳度最低)
     *  颜色按出现频率排序(第一个颜色出现最频繁)
     */
    OrderByDarkness    = 1 << 4,
    /**
     *  忽略接近白色颜色
     */
    AvoidWhite         = 1 << 5,
    /**
     *  忽略接近黑色颜色
     */
    AvoidBlack         = 1 << 6
};


//颜色集Cell
typedef struct CubeCell {
    
    //命中计数（该值除以累加器给出的平均值）
    unsigned int hitCount;
    
    //累加器的颜色分量
    double redAcc;
    double greenAcc;
    double blueAcc;
    
} CubeCell;


//这个类实现了一个简单的方法来提取图像的主色。
//它是如何做的:它将所有像素图像投射到三维网格(“立方体”)
//然后找在网格当前最大值，并返回这些“最大cell”的平均颜色
//他们的命中次数（“颜色频率”）排序。
//你应该开启一个后台线程执行这些方法。方法执行的时间取决于图像大小

@interface YTZMainColour : NSObject

/**
 *  单例
 *
 *  @return YTZMainColour对象
 */
+ (instancetype)sharedMainColour;

/**
 *  获取rect内的图片上下文
 *
 *  @param image 图片
 *  @param rect  rect
 *
 *  @return  参数image的上下文
 */
- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)image imageRect:(CGRect)rect;


/**
 *  获取image的主色
 *  avoidColor必须为colorWithRed方法创建，UIColor的类方法创建的无法获取它的RGBA
 *
 *  @param image 图片
 *  @param flags 取色方式
 *
 *  @return 返回主色数组/无主色则返回nil
 */
- (NSArray<UIColor *> *)extractColorsFromImage:(UIImage *)image flags:(NSUInteger)flags;


/**
 *  获取image的主色
 *  avoidColor必须为colorWithRed方法创建，UIColor的类方法创建的无法获取它的RGBA
 *
 *  @param image      图片
 *  @param flags      取色方式
 *  @param avoidColor 需要忽略的颜色
 *
 *  @return 返回主色数组/无主色则返回nil
 */
- (NSArray<UIColor *> *)extractColorsFromImage:(UIImage *)image flags:(NSUInteger)flags avoidColor:(UIColor*)avoidColor;



/**
 *  获取image的主色
 *  avoidColor必须为colorWithRed方法创建，UIColor的类方法创建的无法获取它的RGBA
 *
 *  @param image      图片
 *  @param avoidColor 需要忽略的颜色
 *  @param maxCount   最大主色数量
 *
 *  @return 返回主色数组/无主色则返回nil
 */
- (NSArray<UIColor *> *)extractBrightColorsFromImage:(UIImage *)image avoidColor:(UIColor*)avoidColor maxCount:(NSUInteger)maxCount;

@end
