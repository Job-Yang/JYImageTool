//
//  JYImageTool.h
//  JYImageTool
//
//  Created by 杨权 on 15/9/15.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

//判断相同条件
#define EQUAL_HRESHOLD 0.95
//两个图片的比较次数
#define IMAGE_COMPARISON_COUNT 4
//每种颜色维度像元分辨率
#define COLOR_CUBE_RESOLUTION 20
//过滤鲜艳的颜色阈值
#define BRIGHT_COLOR_THRESHOLD 0.6
//过滤暗淡的颜色阈值
#define DARK_COLOR_THRESHOLD 0.4
//不同的颜色阈值(颜色空间距离)
#define DISTINCT_COLOR_THRESHOLD 0.2
//辅助宏计算线性cell下标
#define CELL_INDEX(r,g,b) (r + g*COLOR_CUBE_RESOLUTION + b*COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION)
//辅助宏计算cell总数
#define CELL_COUNT COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION

/**
 *  取色方式Flags
 */
typedef NS_OPTIONS(NSInteger, JYImageFlags) {
    JYImageOnlyBrightColors   = 1 << 0, //忽略所有比阈值暗的像素
    JYImageOnlyDarkColors     = 1 << 1, //忽略所有比阈值亮的像素
    JYImageOnlyDistinctColors = 1 << 2, //只保留区别度很大的颜色
    JYImageOrderByBrightness  = 1 << 3, //按照颜色鲜艳度排序
    JYImageOrderByDarkness    = 1 << 4, //按照颜色灰度排序
    JYImageAvoidWhite         = 1 << 5, //忽略接近白色颜色
    JYImageAvoidBlack         = 1 << 6  //忽略接近黑色颜色
};

/**
 颜色集Cell
 */
typedef struct {
    NSUInteger hitCount; //命中计数（该值除以累加器给出的平均值）
    CGFloat    redAcc;   //累加器的红色分量
    CGFloat    greenAcc; //累加器的绿色分量
    CGFloat    blueAcc;  //累加器的蓝色分量
    
} JYCubeCell;


@interface JYLocalMaximum : NSObject
/**
 命中次数
 */
@property (assign, nonatomic) NSUInteger hitCount;
/**
 cell线性下标
 */
@property (assign, nonatomic) NSUInteger cellIndex;
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
 最大颜色组件值的平均颜色
 */
@property (assign, nonatomic) CGFloat brightness;

@end

//这个类实现了一个简单的方法来提取图像的主色。
//它是如何做的:它将所有像素图像投射到三维网格(“立方体”)
//然后找在网格当前最大值，并返回这些“最大cell”的平均颜色
//他们的命中次数（“颜色频率”）排序。
//你应该开启一个后台线程执行这些方法。方法执行的时间取决于图像大小

@interface JYImageTool : NSObject

/**
 *  单例
 *
 *  @return JYImageTool对象
 */
+ (instancetype)tool;

/**
 *  获取rect内的图片上下文
 *
 *  @param image 图片
 *  @param rect  rect
 *
 *  @return  参数image的上下文
 */
- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)image
                                       imageRect:(CGRect)rect;


/**
 *  获取image的主色
 *  avoidColor必须为colorWithRed方法创建，UIColor的类方法创建的无法获取它的RGBA
 *
 *  @param image 图片
 *  @param flags 取色方式
 *
 *  @return 返回主色数组/无主色则返回nil
 */
- (NSArray<UIColor *> *)extractColorsFromImage:(UIImage *)image
                                         flags:(NSUInteger)flags;


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
- (NSArray<UIColor *> *)extractColorsFromImage:(UIImage *)image
                                         flags:(NSUInteger)flags
                                    avoidColor:(UIColor*)avoidColor;



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
- (NSArray<UIColor *> *)extractBrightColorsFromImage:(UIImage *)image
                                          avoidColor:(UIColor*)avoidColor
                                            maxCount:(NSUInteger)maxCount;

/**
 *  判断图片是否相同
 *
 *  @param imageOne 图片1
 *  @param imageTwo 图片2
 *
 *  @return 是否相同
 */
- (BOOL)isEqualToImage:(UIImage *)imageOne
              imageTwo:(UIImage *)imageTwo;

/**
 *  获得point点处的颜色
 *
 *  @param point  坐标
 *  @param image  图片
 *  @param rect   图片Rect
 *
 *  @return 返回point点处的颜色
 */
- (UIColor *)pixelColorAtLocation:(CGPoint)point
                          inImage:(UIImage *)image
                    formImageRect:(CGRect)rect;

@end
