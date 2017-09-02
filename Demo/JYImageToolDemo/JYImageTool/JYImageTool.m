//
//  JYImageTool.m
//  JYImageTool
//
//  Created by 杨权 on 15/9/15.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "JYImageTool.h"

/*
 对代码中一些参数的注解
 1.cell:三维空间（RGB）中的一个单位立方体；
 2.neighbourIndices:三维空间中，一个立方体cell周围邻近的立方体方向，联想魔方，一共27块（包扩中心）；
 3.BrightColors/Bright:鲜艳的颜色，突出的颜色；
 4.LocalMaximum:局部最大值，如果一个立方体cell比它邻近的27个方向的颜色更突出（鲜艳），则他就是局部最大值；
 */

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

@implementation JYLocalMaximum
@end

@interface JYImageTool () {
    JYCubeCell cells[COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION];
}
@end


@implementation JYImageTool

+ (instancetype)tool {
    static JYImageTool *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[JYImageTool alloc] init];
    });
    return _tool;
}

- (NSArray<UIColor *> *)extractBrightColorsFromImage:(UIImage *)image
                                          avoidColor:(UIColor*)avoidColor
                                            maxCount:(NSUInteger)maxCount {
    //获取最大值
    //flags参数定义了集中不同的筛选条件
    NSArray *sortedMaxima = [self findAndSortMaximaInImage:image flags:JYImageOnlyDistinctColors];
    
    if (avoidColor) {
        //过滤掉太接近指定颜色的颜色
        sortedMaxima = [self filterMaxima:sortedMaxima tooCloseToColor:avoidColor];
    }
    //智能过滤不同色
    sortedMaxima = [self performAdaptiveDistinctFilteringForMaxima:sortedMaxima count:maxCount];
    
    //返回颜色Array
    return [self colorsFromMaxima:sortedMaxima];
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

    CGColorSpaceRelease( colorSpace );
    return context;
}


- (NSArray *)findAndSortMaximaInImage:(UIImage *)image
                                flags:(NSUInteger)flags {
    //首先获得image的局部最大值
    NSArray *sortedMaxima = [self findLocalMaximaInImage:image flags:flags];
    
    //过滤器的阀值,如果我们想要不同的颜色
    if (flags & JYImageOnlyDistinctColors) {
        sortedMaxima = [self filterDistinctMaxima:sortedMaxima threshold:DISTINCT_COLOR_THRESHOLD];
    }
    
    //按照鲜艳度的顺序排序结果数组
    if (flags & JYImageOrderByBrightness) {
        sortedMaxima = [self orderByBrightness:sortedMaxima];
    }
    else if (flags & JYImageOrderByDarkness) {
        sortedMaxima = [self orderByDarkness:sortedMaxima];
    }
    
    return sortedMaxima;
}

