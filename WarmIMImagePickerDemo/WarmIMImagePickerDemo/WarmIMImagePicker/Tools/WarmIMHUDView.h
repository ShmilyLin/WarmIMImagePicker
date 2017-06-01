//
//  WarmIMHUDView.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/8.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, WarmIMHUDViewType) {
    WarmIMHUDViewTypeLoading   = 0, // 加载
    WarmIMHUDViewTypeText      = 1, // 提示
    WarmIMHUDViewTypeImageText = 2  // 图片加提示
};

@interface WarmIMHUDView : UIView

- (instancetype)initWithType:(WarmIMHUDViewType)type information:(NSDictionary *)info;

@property (nonatomic, strong) UIView *backgroundView; // 背景
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView; // 菊花
@property (nonatomic, strong) UIImageView *tipImageView; // 图片
@property (nonatomic, strong) UILabel *titleLabel; // 文字提示
@property (nonatomic, assign) WarmIMHUDViewType type;

- (void)reloadWithInformation:(NSDictionary *)info;


@end
