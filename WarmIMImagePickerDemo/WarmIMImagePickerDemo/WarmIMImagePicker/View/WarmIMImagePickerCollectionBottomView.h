//
//  WarmIMImagePickerCollectionBottomView.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/9.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WarmIMImagePickerCollectionBottomView;

@protocol WarmIMImagePickerCollectionBottomViewDelegate <NSObject>

@optional

- (void)WarmIMImagePickerCollectionBottomView:(WarmIMImagePickerCollectionBottomView *)bottomView previewButtonClicked:(UIButton *)previewButton;

- (void)WarmIMImagePickerCollectionBottomView:(WarmIMImagePickerCollectionBottomView *)bottomView originalButtonClicked:(UIButton *)originalButton;

- (void)WarmIMImagePickerCollectionBottomView:(WarmIMImagePickerCollectionBottomView *)bottomView determineButtonClicked:(UIButton *)determineButton;

@end

@interface WarmIMImagePickerCollectionBottomView : UIView

@property (nonatomic, weak) id<WarmIMImagePickerCollectionBottomViewDelegate> delegate;

@property (nonatomic, strong) UIButton *previewButton; // 预览
@property (nonatomic, strong) UIButton *originalButton; // 原图
@property (nonatomic, strong) UIButton *determineButton; // 确定

@end
