//
//  JYMacro.h
//  JYImageToolDemo
//
//  Created by 杨权 on 2017/9/21.
//  Copyright © 2017年 Job-Yang. All rights reserved.
//

#ifndef JYMacro_h
#define JYMacro_h

#define RGB(r, g, b) RGBA(r, g, b, 1)
#define RGBA(r, g, b, a) [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:a]
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_HEIGHT == 812.0f)
#define TOP_LAYOUT_GUIDE (IS_IPHONE_X ? 88.0 : 64.0)
#define BOTTOM_LAYOUT_GUIDE (IS_IPHONE_X ? 34.0 : 0.0)
#define SAFE_HEIGHT (SCREEN_HEIGHT-TOP_LAYOUT_GUIDE-BOTTOM_LAYOUT_GUIDE)
#define DEVICE_VERSION [[[UIDevice currentDevice] systemVersion] integerValue]

#endif /* JYMacro_h */
