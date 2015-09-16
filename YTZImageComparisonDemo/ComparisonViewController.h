//
//  ComparisonViewController.h
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 15/9/16.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTZImageComparison.h"

/*----利用 isEqualToImage和isSimilarToImage 方法判断图片相同或者相似----*/

@interface ComparisonViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *ImageOne;
@property (weak, nonatomic) IBOutlet UIImageView *ImageTwo;
@property (weak, nonatomic) IBOutlet UILabel *Label;

- (IBAction)NextAction:(id)sender;

@property (assign,nonatomic) int i;
@property (assign,nonatomic) int j;

@end
