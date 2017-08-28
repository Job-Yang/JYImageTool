

JYImageTool
==============

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/Job-Yang/YTZImageComparison/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/YTZImageComparison.svg?style=flat)](http://cocoapods.org/?q=YTZImageComparison)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/YTZImageComparison.svg?style=flat)](http://cocoapods.org/?q=YTZImageComparison)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;

Useful image tools for iOS


Features
==============

- Extract the primary color of the image(Multiple modes)
- Extract the image pixel color
- Contrast image is equal (based on pixel rather than image name)


Usage
==============

### Extract the primary color of the image
	UIColor *whiteColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
	NSArray *colorArr = [[JYImageTool tool] extractBrightColorsFromImage:image avoidColor:whiteColor maxCount:10];


###Extract the image pixel color
	UIColor *color = [[JYImageTool tool] pixelColorAtLocation:point inImage:image formImageRect:frame];

###Contrast image is equal
	BOOL isEqual = [[JYImageTool tool] isEqualToImage:imageOne imageTwo:imageTwo];
	if (isEqual) {
		//...Do something..
	}
	else {
		//...Do something..
	}

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


##License
JYImageTool is released under the MIT license. See LICENSE file for details.