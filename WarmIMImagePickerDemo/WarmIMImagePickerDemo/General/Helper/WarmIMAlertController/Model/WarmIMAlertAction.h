//
//  WarmIMAlertAction.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, WarmIMAlertActionStyle) {
    WarmIMAlertActionStyleDefault     = 0,
    WarmIMAlertActionStyleCancel      = 1,
    WarmIMAlertActionStyleDestructive = 2,
    WarmIMAlertActionStyleCustom      = 3
};

@interface WarmIMAlertAction : NSObject

+ (instancetype _Nonnull)actionWithTitle:(nullable NSString *)title style:(WarmIMAlertActionStyle)style handler:(void (^ __nullable)(WarmIMAlertAction * _Nonnull action))handler;

@property (nullable, nonatomic, strong) UIColor *backgroundColor; // 背景颜色

@property (nonatomic, assign) CGFloat height; // action的高度

@property (nullable, nonatomic, strong) UIColor *tintColor; // 内容颜色

@property (nullable, nonatomic, strong, readonly) NSString *title; // 标题

@property (nonatomic, assign, readonly) WarmIMAlertActionStyle style; // 类型

@property (nonatomic, assign, getter=isEnabled) BOOL enabled; // 是否允许点击

@property (nonatomic, strong, readonly) void(^ __nullable actionHandler)(WarmIMAlertAction * _Nullable action); // 回调

- (UIView *_Nullable)addViewToAction;

@end
