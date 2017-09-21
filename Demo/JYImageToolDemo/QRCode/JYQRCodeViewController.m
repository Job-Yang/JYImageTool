//
//  JYQRCodeViewController.m
//  JYImageToolDemo
//
//  Created by 杨权 on 2017/9/20.
//  Copyright © 2017年 Job-Yang. All rights reserved.
//

#import "JYQRCodeViewController.h"
#import "JYImageTool.h"

@interface JYQRCodeViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextField *textField;
@end

@implementation JYQRCodeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self createQRcode];
}

#pragma mark - setup methods
- (void)initUI {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self textField];
    [self imageView];
}

- (void)createQRcode {
    UIImage *QRcodeImage = [UIImage QRCodeImageFromString:self.textField.text imageSize:500];
    self.imageView.image = QRcodeImage;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) return;
    [self createQRcode];
}

#pragma mark - event & response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)tapActon:(UITapGestureRecognizer *)tap {
    [self showActionSheet];
}

#pragma mark - private methods
- (void)addShadow {
    _imageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _imageView.layer.shadowOpacity = 0.8;
    _imageView.layer.shadowRadius = 5;
    _imageView.layer.shadowOffset = CGSizeMake(5, 5);
}

- (void)showActionSheet {
    if (DEVICE_VERSION >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *actionIdentify = [UIAlertAction actionWithTitle:@"识别二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSString *info = [self.imageView.image identifyQRCode];
            [self showAlert:info];
        }];
        [alertController addAction:actionCancel];
        [alertController addAction:actionIdentify];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)showAlert:(NSString *)hint {
    if (DEVICE_VERSION >= 8.f) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"识别结果" message:hint preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:confirmAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - getter & setter
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(50, TOP_LAYOUT_GUIDE+50, SCREEN_WIDTH-100, 50)];
        _textField.delegate = self;
        _textField.font = [UIFont fontWithName:@"GillSans-Italic" size:30.f];
        _textField.textColor = RGB(58,63,83);
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.text = @"Job-Yang";
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH-100, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_textField addSubview:line];
        [self.view addSubview:_textField];
    }
    return _textField;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, TOP_LAYOUT_GUIDE+150, SCREEN_WIDTH-60, SCREEN_WIDTH-60)];
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActon:)];
        [_imageView addGestureRecognizer:tap];
        [self.view addSubview:_imageView];
        [self addShadow];
    }
    return _imageView;
}

@end
