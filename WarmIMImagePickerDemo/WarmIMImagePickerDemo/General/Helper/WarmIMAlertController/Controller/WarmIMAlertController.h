//
//  WarmIMAlertController.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WarmIMAlertAction.h"

@interface WarmIMAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(nullable NSString *)message;


- (void)addAction:(WarmIMAlertAction *_Nonnull)action;


@property (nullable, nonatomic, readonly, strong) NSArray<UIAlertAction *> *actions;

@property (nullable, nonatomic, strong, readonly) NSString *alertTitle;
@property (nullable, nonatomic, strong, readonly) NSString *message;

@property (nullable, nonatomic, strong) UIColor *topViewBackgroundColor;
@property (nullable, nonatomic, strong) UIColor *titleColor;
@property (nullable, nonatomic, strong) UIColor *messageColor;

// 是否允许点击半透明背景激活取消事件。
@property (nonatomic, assign, getter=isAllowTouchCancel) BOOL allowTouchCancel;

@end
