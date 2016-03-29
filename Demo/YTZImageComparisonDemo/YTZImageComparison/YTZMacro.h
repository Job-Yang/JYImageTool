//
//  YTZMacro.h
//  YTZImageComparison
//
//  Created by 杨权 on 16/1/19.
//  Copyright © 2016年 Job-Yang. All rights reserved.
//

#ifndef YTZMacro_h
#define YTZMacro_h


//判断相同条件
#define EQUAL_HRESHOLD 0.95

//判断相似条件
#define SIMILAR_HRESHOLD 0.7

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
#define CELL_INDEX(r,g,b) (r+g*COLOR_CUBE_RESOLUTION+b*COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION)

//辅助宏计算cell总数
#define CELL_COUNT COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION*COLOR_CUBE_RESOLUTION


#endif /* YTZMacro_h */
