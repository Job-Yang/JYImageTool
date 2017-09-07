//
//  JYImageCore.h
//  JYImageToolDemo
//
//  Created by 杨权 on 2017/9/6.
//  Copyright © 2017年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  取色模式
 */
typedef NS_OPTIONS(NSUInteger, JYExtractMode) {
    JYExtractModeOnlyBrightColors   = 1 << 0, //忽略所有比阈值暗的像素
    JYExtractModeOnlyDarkColors     = 1 << 1, //忽略所有比阈值亮的像素
    JYExtractModeOnlyDistinctColors = 1 << 2, //只保留区别度很大的颜色
    JYExtractModeOrderByBrightness  = 1 << 3, //按照颜色鲜艳度排序
    JYExtractModeOrderByDarkness    = 1 << 4, //按照颜色灰度排序
    JYExtractModeAvoidWhite         = 1 << 5, //忽略接近白色颜色
    JYExtractModeAvoidBlack         = 1 << 6  //忽略接近黑色颜色
};

@class JYColorBox;
@interface JYImageCore : NSObject

/**
 *  像素匹配度[0-1]
 *  默认为0.95（95%的像素匹配则看做图片相等）
 */
extern const CGFloat kJYSuitability;

/**
 *  颜色分量边长
 *  默认为20(此时的颜色空间为20*20*20)
 *  此参数不宜设置过大，否则会带来额外的运算量
 */
extern const NSUInteger kJYColorLength;

/**
 *  暗淡的颜色分量阈值[0-1]
 *  默认为0.6(即大于153(255*0.4)颜色分量视为鲜艳)
 */
extern const CGFloat kJYBrightColorThreshold;

/**
 *  鲜艳的颜色分量阈值[0-1]
 *  默认为0.4(即小于102(255*0.6)颜色分量视为暗淡)
 */
extern const CGFloat kJYDarkColorThreshold;

/**
 *  不同颜色分量阈值
 *  默认为0.2(即在颜色空间中，两个颜色距离大于0.2才视为不同颜色)
 */
extern const CGFloat kJYDistinctColorThreshold;

/**
 *  单例
 *
 *  @return JYImageCore对象
 */
+ (instancetype)core;

/**
 获取矩形Rect内的图片上下文

 @param image 图片
 @param rect  矩形Rect
 @return image的上下文
 */
- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)image
                                       imageRect:(CGRect)rect;

/**
 提取并过滤图片中的极大值数组
 
 @param image 待提取图片
 @param mode  取色模式
 @return 排序后极大值数组
 */
- (NSArray<JYColorBox *> *)extractAndFilterMaximaFromImage:(UIImage *)image
                                                      mode:(JYExtractMode)mode;

/**
 获取排序的图片中的极大值数组

 @param image 待提取图片
 @param mode  取色模式
 @return 排序后极大值数组
 */
- (NSArray<JYColorBox *> *)findSortedMaximaInImage:(UIImage *)image
                                              mode:(JYExtractMode)mode;

/**
 极大值数组 -> 颜色数组

 @param maxima 极大值数组
 @return 颜色数组
 */
- (NSArray<UIColor *> *)colorsFromMaxima:(NSArray<JYColorBox *> *)maxima;

/**
 过滤极大值数组

 @param maxima 极大值数组
 @param color 过滤的颜色
 @return 过滤后极大值数组
 */
- (NSArray<JYColorBox *> *)filterMaxima:(NSArray<JYColorBox *> *)maxima
                                  color:(UIColor *)color;

/**
 自适应阈值过滤调整

 @param maxima 极大值数组
 @param count  调整次数
 @return 过滤后极大值数组
 */
- (NSArray<JYColorBox *> *)adaptiveFilteringForMaxima:(NSArray<JYColorBox *> *)maxima
                                                count:(NSUInteger)count;
@end


/**
 颜色空间中每个颜色的基本元
 使用结构体可以提升效率
 */
typedef struct JYColorUnit {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    NSUInteger hitCount;
} JYColorUnit;

@interface JYColorBox : NSObject
/**
 命中次数
 */
@property (assign, nonatomic) NSUInteger hitCount;
/**
 cell红色平均值
 */
@property (assign, nonatomic) CGFloat red;
/**
 cell红色平均值
 */
@property (assign, nonatomic) CGFloat green;
/**
 cell红色平均值
 */
@property (assign, nonatomic) CGFloat blue;
/**
 cell线性下标
 */
@property (assign, nonatomic) NSUInteger cellIndex;
/**
 颜色分量极大值
 */
@property (assign, nonatomic) CGFloat brightness;

@end
