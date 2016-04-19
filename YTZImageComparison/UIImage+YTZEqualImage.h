//
//  UIImage+YTZEqualImage.h
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 16/4/1.
//  Copyright © 2016年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YTZEqualImage)

/**
 *  判断图片是否相同
 *
 *  @param imageOne 图片1
 *  @param imageTwo 图片2
 *
 *  @return 是否相同
 */
+ (BOOL)isEqualToImage:(UIImage *)imageOne imageTwo:(UIImage *)imageTwo;

@end
