//
//  WarmIMHUD.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/8.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WarmIMHUD : NSObject

+ (instancetype)sharedHUD; // 获取单例

@property (nonatomic, assign, readonly) BOOL isShowing; // 是否正在展示

@property (nonatomic, assign) double duration; // 消失动画时间，默认为 1s。

@property (nonatomic, assign, getter=isTapDismiss) BOOL tapDismiss; // 点击背景是否消失

// 下面展示方法中 timeInterval 为定时器时间，即多长时间后消失，传 0 为不消失。
- (void)showWarmIMHUD:(double)timeInterval; // 展示菊花
- (void)showWarmIMTitleHUD:(NSString *)title timeInterval:(double)timeInterval; // 展示文字
- (void)showWarmIMTitleHUD:(NSString *)title imageName:(NSString *)imageName timeInterval:(double)timeInterval; // 展示图片+文字

- (void)dismissWarmIMHUDWithAnimated:(BOOL)animated;

@end
