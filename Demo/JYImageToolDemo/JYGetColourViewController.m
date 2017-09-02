//
//  JYGetColourViewController.m
//  JYImageToolDemo
//
//  Created by 杨权 on 16/3/25.
//  Copyright © 2016年 Job-Yang. All rights reserved.
//

#import "JYGetColourViewController.h"
#import "JYImageTool.h"

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface JYGetColourViewController ()
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UIButton *nextButton;
@end

@implementation JYGetColourViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self nextImage];
}

#pragma mark - setup methods
- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self imageView];
    [self nextButton];
}

#pragma mark - event & response
- (void)tapActon:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.imageView];
    //得到对应点颜色
    self.view.backgroundColor = [[JYImageTool tool] pixelColorAtLocation:point inImage:self.imageView.image formImageRect:self.imageView.frame];
}

- (void)nextImage {
    //随机拿一张图。
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",(arc4random()%11)+1] ofType:@"png"];
    UIImage *currentImage = [UIImage imageWithContentsOfFile:imagePath];
    self.imageView.image = currentImage;
}

#pragma mark - getter & setter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 114, SCREEN_WIDTH-100, SCREEN_HEIGHT-100-114)];
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActon:)];
        [_imageView addGestureRecognizer:tap];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:30.f];
        [_nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextImage) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_nextButton];
    }
    return _nextButton;
}

@end