//在image找到局部极大值
- (NSArray *)findLocalMaximaInImage:(UIImage *)image
                              flags:(NSUInteger)flags {
    //复位所有cell
    [self clearCells];
    
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
        if (flags & JYImageOnlyBrightColors) {
            if (red < BRIGHT_COLOR_THRESHOLD &&
                green < BRIGHT_COLOR_THRESHOLD &&
                blue < BRIGHT_COLOR_THRESHOLD) continue;
        }
        else if (flags & JYImageOnlyDarkColors) {
            if (red >= DARK_COLOR_THRESHOLD ||
                green >= DARK_COLOR_THRESHOLD ||
                blue >= DARK_COLOR_THRESHOLD) continue;
        }
        
        //在每种颜色尺寸颜色组件映射到cell的下标
        redIndex   = (NSInteger)(red  *(COLOR_CUBE_RESOLUTION-1.0));
        greenIndex = (NSInteger)(green*(COLOR_CUBE_RESOLUTION-1.0));
        blueIndex  = (NSInteger)(blue *(COLOR_CUBE_RESOLUTION-1.0));
        
        //计算线性cell下标
        cellIndex = CELL_INDEX(redIndex, greenIndex, blueIndex);
        
        //增加cell数
        cells[cellIndex].hitCount++;
        
        //添加像素的颜色到单元格颜色计数器
        cells[cellIndex].redAcc   += red;
        cells[cellIndex].greenAcc += green;
        cells[cellIndex].blueAcc  += blue;
    }
    
    //释放原始像素数据内存
    free(rawData);
    
    //我们在这里收集局部的最大值
    NSMutableArray *localMaxima = [NSMutableArray array];
    
    //找到局部网格中的最大值
    for (NSUInteger r = 0; r < COLOR_CUBE_RESOLUTION; r++) {
        for (NSUInteger g = 0; g < COLOR_CUBE_RESOLUTION; g++) {
            for (NSUInteger b = 0; b < COLOR_CUBE_RESOLUTION; b++) {
                //得到这个cell的计数
                localHitCount = cells[CELL_INDEX(r, g, b)].hitCount;
                
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
                        if (redIndex < COLOR_CUBE_RESOLUTION &&
                            greenIndex < COLOR_CUBE_RESOLUTION &&
                            blueIndex < COLOR_CUBE_RESOLUTION) {
                            if (cells[CELL_INDEX(redIndex, greenIndex, blueIndex)].hitCount > localHitCount) {
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
                JYLocalMaximum *maximum = [[JYLocalMaximum alloc] init];
                maximum.cellIndex = CELL_INDEX(r, g, b);
                maximum.hitCount = cells[maximum.cellIndex].hitCount;
                maximum.red   = cells[maximum.cellIndex].redAcc  / (CGFloat)cells[maximum.cellIndex].hitCount;
                maximum.green = cells[maximum.cellIndex].greenAcc/ (CGFloat)cells[maximum.cellIndex].hitCount;
                maximum.blue  = cells[maximum.cellIndex].blueAcc / (CGFloat)cells[maximum.cellIndex].hitCount;
                maximum.brightness = fmax(fmax(maximum.red, maximum.green), maximum.blue);
                [localMaxima addObject:maximum];
            }
        }
    }
    
    //最后通过局部最大值的命中率排序数组
    NSArray *sortedMaxima = [localMaxima sortedArrayUsingComparator:^NSComparisonResult(JYLocalMaximum *m1, JYLocalMaximum *m2){
        if (m1.hitCount == m2.hitCount) return NSOrderedSame;
        return m1.hitCount > m2.hitCount ? NSOrderedAscending : NSOrderedDescending;
    }];
    return sortedMaxima;
}

- (unsigned char *)rawPixelDataFromImage:(UIImage *)image
                              pixelCount:(unsigned int*)pixelCount {
    //获取CGImage和他的尺寸
    CGImageRef cgImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    
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

- (NSArray *)filterDistinctMaxima:(NSArray *)maxima
                        threshold:(CGFloat)threshold {
    
    NSMutableArray *filteredMaxima = [NSMutableArray array];
    //检查每一个最大值
    for (NSUInteger k = 0; k < maxima.count; k++) {
        //获取我们检查的最大值
        JYLocalMaximum *max1 = maxima[k];
        
        //不同色,直到出现一个很接近的颜色
        BOOL isDistinct = YES;
        
        //检查前面的颜色，看看其中是否太接近
        for (NSUInteger n = 0; n < k; n++) {
            //获取相比较的最大值
            JYLocalMaximum *max2 = maxima[n];
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

- (NSArray *)filterMaxima:(NSArray *)maxima
          tooCloseToColor:(UIColor*)color {
    
    //获得颜色分量
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSMutableArray *filteredMaxima = [NSMutableArray array];
    
    //检查每一个最大值
    for (NSUInteger k = 0; k < maxima.count; k++) {
        //获取我们检查的最大值
        JYLocalMaximum *max1 = maxima[k];
        //计算RGB差值
        CGFloat redDelta   = max1.red   - components[0];
        CGFloat greenDelta = max1.green - components[1];
        CGFloat blueDelta  = max1.blue  - components[2];
        
        //计算颜色空间距离的变化量
        double delta = sqrt(redDelta*redDelta + greenDelta*greenDelta + blueDelta*blueDelta);
        
        //添加颜色如果不能太近
        if (delta >= 0.5) {
            [filteredMaxima addObject:max1];
        }
    }
    return [NSArray arrayWithArray:filteredMaxima];
}

- (NSArray *)orderByBrightness:(NSArray *)maxima {
    return [maxima sortedArrayUsingComparator:^NSComparisonResult(JYLocalMaximum *m1, JYLocalMaximum *m2){
        return m1.brightness > m2.brightness ? NSOrderedAscending : NSOrderedDescending;
    }];
}

- (NSArray *)orderByDarkness:(NSArray *)maxima {
    return [maxima sortedArrayUsingComparator:^NSComparisonResult(JYLocalMaximum *m1, JYLocalMaximum *m2){
        return m1.brightness < m2.brightness ? NSOrderedAscending : NSOrderedDescending;
    }];
}

- (NSArray *)performAdaptiveDistinctFilteringForMaxima:(NSArray *)maxima
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

- (NSArray *)colorsFromMaxima:(NSArray *)maxima {
    //构建生成的颜色数组
    NSMutableArray *colorArray = [NSMutableArray array];
    //对于每一个局部最大值生成的UIColor，把它添加到结果Array
    for (JYLocalMaximum *maximum in maxima) {
        [colorArray addObject:[UIColor colorWithRed:maximum.red green:maximum.green blue:maximum.blue alpha:1.0]];
    }
    return [NSArray arrayWithArray:colorArray];
}


- (NSArray *)extractAndFilterMaximaFromImage:(UIImage *)image
                                       flags:(NSUInteger)flags {
    //获取最大值
    NSArray *sortedMaxima = [self findAndSortMaximaInImage:image flags:flags];
    //过滤掉太接近黑色的颜色
    if (flags & JYImageAvoidBlack) {
        sortedMaxima = [self filterMaxima:sortedMaxima tooCloseToColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    }
    //过滤掉太接近白色的颜色
    if (flags & JYImageAvoidWhite) {
        sortedMaxima = [self filterMaxima:sortedMaxima tooCloseToColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    }
    //返回最大值Array
    return sortedMaxima;
}

- (NSArray *)extractColorsFromImage:(UIImage *)image
                              flags:(NSUInteger)flags {
    //获取最大值
    NSArray *sortedMaxima = [self extractAndFilterMaximaFromImage:image flags:flags];
    //返回颜色Array
    return [self colorsFromMaxima:sortedMaxima];
}

- (NSArray *)extractColorsFromImage:(UIImage *)image
                              flags:(NSUInteger)flags
                         avoidColor:(UIColor*)avoidColor {
    //获取最大值
    NSArray *sortedMaxima = [self extractAndFilterMaximaFromImage:image flags:flags];
    //过滤掉太接近指定颜色的颜色
    sortedMaxima = [self filterMaxima:sortedMaxima tooCloseToColor:avoidColor];
    //返回颜色Array
    return [self colorsFromMaxima:sortedMaxima];
}


- (NSArray *)extractDarkColorsFromImage:(UIImage *)image
                             avoidColor:(UIColor*)avoidColor
                                  count:(NSUInteger)count {
    //获取最大值（仅暗淡色）
    NSArray *sortedMaxima = [self findAndSortMaximaInImage:image flags:JYImageOnlyDarkColors];
    if (avoidColor) {
        //过滤掉太接近指定颜色的颜色
        sortedMaxima = [self filterMaxima:sortedMaxima tooCloseToColor:avoidColor];
    }
    //智能过滤不同色
    sortedMaxima = [self performAdaptiveDistinctFilteringForMaxima:sortedMaxima count:count];
    //返回颜色Array
    return [self colorsFromMaxima:sortedMaxima];
}

- (NSArray *)extractColorsFromImage:(UIImage *)image
                              flags:(NSUInteger)flags
                           maxCount:(NSUInteger)maxCount {
    //获取最大值
    NSArray *sortedMaxima = [self extractAndFilterMaximaFromImage:image flags:flags];
    //智能过滤不同色
    sortedMaxima = [self performAdaptiveDistinctFilteringForMaxima:sortedMaxima count:maxCount];
    //返回颜色Array
    return [self colorsFromMaxima:sortedMaxima];
}


- (void)clearCells {
    for (NSUInteger k = 0; k < COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION; k++) {
        cells[k].hitCount = 0;
        cells[k].redAcc   = 0.0;
        cells[k].greenAcc = 0.0;
        cells[k].blueAcc  = 0.0;
    }
}

//对比两张图片是否相等
- (BOOL)isEqualToImage:(UIImage *)imageOne
              imageTwo:(UIImage *)imageTwo {
    
    //图片压缩尺寸
    CGRect rect = CGRectMake(0, 0, COLOR_CUBE_RESOLUTION, COLOR_CUBE_RESOLUTION);
    //获得第一张图片的ARGB信息
    CGImageRef ImageOneRef = imageOne.CGImage;
    CGContextRef cgctxOne = [self createARGBBitmapContextFromImage:ImageOneRef imageRect:rect];
    CGContextDrawImage(cgctxOne, rect, ImageOneRef);
    unsigned char* dataOne = CGBitmapContextGetData (cgctxOne);
    
    //释放cgctxOne
    CGContextRelease(cgctxOne);
    
    //获得第二张图片的ARGB信息
    CGImageRef ImageTwoRef = imageTwo.CGImage;
    CGContextRef cgctxTwo = [self createARGBBitmapContextFromImage:ImageTwoRef imageRect:rect];
    CGContextDrawImage(cgctxTwo, rect, ImageTwoRef);
    unsigned char* dataTwo = CGBitmapContextGetData (cgctxTwo);
    
    //释放cgctxTwo
    CGContextRelease(cgctxTwo);
    
    //相等像素数
    NSUInteger EqualCount = 0;
    
    //遍历重绘尺寸的每个像素点
    for (NSUInteger i = 0; i < COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION - 1; i++) {
        float redOne   = dataOne[4*i+1]/255.0;
        float greenOne = dataOne[4*i+2]/255.0;
        float blueOne  = dataOne[4*i+3]/255.0;
        
        float redTwo   = dataTwo[4*i+1]/255.0;
        float greenTwo = dataTwo[4*i+2]/255.0;
        float blueTwo  = dataTwo[4*i+3]/255.0;
        
        //颜色空间距离，距离表示色差大小
        float difference = pow(pow((redOne - redTwo), 2) + pow((greenOne - greenTwo), 2) + pow((blueOne - blueTwo), 2), 0.5);
        
        //色差小于阀值
        if (difference < DISTINCT_COLOR_THRESHOLD) {
            EqualCount ++;
        }
    }
    
    //释放dataOne与dataTwo
    free(dataOne);
    free(dataTwo);
    
    NSLog(@"匹配度：%ld/%d",EqualCount,COLOR_CUBE_RESOLUTION * COLOR_CUBE_RESOLUTION);
    
    //大于相等条件即为相等
    if (EqualCount > COLOR_CUBE_RESOLUTION * COLOR_CUBE_RESOLUTION * EQUAL_HRESHOLD) {
        return YES;
    }
    else{
        return NO;
    }
}

//获取图片点point处的像素颜色
- (UIColor *)pixelColorAtLocation:(CGPoint)point
                          inImage:(UIImage *)image
                    formImageRect:(CGRect)rect {
    
    //获得图片上下文
    UIColor *color = nil;
    CGImageRef inImage = image.CGImage;
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage imageRect:rect];
    if (cgctx == NULL) return nil;
    
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
    if (data) {free(data);}
    return color;
}

- (NSString *)readQRCodeFromImage:(UIImage *)image {
    if (!image) {return nil;}
    //取出选中的图片
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
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

- (UIImage *)QRCodeImageFromString:(NSString *)string
                         imageSize:(CGFloat)imageSize {
    
    return [self QRCodeImageFromString:string
                             imageSize:imageSize
                         logoImageName:nil
                              logoSize:0];
}

- (UIImage *)QRCodeImageFromString:(NSString *)string
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


@end
