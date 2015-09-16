# YTZImageComparison
##  总述

 YTZImageComparison是一个使用Objective-C编写，基于对图片颜色分析的一款取色，图片对比的开源框架。实现了对图片优势色（主色）的提取，取出图片对应点颜色，对图片进行简单的相同/相似比较。其中取主色的算法借鉴了GitHub上的开源项目[ColorCube](https://github.com/pixelogik/ColorCube)。

##算法简介

###前言
  第一次在GitHub看到[pixelogik](https://github.com/pixelogik)与[luisespinoza](https://github.com/luisespinoza)取主色的项目[ColorCube](https://github.com/pixelogik/ColorCube),[LEColorPicker](https://github.com/luisespinoza/LEColorPicker)时，就有一个想法，能不能通过这个取色算法做一些更加实际的事情呢？于是有了接下来的这个项目。

####1.提取图片主色的算法实现
  1>将传入的图片重绘为小尺寸的图片，避免遍历所有像素点所带来的性能问题;<br>
  2>先得到重绘后图片的RGBA分量值；<br>
  3>将RGB这三个分量对应到以R,G,B作为空间直角坐标轴的分量(即得到颜色空间);
  4>搜寻每个RGB对应点相邻方向的26个点(空间模型类似于三阶魔方)的RGB值，该点是否比旁边的点更加的"鲜艳";<br>
  5>如果是，则将他加入鲜艳色数组;<br>
  6>计算鲜艳色出现的频率，按照频率高低加入到返回值数组。<br>
  其中可根据多个枚举值来定制"鲜艳"的标准，也可以设置忽略一个RGB色彩空间的颜色，避免一些颜色的干扰。<br>
