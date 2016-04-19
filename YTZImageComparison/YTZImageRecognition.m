//
//  YTZImageRecognition.m
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 16/3/24.
//  Copyright © 2016年 Job-Yang. All rights reserved.
//

#import "YTZImageRecognition.h"
#import "YTZMainColour.h"
#import "YTZMacro.h"

@interface YTZImageRecognition()


@end

@implementation YTZImageRecognition

////通过不同方式取出相应优势色，如果每个优势色都匹配，即为相似图片
//- (BOOL)isSimilarToImage:(UIImage *)imageOne andImageTwo:(UIImage *)imageTwo {
//
//    //相似值
//    int Similarity = 0;
//
//    //分别取出两张图片的主色调数组
//    //返回一个颜色数组，数组按枚举Flags条件进行符合度排序
//    //avoidColor参数可以忽略一个RGB空间的色彩，使它不参与主色的提取
//    //count参数按照要求取多少个优势色
//    NSArray *imageOneArr = [[YTZMainColour sharedMainColour] extractBrightColorsFromImage:imageOne avoidColor:nil maxCount:IMAGE_COMPARISON_COUNT];
//    NSArray *imageTwoArr = [[YTZMainColour sharedMainColour] extractBrightColorsFromImage:imageTwo avoidColor:nil maxCount:IMAGE_COMPARISON_COUNT];
//
//    int LoopCount = (int)MIN(imageOneArr.count, imageTwoArr.count);
//
//    for (int i = 0; i < LoopCount; i++ ) {
//
//        //取得颜色的RGB分量
//        UIColor *imageOneColor = imageOneArr[i];
//        const CGFloat* componentsOne = CGColorGetComponents(imageOneColor.CGColor);
//        CGFloat RedOne, GreenOne, BlueOne;
//        RedOne = componentsOne[0];
//        GreenOne = componentsOne[1];
//        BlueOne = componentsOne[2];
//
//        //取得颜色的RGB分量
//        UIColor *imageTwoColor = imageTwoArr[i];
//        const CGFloat* componentsTwo = CGColorGetComponents(imageTwoColor.CGColor);
//        CGFloat RedTwo, GreenTwo, BlueTwo;
//        RedTwo = componentsTwo[0];
//        GreenTwo = componentsTwo[1];
//        BlueTwo = componentsTwo[2];
//
//        ///颜色空间距离，距离表示色差大小
//        float difference = pow( pow((RedOne - RedTwo), 2) + pow((GreenOne - GreenTwo), 2) + pow((BlueOne - BlueTwo), 2), 0.5 );
//        NSLog(@"difference = %f",difference);
//
//        //色差小于阀值表示优势色相似
//        if (difference < SIMILAR_HRESHOLD) {
//            Similarity ++;
//        }
//    }
//    NSLog(@"Similarity = %d",Similarity);
//    NSLog(@"----------------------------------");
//
//    //每个优势色都相似视为图片相似
//    if (Similarity == LoopCount) {
//        return YES;
//    }
//    else{
//        return NO;
//    }
//
//}

////两张图片是否相似
//- (BOOL)isSimilarToImage:(UIImage *)image1 andImageTwo:(UIImage *)image2 {
//    
//    NSLog(@"image1 = %@",image1);
//    
//    NSArray *pointArr = [self getImagePath:image1];
//    
//    NSLog(@"pointArr = %@",pointArr);
//    
//    return YES;
//    
//}
//
//
//- (NSArray *)getImagePath:(UIImage *)image {
//    
//    NSLog(@"image = %@",image);
//    
//    NSMutableArray *pointArr = [[NSMutableArray alloc]init];
//    
//    NSArray *imageArr = [[YTZMainColour sharedMainColour] extractBrightColorsFromImage:image avoidColor:nil count:IMAGE_COMPARISON_COUNT];
//    
//    //图片压缩尺寸
//    CGRect rect = CGRectMake(0, 0, COLOR_CUBE_RESOLUTION, COLOR_CUBE_RESOLUTION);
//    
//    //获得图片的ARGB信息
//    CGImageRef ImageOneRef = image.CGImage;
//    CGContextRef cgctx = [[YTZMainColour sharedMainColour] createARGBBitmapContextFromImage:ImageOneRef inIamgeRect:rect];
//    CGContextDrawImage(cgctx, rect, ImageOneRef);
//    unsigned char* colorData = CGBitmapContextGetData (cgctx);
//    
//    //释放cgctxOne
//    CGContextRelease(cgctx);
//    
//    //遍历重绘尺寸的每个像素点
//    for (int i = 0; i < COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION - 1; i++) {
//        
//        CGFloat red   = colorData[4*i+1]/255.f;
//        CGFloat green = colorData[4*i+2]/255.f;
//        CGFloat blue  = colorData[4*i+3]/255.f;
//        
//        for (UIColor *mianColor in imageArr) {
//            
//            //取得颜色的RGB分量
//            const CGFloat* components = CGColorGetComponents(mianColor.CGColor);
//            CGFloat mainRed, mainGreen, mainBlue;
//            mainRed   = components[0];
//            mainGreen = components[1];
//            mainBlue  = components[2];
//            
//            
//            if ((fabs(mainRed - red) < 0.001) && (fabs(mainGreen - green) < 0.001) && (fabs(mainBlue - blue) < 0.001)) {
//                
//                if (i <= COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION - 2) {
//                    
//                    CGFloat nextRed   = colorData[4*(i+1)+1]/255.f;
//                    CGFloat nextGreen = colorData[4*(i+1)+2]/255.f;
//                    CGFloat nextBlue  = colorData[4*(i+1)+3]/255.f;
//                    
//                    if (!((fabs(mainRed - nextRed) < 0.00001) && (fabs(mainGreen - nextGreen) < 0.00001) && (fabs(mainBlue - nextBlue) < 0.00001))) {
//                        
//                        CGPoint point = CGPointMake(i/COLOR_CUBE_RESOLUTION, i%COLOR_CUBE_RESOLUTION);
//                        NSValue *rectPoint = [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
//                        [pointArr addObject:rectPoint];
//                        
//                    }
//                }
//            }
//        }
//    }
//    
//    free(colorData);
//    
//    
//    return pointArr;
//}


@end
