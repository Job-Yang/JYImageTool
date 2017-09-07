//
//  JYImageCore.m
//  JYImageToolDemo
//
//  Created by 杨权 on 2017/9/6.
//  Copyright © 2017年 Job-Yang. All rights reserved.
//

#import "JYImageCore.h"

//RGBA颜色
#define RGBA(r, g, b, a) [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:a]

//临近cell三维网格下标
int neighbourIndices[27][3] = {
    { 0, 0, 0}, { 0, 0, 1}, { 0, 0,-1},
    { 0, 1, 0}, { 0, 1, 1}, { 0, 1,-1},
    { 0,-1, 0}, { 0,-1, 1}, { 0,-1,-1},
    { 1, 0, 0}, { 1, 0, 1}, { 1, 0,-1},
    { 1, 1, 0}, { 1, 1, 1}, { 1, 1,-1},
    { 1,-1, 0}, { 1,-1, 1}, { 1,-1,-1},
    {-1, 0, 0}, {-1, 0, 1}, {-1, 0,-1},
    {-1, 1, 0}, {-1, 1, 1}, {-1, 1,-1},
    {-1,-1, 0}, {-1,-1, 1}, {-1,-1,-1}
};

@implementation JYColorBox
@end

const CGFloat kJYSuitability = 0.95;
const NSUInteger kJYColorLength = 20;
const CGFloat kJYBrightColorThreshold = 0.6;
const CGFloat kJYDarkColorThreshold = 0.4;
const CGFloat kJYDistinctColorThreshold = 0.2;
const NSUInteger kJYCellCount = kJYColorLength * kJYColorLength * kJYColorLength;

@interface JYImageCore () {
    JYColorUnit colorUnits[kJYCellCount];
}

@end

@implementation JYImageCore
#pragma mark - public methods
+ (instancetype)core {
    static JYImageCore *_core = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _core = [[JYImageCore alloc] init];
    });
    return _core;
}

- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)image
                                       imageRect:(CGRect)rect {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    NSInteger       bitmapByteCount;
    NSInteger       bitmapBytesPerRow;
    
    NSInteger pixelsWide = rect.size.width;
    NSInteger pixelsHigh = rect.size.height;
    
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount   = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    bitmapData = malloc(bitmapByteCount);
    if (bitmapData == NULL) {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    /**
     *  获得位图上下文
     *
     *  @param bitmapData                       指向要渲染的绘制内存的地址
     *  @param pixelsWide                       bitmap的宽度,单位为像素
     *  @param pixelsHigh                       bitmap的高度,单位为像素
     *  @param 8                                内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
     *  @param bitmapBytesPerRow                bitmap的每一行在内存所占的比特数
     *  @param colorSpace                       bitmap上下文使用的颜色空间。
     *  @param kCGImageAlphaPremultipliedFirst  指定bitmap包含alpha，并且alpha在第一位，即（ARGB）
     *  @param kCGBitmapByteOrder32Big          32-bit, 低地址存放高位格式(big endian format)
     *
     *  @return 位图上下文
     */
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
    
    if (context == NULL) {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    CGColorSpaceRelease(colorSpace);
    return context;
}

- (NSArray<JYColorBox *> *)extractAndFilterMaximaFromImage:(UIImage *)image
                                                      mode:(JYExtractMode)mode {
    //获取最大值
    NSArray<JYColorBox *> *sortedMaxima = [self findSortedMaximaInImage:image mode:mode];
    //过滤掉太接近黑色的颜色
    if (mode & JYExtractModeAvoidBlack) {
        sortedMaxima = [self filterMaxima:sortedMaxima color:RGBA(0, 0, 0, 1)];
    }
    //过滤掉太接近白色的颜色
    if (mode & JYExtractModeAvoidWhite) {
        sortedMaxima = [self filterMaxima:sortedMaxima color:RGBA(255, 255, 255, 1)];
    }
    //返回最大值Array
    return sortedMaxima;
}

- (NSArray<JYColorBox *> *)findSortedMaximaInImage:(UIImage *)image
                                              mode:(JYExtractMode)mode {
    //首先获得image的局部最大值
    NSArray<JYColorBox *> *sortedMaxima = [self findLocalMaximaInImage:image mode:mode];
    
    //过滤器的阀值,如果我们想要不同的颜色
    if (mode & JYExtractModeOnlyDistinctColors) {
        sortedMaxima = [self filterDistinctMaxima:sortedMaxima threshold:kJYDistinctColorThreshold];
    }
    
    //按照鲜艳度的顺序排序结果数组
    if (mode & JYExtractModeOrderByBrightness) {
        sortedMaxima = [self orderByBrightness:sortedMaxima];
    }
    else if (mode & JYExtractModeOrderByDarkness) {
        sortedMaxima = [self orderByDarkness:sortedMaxima];
    }
    
    return sortedMaxima;
}

#pragma mark - private methods
- (NSArray<JYColorBox *> *)findLocalMaximaInImage:(UIImage *)image
                                             mode:(JYExtractMode)mode {
    //复位所有Box
    [self clearColorUnits];
    
    //从image获取像素行的信息
    unsigned int pixelCount;
    unsigned char *rawData = [self rawPixelDataFromImage:image pixelCount:&pixelCount];
    if (!rawData) return nil;
    
    CGFloat red, green, blue;
    NSInteger redIndex, greenIndex, blueIndex, cellIndex, localHitCount;
    BOOL isLocalMaximum;
    
    //每一个cell的的RGB映射到三维网格上
    for (NSUInteger k = 0; k < pixelCount; k++) {
        //分量取值范围[0, 1]
        red   = (CGFloat)rawData[k*4+0]/255.0;
        green = (CGFloat)rawData[k*4+1]/255.0;
        blue  = (CGFloat)rawData[k*4+2]/255.0;
        
        //如果我们只希望保留鲜艳的色彩，则忽略暗淡的像素
        if (mode & JYExtractModeOnlyBrightColors) {
            if (red < kJYBrightColorThreshold &&
                green < kJYBrightColorThreshold &&
                blue < kJYBrightColorThreshold) continue;
        }
        else if (mode & JYExtractModeOnlyDarkColors) {
            if (red >= kJYDarkColorThreshold ||
                green >= kJYDarkColorThreshold ||
                blue >= kJYDarkColorThreshold) continue;
        }
        
        //在每种颜色尺寸颜色组件映射到cell的下标
        NSUInteger length = kJYColorLength - 1;
        redIndex = red * length;
        greenIndex = green * length;
        blueIndex = blue * length;
        
        //计算线性cell下标
        cellIndex = [self cellIndexWithRed:redIndex greed:greenIndex blue:blueIndex];
        
        //增加cell数
        colorUnits[cellIndex].hitCount++;
        
        //添加像素的颜色到单元格颜色计数器
        colorUnits[cellIndex].red   += red;
        colorUnits[cellIndex].green += green;
        colorUnits[cellIndex].blue  += blue;
    }
    
    //释放原始像素数据内存
    free(rawData);
    
    //我们在这里收集局部的最大值
    NSMutableArray<JYColorBox *> *localMaxima = [NSMutableArray array];
    
    //找到局部网格中的最大值
    for (NSUInteger r = 0; r < kJYColorLength; r++) {
        for (NSUInteger g = 0; g < kJYColorLength; g++) {
            for (NSUInteger b = 0; b < kJYColorLength; b++) {
                //得到这个cell的计数
                localHitCount = colorUnits[[self cellIndexWithRed:r greed:g blue:b]].hitCount;
                
                //如果这个cell没有命中,忽略它(我们零命中率不感兴趣)
                if (localHitCount == 0) continue;
                
                //局部最大值,直到我们找到一个临近更高的计数
                isLocalMaximum = YES;
                
                //检查是否有临近的计数更高,如果是这样,没有当地的最大值
                for (NSUInteger n = 0; n < 27; n++) {
                    redIndex   = r + neighbourIndices[n][0];
                    greenIndex = g + neighbourIndices[n][1];
                    blueIndex  = b + neighbourIndices[n][2];
                    
                    //只检查有效的cell下标(跳过界外下标)
                    if (redIndex >= 0 && greenIndex >= 0 && blueIndex >= 0) {
                        if (redIndex < kJYColorLength &&
                            greenIndex < kJYColorLength &&
                            blueIndex < kJYColorLength) {
                            if (colorUnits[[self cellIndexWithRed:redIndex greed:greenIndex blue:blueIndex]].hitCount > localHitCount) {
                                //临近的计数较高,所以这不是一个局部最大值。
                                isLocalMaximum = NO;
                                //跳出内部循坏
                                break;
                            }
                        }
                    }
                }
                
                //如果这不是一个局部最大值,继续循环。
                if (!isLocalMaximum) continue;
                
                //否则添加这个cell局部最大值
                JYColorBox *maximum = [[JYColorBox alloc] init];
                maximum.cellIndex = [self cellIndexWithRed:r greed:g blue:b];
                maximum.hitCount = colorUnits[maximum.cellIndex].hitCount;
                maximum.red   = colorUnits[maximum.cellIndex].red  / (CGFloat)colorUnits[maximum.cellIndex].hitCount;
                maximum.green = colorUnits[maximum.cellIndex].green/ (CGFloat)colorUnits[maximum.cellIndex].hitCount;
                maximum.blue  = colorUnits[maximum.cellIndex].blue / (CGFloat)colorUnits[maximum.cellIndex].hitCount;
                maximum.brightness = fmax(fmax(maximum.red, maximum.green), maximum.blue);
                [localMaxima addObject:maximum];
            }
        }
    }
    
    //最后通过局部最大值的命中率排序数组
    NSArray<JYColorBox *> *sortedMaxima = [localMaxima sortedArrayUsingComparator:^NSComparisonResult(JYColorBox *m1, JYColorBox *m2){
        if (m1.hitCount == m2.hitCount) return NSOrderedSame;
        return m1.hitCount > m2.hitCount ? NSOrderedAscending : NSOrderedDescending;
    }];
    return sortedMaxima;
}

- (unsigned char *)rawPixelDataFromImage:(UIImage *)image
                              pixelCount:(unsigned int *)pixelCount {
    //获取CGImage和他的尺寸
    CGImageRef cgImage = [image CGImage];
    NSUInteger width   = CGImageGetWidth(cgImage);
    NSUInteger height  = CGImageGetHeight(cgImage);
    
    //分配像素数据的内存
    unsigned char *rawData = (unsigned char *)malloc(height * width * 4);
    
    //如果分配失败，返回NULL
    if (!rawData) return NULL;
    
    //创建颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //设置一些指标
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    //使用内存创建context
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
    //绘制图像到内存
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    //释放context
    CGContextRelease(context);
    //创建像素数传递指针
    *pixelCount = (int)width * (int)height;
    //返回像素数据（需要被释放）
    return rawData;
}

- (NSArray<JYColorBox *> *)filterDistinctMaxima:(NSArray<JYColorBox *> *)maxima
                                      threshold:(CGFloat)threshold {
    
    NSMutableArray<JYColorBox *> *filteredMaxima = [NSMutableArray array];
    //检查每一个最大值
    for (NSUInteger k = 0; k < maxima.count; k++) {
        //获取我们检查的最大值
        JYColorBox *max1 = maxima[k];
        
        //不同色,直到出现一个很接近的颜色
        BOOL isDistinct = YES;
        
        //检查前面的颜色，看看其中是否太接近
        for (NSUInteger n = 0; n < k; n++) {
            //获取相比较的最大值
            JYColorBox *max2 = maxima[n];
            //计算RGB差值
            CGFloat redDelta   = max1.red - max2.red;
            CGFloat greenDelta = max1.green - max2.green;
            CGFloat blueDelta  = max1.blue - max2.blue;
            
            //计算在色彩空间的距离增量
            double delta = sqrt(redDelta*redDelta + greenDelta*greenDelta + blueDelta*blueDelta);
            
            //如果太接近标记为非不同色，跳出内层循坏
            if (delta < threshold) {
                isDistinct = NO;
                break;
            }
        }
        //如果是不同的，则加入过滤后的数组
        if (isDistinct) {
            [filteredMaxima addObject:max1];
        }
    }
    return [NSArray arrayWithArray:filteredMaxima];
}

- (NSArray<JYColorBox *> *)filterMaxima:(NSArray *)maxima
                                  color:(UIColor *)color {
    
    //获得颜色分量
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSMutableArray<JYColorBox *> *filteredMaxima = [NSMutableArray array];
    
    //检查每一个最大值
    for (NSUInteger k = 0; k < maxima.count; k++) {
        //获取我们检查的最大值
        JYColorBox *max1 = maxima[k];
        //计算RGB差值
        CGFloat redDelta   = max1.red   - components[0];
        CGFloat greenDelta = max1.green - components[1];
        CGFloat blueDelta  = max1.blue  - components[2];
        
        //计算颜色空间距离的变化量
        double delta = sqrt(redDelta*redDelta + greenDelta*greenDelta + blueDelta*blueDelta);
        
        if (delta >= kJYDistinctColorThreshold) {
            [filteredMaxima addObject:max1];
        }
    }
    return [NSArray arrayWithArray:filteredMaxima];
}

- (NSArray<JYColorBox *> *)orderByBrightness:(NSArray *)maxima {
    return [maxima sortedArrayUsingComparator:^NSComparisonResult(JYColorBox *m1, JYColorBox *m2){
        return m1.brightness > m2.brightness ? NSOrderedAscending : NSOrderedDescending;
    }];
}

- (NSArray<JYColorBox *> *)orderByDarkness:(NSArray *)maxima {
    return [maxima sortedArrayUsingComparator:^NSComparisonResult(JYColorBox *m1, JYColorBox *m2){
        return m1.brightness < m2.brightness ? NSOrderedAscending : NSOrderedDescending;
    }];
}

- (NSArray<JYColorBox *> *)adaptiveFilteringForMaxima:(NSArray<JYColorBox *> *)maxima
                                                count:(NSUInteger)count {
    //如果最大值的计数高于所请求的计数，执行不同阈值
    if (maxima.count > count) {
        NSArray *tempDistinctMaxima = maxima;
        CGFloat distinctThreshold = 0.1;
        
        //如果这不能导致想要的计数，阈值减少十次。
        for (NSUInteger k = 0; k < 10; k++) {
            //获取目前不同阈值的Array
            tempDistinctMaxima = [self filterDistinctMaxima:maxima threshold:distinctThreshold];
            //如果Array的计数小于count，则跳出循坏执行当前sortedMaxima
            if (tempDistinctMaxima.count <= count) {
                break;
            }
            //保持这个结果（长度>计数）
            maxima = tempDistinctMaxima;
            //阈值提高0.05
            distinctThreshold += 0.05;
        }
        //只需要第一个最大值
        maxima = [maxima subarrayWithRange:NSMakeRange(0, count)];
    }
    return maxima;
}

- (NSArray<UIColor *> *)colorsFromMaxima:(NSArray<JYColorBox *> *)maxima {
    //构建生成的颜色数组
    NSMutableArray<UIColor *> *colorArray = [NSMutableArray array];
    //对于每一个局部最大值生成的UIColor，把它添加到结果Array
    for (JYColorBox *maximum in maxima) {
        [colorArray addObject:[UIColor colorWithRed:maximum.red green:maximum.green blue:maximum.blue alpha:1.0]];
    }
    return [NSArray arrayWithArray:colorArray];
}

- (void)clearColorUnits {
    for (NSUInteger k = 0; k < kJYCellCount; k++) {
        colorUnits[k].hitCount = 0;
        colorUnits[k].red   = 0.0;
        colorUnits[k].green = 0.0;
        colorUnits[k].blue  = 0.0;
    }
}

- (NSUInteger)cellIndexWithRed:(CGFloat)red greed:(CGFloat)greed blue:(CGFloat)blue {
    return (red + greed * kJYColorLength + blue * kJYColorLength * kJYColorLength);
}

#pragma mark - getter & setter

@end
