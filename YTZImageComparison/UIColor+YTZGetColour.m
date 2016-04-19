//
//  UIColor+YTZGetColour.m
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 16/4/1.
//  Copyright © 2016年 Job-Yang. All rights reserved.
//

#import "UIColor+YTZGetColour.h"
#import "YTZMainColour.h"
#import "YTZMacro.h"

@implementation UIColor (YTZGetColour)

//获取图片点point处的像素颜色
+ (UIColor*)getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image formImageRect:(CGRect)rect {
    
    //获得图片上下文
    UIColor* color = nil;
    CGImageRef inImage = image.CGImage;
    CGContextRef cgctx = [[YTZMainColour sharedMainColour] createARGBBitmapContextFromImage:inImage imageRect:rect];
    if (cgctx == NULL) { return nil;}
    
    //获取重绘图片大小
    size_t w = rect.size.width;
    size_t h = rect.size.height;
    
    CGRect newRect = {{0,0},{w,h}};
    
    //重绘图片
    CGContextDrawImage(cgctx, newRect, inImage);
    
    //获得图片ARGB色彩分量
    unsigned char* data = CGBitmapContextGetData (cgctx);
    
    if (data != NULL) {
        //offset为偏移量，用于定位数组中的对应像素信息
        NSInteger offset = 4*((w*round(point.y))+round(point.x));
        CGFloat alpha =  data[offset];
        CGFloat red = data[offset+1];
        CGFloat green = data[offset+2];
        CGFloat blue = data[offset+3];
        
        NSLog(@"R:%.1f\tG:%.1f\tB:%.1f\tA:%.1f",red,green,blue,alpha);
        
        //取得该色
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:
                 (blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    //释放上下文空间
    CGContextRelease(cgctx);
    
    if (data) { free(data); }
    
    return color;
    
}


@end
