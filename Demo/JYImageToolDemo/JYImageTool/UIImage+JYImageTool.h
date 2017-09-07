//
//  UIImage+JYImageTool.h
//  JYImageToolDemo
//
//  Created by 杨权 on 2017/9/6.
//  Copyright © 2017年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYImageCore.h"

@interface UIImage (JYImageTool)

/**
 提取图片中的主色

 @return 颜色数组
 */
- (NSArray<UIColor *> *)extractColors;

/**
 提取图片中的主色

 @param mode 取色模式
 @return 颜色数组
 */
- (NSArray<UIColor *> *)extractColorsWithMode:(JYExtractMode)mode;

/**
 提取图片中的主色

 @param mode       取色模式
 @param avoidColor 忽略特定颜色
 @return 颜色数组
 */
- (NSArray<UIColor *> *)extractColorsWithMode:(JYExtractMode)mode
                                   avoidColor:(UIColor *)avoidColor;

/**
 提取图片中的主色

 @param mode       取色模式
 @param avoidColor 忽略特定颜色
 @param colorCount 颜色最大数量
 @return 颜色数组
 */
- (NSArray<UIColor *> *)extractColorsWithMode:(JYExtractMode)mode
                                   avoidColor:(UIColor *)avoidColor
                                   colorCount:(NSUInteger)colorCount;

/**
 判断图片是否相同(基于像素对比)

 @param image 须比较的图片
 @return 是否相同
 */
- (BOOL)isEqualToImage:(UIImage *)image;


/**
 获得图片point点处的颜色

 @param point 坐标点
 @param rect  image所在视图（iMageView）的Frame
 @return return 颜色值
 */
- (UIColor *)pixelColorAtLocation:(CGPoint)point
                    formImageRect:(CGRect)rect;

/**
 识别图片中的二维码
 
 @return 二维码字符串
 */
- (NSString *)identifyQRCode;

/**
 生成二维码图片

 @param string    需要编码的字符串
 @param imageSize 生成图片的边长
 @return 二维码图片
 */
+ (UIImage *)QRCodeImageFromString:(NSString *)string
                         imageSize:(CGFloat)imageSize;

/**
 生成中心带logo二维码图片

 @param string        需要编码的字符串
 @param imageSize     生成图片的边长
 @param logoImageName logo图片名
 @param logoSize      logo尺寸
 @return 二维码图片
 */
+ (UIImage *)QRCodeImageFromString:(NSString *)string
                         imageSize:(CGFloat)imageSize
                     logoImageName:(NSString *)logoImageName
                          logoSize:(CGFloat)logoSize;

/**
 压缩图片

 @param maxLength 目标尺寸（压缩到小于等于该大小）
 @return 压缩后的图片Data
 */
- (NSData *)compressImageToByte:(NSUInteger)maxLength;

@end
