//
//  JYGetColourViewController.m
//  JYImageToolDemo
//
//  Created by 杨权 on 16/3/25.
//  Copyright © 2016年 Job-Yang. All rights reserved.
//

#import "JYGetColourViewController.h"
#import "JYImageTool.h"

@interface JYGetColourViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *nextButton;
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
    self.view.backgroundColor = [self.imageView.image pixelColorAtLocation:point formImageRect:self.imageView.frame];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)nextImage {
    //随机拿一张图。
    NSString *imageName = [NSString stringWithFormat:@"resources_%d",(arc4random()%10)+1];
    self.imageView.image = [UIImage imageNamed:imageName];
}

#pragma mark - getter & setter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, TOP_LAYOUT_GUIDE+30, SCREEN_WIDTH-60, SAFE_HEIGHT-110)];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        _imageView.userInteractionEnabled = YES;
        _imageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActon:)];
        [_imageView addGestureRecognizer:tap];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BOTTOM_LAYOUT_GUIDE-49, SCREEN_WIDTH, 49)];
        _nextButton.titleLabel.font = [UIFont fontWithName:@"GillSans-Italic" size:30.f];
        [_nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
        [_nextButton setTitleColor:RGB(58,63,83) forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextImage) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_nextButton];
    }
    return _nextButton;
}

@end
