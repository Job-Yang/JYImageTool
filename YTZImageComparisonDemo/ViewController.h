//
//  ViewController.h
//  YTZImageComparisonDemo
//
//  Created by 杨权 on 15/9/15.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTZImageComparison.h"

/*----利用 extractBrightColorsFromImage 方法进行图片主色提取----*/

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;     
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;

- (IBAction)NextActon:(id)sender;


@property (assign,nonatomic) int i;
@property (retain,nonatomic) NSArray *ColorArr;

@end

