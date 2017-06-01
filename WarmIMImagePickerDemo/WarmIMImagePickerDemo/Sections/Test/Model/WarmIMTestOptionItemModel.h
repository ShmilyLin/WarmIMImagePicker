//
//  WarmIMTestOptionItemModel.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+model.h"

typedef NS_ENUM(NSInteger, WarmIMTestOptionItemModelType) {
    WarmIMTestOptionItemModelTypeDefault = 0, // 默认类型
    WarmIMTestOptionItemModelTypeMore = 1, // 更多
    WarmIMTestOptionItemModelTypeSwitch = 2, // 开关
    WarmIMTestOptionItemModelTypePick = 3, // 选择器
};

@interface WarmIMTestOptionItemModel : NSObject<NSCoding>

- (instancetype)initWithTitle:(NSString *)title type:(WarmIMTestOptionItemModelType)type;

@property (nonatomic, strong) NSString *title; // 标题

@property (nonatomic, readonly, strong) NSString *descriptionContent; // 描述说明
@property (nonatomic, readonly, assign) CGFloat descriptionHeight; // 描述说明的高度

@property (nonatomic, assign, getter=isShowDescription) BOOL showDescription; // 是否展示描述

@property (nonatomic, assign) WarmIMTestOptionItemModelType type;

@property (nonatomic, assign, getter=isDisable) BOOL disable; // 禁止选择

@property (nonatomic, strong) NSArray *pickViewData; // pickView的展示数据

@property (nonatomic, assign) NSInteger selectedNumber; // 类型为WamIMTestOptionItemModelTypePick或者WamIMTestOptionItemModelTypeMore时的选择内容

@property (nonatomic, assign, getter=isSelected) BOOL selected; // 类型为WamIMTestOptionItemModelTypeSwitch时开关是否打开

@property (nonatomic, strong) NSString *selectedContent; // 类型为WamIMTestOptionItemModelTypeDefault或者WamIMTestOptionItemModelTypeMore时的选择内容的文字。

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) NSInteger index;


- (void)setDescriptionContent:(NSString *)description; // 设置描述说明

- (void)calculateDescriptionHeight;

@end
