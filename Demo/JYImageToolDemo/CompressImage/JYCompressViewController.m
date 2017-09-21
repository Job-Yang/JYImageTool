//
//  JYCompressViewController.m
//  JYImageToolDemo
//
//  Created by 杨权 on 2017/9/20.
//  Copyright © 2017年 Job-Yang. All rights reserved.
//

#import "JYCompressViewController.h"
#import "JYImageTool.h"

@interface JYCompressViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UISlider *slider;
@property (strong, nonatomic) UIImage *originalImage;
@end

@implementation JYCompressViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self nextImage];
}

#pragma mark - setup methods
- (void)initUI {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self imageView];
    [self slider];
    [self nextButton];
}

#pragma mark - event & response
- (void)nextImage {
    //随机拿一张图。
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",(arc4random()%11)+1] ofType:@"png"];
    self.originalImage = [UIImage imageWithContentsOfFile:imagePath];
    self.imageView.image = self.originalImage;
    [self compressImageToByte:500 * 1024];
}

- (void)compressImageToByte:(NSUInteger)byte {
    NSData *originalData = UIImageJPEGRepresentation(self.originalImage, 1);
    NSData *compressData = [self.originalImage compressImageToByte:byte];
    UIImage *compressImage = [UIImage imageWithData:compressData];
    
    self.slider.maximumValue = originalData.length/1024.f;
    self.imageView.image = compressImage;
    self.infoLabel.text = [NSString stringWithFormat:@" 原始尺寸: %@\n 原始大小: %.3f KB\n 压缩后尺寸: %@\n 压缩后大小: %.3f KB",
                           NSStringFromCGSize(self.originalImage.size),
                           originalData.length/1024.f,
                           NSStringFromCGSize(compressImage.size),
                           compressData.length/1024.f];
}

- (void)sliderValueChanged:(UISlider *)slider {
    NSUInteger byte = slider.value * 1024;
    [self compressImageToByte:byte];
}

#pragma mark - getter & setter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_LAYOUT_GUIDE, SCREEN_WIDTH, SAFE_HEIGHT-110)];
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        _imageView.userInteractionEnabled = YES;
        _imageView.layer.masksToBounds = YES;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 160, 70)];
        _infoLabel.backgroundColor = RGBA(155, 155, 155, 0.5);
        _infoLabel.font = [UIFont italicSystemFontOfSize:13.f];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.numberOfLines = 0;
        [self.imageView addSubview:_infoLabel];
    }
    return _infoLabel;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT-BOTTOM_LAYOUT_GUIDE-90, SCREEN_WIDTH-40, 20)];
        _slider.minimumValue = 10;
        _slider.maximumValue = 500;
        _slider.value = _slider.maximumValue;
        _slider.continuous = YES;
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_slider];
    }
    return _slider;
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
