//
//  JYEqualImageViewController.m
//  JYImageToolDemo
//
//  Created by 杨权 on 16/3/25.
//  Copyright © 2016年 Job-Yang. All rights reserved.
//

#import "JYEqualImageViewController.h"
#import "JYImageTool.h"

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface JYEqualImageViewController ()
@property(strong, nonatomic) UIImageView *imageViewOne;
@property(strong, nonatomic) UIImageView *imageViewTwo;
@property(strong, nonatomic) UILabel *resultLabel;
@property(strong, nonatomic) UIButton *nextButton;
@end

@implementation JYEqualImageViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self nextImage];
}

#pragma mark - setup methods
- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self imageViewOne];
    [self imageViewTwo];
    [self resultLabel];
    [self nextButton];
}

#pragma mark - event & response
- (void)nextButtonAction {
    //随机拿2张图。
    [self nextImage];
    
    //判断是否相同
    BOOL isEqual = [[JYImageTool tool] isEqualToImage:self.imageViewOne.image
                                             imageTwo:self.imageViewTwo.image];
    if (isEqual) {
        self.resultLabel.backgroundColor = [UIColor greenColor];
        self.resultLabel.text = @"相同图片";
    }
    else {
        self.resultLabel.backgroundColor = [UIColor redColor];
        self.resultLabel.text = @"不同图片";
    }
}

- (void)nextImage {
    //随机拿2张图。
    NSString *imagePath1 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",(arc4random()%11)+1] ofType:@"png"];
    NSString *imagePath2 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",(arc4random()%11)+1] ofType:@"png"];
    self.imageViewOne.image = [UIImage imageWithContentsOfFile:imagePath1];
    self.imageViewTwo.image = [UIImage imageWithContentsOfFile:imagePath2];
}

#pragma mark - getter & setter
- (UIImageView *)imageViewOne {
    if (!_imageViewOne) {
        _imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, (SCREEN_HEIGHT-64-50)/2)];
        [_imageViewOne setContentMode:UIViewContentModeScaleAspectFill];
        _imageViewOne.layer.masksToBounds = YES;
        [self.view addSubview:_imageViewOne];
    }
    return _imageViewOne;
}

- (UIImageView *)imageViewTwo {
    if (!_imageViewTwo) {
        _imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-64-50)/2+64, SCREEN_WIDTH, (SCREEN_HEIGHT-64-50)/2)];
        [_imageViewTwo setContentMode:UIViewContentModeScaleAspectFill];
        _imageViewTwo.layer.masksToBounds = YES;
        [self.view addSubview:_imageViewTwo];
    }
    return _imageViewTwo;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, (SCREEN_HEIGHT-64-50)/2+30, 200, 60)];
        [_resultLabel setTextColor:[UIColor whiteColor]];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.font = [UIFont systemFontOfSize:35.f];
        [self.view addSubview:_resultLabel];
    }
    return _resultLabel;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:30.f];
        [_nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_nextButton];
    }
    return _nextButton;
}

@end
