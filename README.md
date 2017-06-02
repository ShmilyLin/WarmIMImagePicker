# WarmIMImagePicker
iOS的自定义图片选择器

## 概述

从我参与的另一个项目——WarmIM的APP实现中抽出来的一个图片选择器，用来选择iOS**照片**中的图片。

## 支持功能

### 默认支持功能

* 播放视频

* 浏览图片

* 支持3DTouch

### 自定义功能

* 选择不同类型的资源，包括单独选择图片，单独选择视频等。

* 顺序展示资源还是倒叙展示资源。

* 是否展示空资源相册。

* 可以选择直接跳转到所有资源展示列表，或者停留在相册列表。

* 是否支持LivePhoto。

* 是否支持滑动选择。

* 是否允许下载iCloud上存储的资源，支持单独下载图片或下载全部资源。

* 是否在资源展示页面展示一个相机拍摄按钮。

* 可选择的最大的资源数量（暂时只支持图片选择最大数量）。

* 自定义每行展示的资源数量。

* 自定义导航栏颜色以及导航栏字体颜色。

## 最近一版本的更新日志

2017年6月2日：

相机部分暂不可用，目前正在重构相机页面。

修复图片浏览页面无法从iCloud上下载图片的问题。

## 代码说明

项目分为几个部分：

1. Demo：在`WarmIMImagePickerDemo`文件夹下，可以直接运行在真机上。这是一个支持国际化的Demo，目前支持中文和英文。

2. 源代码文件：在`WarmIMImagePicker`文件夹下，可以直接拖入到项目中使用，提示内容均为中文。其中需要用到的图片资源在`WarmIMImagePickerAssets`文件夹中，可以直接拖入到`.xcassets`中使用。

## 如何使用

直接拖入到项目中，引用下面文件：

```objectivec
#import "UIViewController+WarmIMImagePicker.h"
```

遵循`WarmIMImagePickerManagerDelegate`协议：

```objectivec
[WarmIMImagePickerManager sharedManager].delegate = self;
```

ViewController中调用展示：

```objectivec
[self WarmIM_showImagePicker];
```

## 未来发展

之后还将支持相机实时滤镜，选中图片编辑，视频多选，选择角标自定义等功能。

## 授权协议

[MIT](http://opensource.org/licenses/MIT)