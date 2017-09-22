

JYImageTool
==============

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/Job-Yang/YTZImageComparison/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/YTZImageComparison.svg?style=flat)](http://cocoapods.org/?q=YTZImageComparison)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/YTZImageComparison.svg?style=flat)](http://cocoapods.org/?q=YTZImageComparison)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;

Useful image tools for iOS


Features
==============

- Extract the primary color of the image(Multiple modes)
- Extract the image pixel color
- Contrast image is equal (based on pixel rather than image name)
- QRcode image generation and recognition
- Image compression


Usage
==============

### Extract the primary color of the image
```Objective-C
UIColor *whiteColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
// extract bright colors and avoid results if close to white color
self.colorArr = [self.imageView.image extractColorsWithMode:JYExtractModeOnlyDistinctColors avoidColor:whiteColor];
```

### Extract the image pixel color
```Objective-C
UIColor *color = [self.imageView.image pixelColorAtLocation:point formImageRect:self.imageView.frame];
```

### Contrast image is equal
```Objective-C
BOOL isEqual = [self.imageViewOne.image isEqualToImage:self.imageViewTwo.image];
if (isEqual) {
//...Do something..
}
else {
//...Do something..
}
```

### QRcode image generation and recognition
```Objective-C
// Create QRcode image
UIImage *QRcodeImage = [UIImage QRCodeImageFromString:@"Job-Yang" imageSize:500];
// Recognition QRcode in the image
NSString *info = [QRcodeImage identifyQRCode];
```

### Image compression
```Objective-C
// Compressed to 500KB
NSData *compressData = [self.originalImage compressImageToByte:500 * 1024];
```

Installation
==============

### CocoaPods
1. Add `pod 'JYImageTool'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import `"JYImageTool.h"`.


### Manually
1. Download all the files in the `JYImageTool` subdirectory.
2. Add the source files to your Xcode project.
3. Import `JYImageTool.h`.


### License
JYImageTool is released under the MIT license. See LICENSE file for details.



---
中文介绍
==============

实用的iOS图片工具


特性
==============

- 图片主色提取（包含多种提取模式）
- 图片像素点颜色提取
- 图片相同比较（基于图片像素而非图片名）
- 二维码图片生成与识别
- 图片压缩


Usage
==============

### 图片主色提取
```Objective-C
UIColor *whiteColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
// 提取较附近更亮的主色，并忽略太接近白色的提取结果
self.colorArr = [self.imageView.image extractColorsWithMode:JYExtractModeOnlyDistinctColors avoidColor:whiteColor];
```

### 图片像素点颜色提取
```Objective-C
UIColor *color = [self.imageView.image pixelColorAtLocation:point formImageRect:self.imageView.frame];
```

### 图片相同比较
```Objective-C
BOOL isEqual = [self.imageViewOne.image isEqualToImage:self.imageViewTwo.image];
if (isEqual) {
//...Do something..
}
else {
//...Do something..
}
```

### 二维码图片生成与识别
```Objective-C
// 创建二维码图片
UIImage *QRcodeImage = [UIImage QRCodeImageFromString:@"Job-Yang" imageSize:500];
// 识别图片中的二维码
NSString *info = [QRcodeImage identifyQRCode];
```

### 图片压缩
```Objective-C
// 压缩到500KB
NSData *compressData = [self.originalImage compressImageToByte:500 * 1024];
```


安装
==============

### CocoaPods
1. 在 Podfile 中添加 `pod 'JYImageTool'` .
2. 执行 `pod install` 或 `pod update`.
3. 导入 `"JYImageTool.h"`.


### 手动安装
1. 下载 JYImageTool 文件夹内的所有内容。
2. 将 JYImageTool 内的源文件添加(拖放)到你的工程。
3. 导入 `JYImageTool.h`。


### 许可证
JYImageTool 使用 MIT 许可证，详情见 LICENSE 文件。