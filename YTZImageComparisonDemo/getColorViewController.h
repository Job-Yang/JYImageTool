//
//  getColorViewController.h
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 15/9/16.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTZImageComparison.h"

/*----利用 getPixelColorAtLocation 方法进行图片相应点颜色的提取----*/

@interface getColorViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

- (IBAction)NextAction:(id)sender;

@property (assign,nonatomic) int i;

@end
