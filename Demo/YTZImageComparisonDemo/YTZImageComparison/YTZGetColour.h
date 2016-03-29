//
//  YTZGetColour.h
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 16/3/24.
//  Copyright © 2016年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTZGetColour : NSObject

/**
 *  获得point点处的颜色
 *
 *  @param point  坐标
 *  @param image  图片
 *  @param rect   图片Rect
 *
 *  @return 返回point点处的颜色
 */
- (UIColor*)getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image formImageRect:(CGRect)rect;

@end
