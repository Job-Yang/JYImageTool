//
//  UIImage+JYImageTool.m
//  JYImageToolDemo
//
//  Created by 杨权 on 2017/9/6.
//  Copyright © 2017年 Job-Yang. All rights reserved.
//

#import "UIImage+JYImageTool.h"

@implementation UIImage (JYImageTool)

- (NSArray<UIColor *> *)extractColors {
    return [self extractColorsWithMode:JYExtractModeOnlyDistinctColors avoidColor:nil];
}

- (NSArray<UIColor *> *)extractColorsWithMode:(JYExtractMode)mode {
    return [self extractColorsWithMode:mode avoidColor:nil];
}

- (NSArray<UIColor *> *)extractColorsWithMode:(JYExtractMode)mode
                                   avoidColor:(UIColor *)avoidColor {
    return [self extractColorsWithMode:mode avoidColor:avoidColor colorCount:10];
}

- (NSArray<UIColor *> *)extractColorsWithMode:(JYExtractMode)mode
                                   avoidColor:(UIColor *)avoidColor
                                   colorCount:(NSUInteger)colorCount {
    if (!self) {return nil;}
    
    NSArray<JYColorBox *> *sortedMaxima = [[JYImageCore core] extractAndFilterMaximaFromImage:self mode:mode];
    if (avoidColor) {
        sortedMaxima = [[JYImageCore core] filterMaxima:sortedMaxima color:avoidColor];
    }
    sortedMaxima = [[JYImageCore core] adaptiveFilteringForMaxima:sortedMaxima count:colorCount];
    return [[JYImageCore core] colorsFromMaxima:sortedMaxima];
}

//对比两张图片是否相等
- (BOOL)isEqualToImage:(UIImage *)image {
    
    if (!self) {return NO;}

    //图片压缩尺寸
    CGRect rect = CGRectMake(0, 0, kJYColorLength, kJYColorLength);
    //获得第一张图片的ARGB信息
    CGImageRef ImageOneRef = self.CGImage;
    CGContextRef cgctxOne = [[JYImageCore core] createARGBBitmapContextFromImage:ImageOneRef imageRect:rect];
    CGContextDrawImage(cgctxOne, rect, ImageOneRef);
    unsigned char *dataOne = CGBitmapContextGetData(cgctxOne);
    
    //释放cgctxOne
    CGContextRelease(cgctxOne);
    
    //获得第二张图片的ARGB信息
    CGImageRef ImageTwoRef = image.CGImage;
    CGContextRef cgctxTwo = [[JYImageCore core] createARGBBitmapContextFromImage:ImageTwoRef imageRect:rect];
    CGContextDrawImage(cgctxTwo, rect, ImageTwoRef);
    unsigned char* dataTwo = CGBitmapContextGetData(cgctxTwo);
    
    //释放cgctxTwo
    CGContextRelease(cgctxTwo);
    
    //相等像素数
    NSUInteger EqualCount = 0;
    
    //遍历重绘尺寸的每个像素点
    for (NSUInteger i = 0; i < kJYColorLength * kJYColorLength - 1; i++) {
        float redOne   = dataOne[4*i+1]/255.0;
        float greenOne = dataOne[4*i+2]/255.0;
        float blueOne  = dataOne[4*i+3]/255.0;
        
        float redTwo   = dataTwo[4*i+1]/255.0;
        float greenTwo = dataTwo[4*i+2]/255.0;
        float blueTwo  = dataTwo[4*i+3]/255.0;
        
        //颜色空间距离，距离表示色差大小
        float difference = pow(pow((redOne - redTwo), 2) + pow((greenOne - greenTwo), 2) + pow((blueOne - blueTwo), 2), 0.5);
        
        //色差小于阀值
        if (difference < kJYDistinctColorThreshold) {
            EqualCount ++;
        }
    }
    
    //释放dataOne与dataTwo
    free(dataOne);
    free(dataTwo);
    
    NSLog(@"匹配度：%ld/%ld",EqualCount, kJYColorLength * kJYColorLength);
    
    //大于相等条件即为相等
    if (EqualCount > kJYColorLength * kJYColorLength * kJYSuitability) {
        return YES;
    }
    else{
        return NO;
    }
}

//获取图片点point处的像素颜色
- (UIColor *)pixelColorAtLocation:(CGPoint)point
                    formImageRect:(CGRect)rect {
    
    //获得图片上下文
    UIColor *color = nil;
    CGImageRef inImage = self.CGImage;
    CGContextRef cgctx = [[JYImageCore core] createARGBBitmapContextFromImage:inImage imageRect:rect];
    if (cgctx == NULL) return nil;
    
    //获取重绘图片大小
    size_t w = rect.size.width;
    size_t h = rect.size.height;
    CGRect newRect = {{0,0},{w,h}};
    
    //重绘图片
    CGContextDrawImage(cgctx, newRect, inImage);
    
    //获得图片ARGB色彩分量
    unsigned char *data = CGBitmapContextGetData (cgctx);
    
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
    if (data) {free(data);}
    return color;
}

- (NSString *)identifyQRCode {
    if (!self) {return nil;}
    //取出选中的图片
    NSData *imageData = UIImageJPEGRepresentation(self, 1.0);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    //创建探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:nil
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyLow}];
    NSArray *feature = [detector featuresInImage:ciImage];
    
    //取出探测到的数据
    for (CIQRCodeFeature *result in feature) {
        return result.messageString;
    }
    return nil;
}

+ (UIImage *)QRCodeImageFromString:(NSString *)string
                         imageSize:(CGFloat)imageSize {
    
    return [UIImage QRCodeImageFromString:string
                                imageSize:imageSize
                            logoImageName:nil
                                 logoSize:0];
}

+ (UIImage *)QRCodeImageFromString:(NSString *)string
                         imageSize:(CGFloat)imageSize
                     logoImageName:(NSString *)logoImageName
                          logoSize:(CGFloat)logoSize {
    UIImage *outputImage;
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    //拿到二维码图片
    CIImage *image = [filter outputImage];
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(imageSize/CGRectGetWidth(extent), imageSize/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    //原图
    outputImage = [UIImage imageWithCGImage:scaledImage];
    
    if (logoImageName != nil && logoSize > 0) {
        //给二维码加 logo 图
        UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
        [outputImage drawInRect:CGRectMake(0,0 , imageSize, imageSize)];
        //logo图
        UIImage *logoImage = [UIImage imageNamed:logoImageName];
        //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的30%），太大会造成扫不出来
        [logoImage drawInRect:CGRectMake((imageSize-logoSize)/2.0, (imageSize-logoSize)/2.0, logoSize, logoSize)];
        outputImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return outputImage;
}

- (NSData *)compressImageToByte:(NSUInteger)maxLength {
    if (!self) {return nil;}
    CGFloat compression = 1.f;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    NSLog(@"原始尺寸:%@ 原始大小:%f KB---", NSStringFromCGSize(self.size), data.length/1024.f);
    
    if (data.length < maxLength) return data;
    NSLog(@"开始压缩图片...");

    CGFloat max = 1.f;
    CGFloat min = 0.f;
    for (NSInteger i = 0; i < 6; i++) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        }
        else if (data.length > maxLength) {
            max = compression;
        }
        else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    NSLog(@"压缩尺寸:%@ 压缩后大小:%f KB---", NSStringFromCGSize(resultImage.size), lastDataLength/1024.f);
    NSLog(@"结束压缩...");
    return data;
}

@end
