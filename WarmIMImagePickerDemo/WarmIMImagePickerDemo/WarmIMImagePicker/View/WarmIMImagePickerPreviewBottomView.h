//
//  WarmIMImagePickerPreviewBottomView.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/17.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WarmIMImagePickerPreviewBottomView;
@protocol WarmIMImagePickerPreviewBottomViewDelegate <NSObject>

@optional

- (void)WarmIMImagePickerPreviewBottomView:(WarmIMImagePickerPreviewBottomView *)bottomView originalButtonClicked:(UIButton *)originalButton;

- (void)WarmIMImagePickerPreviewBottomView:(WarmIMImagePickerPreviewBottomView *)bottomView determineButtonClicked:(UIButton *)determineButton;

@end

@interface WarmIMImagePickerPreviewBottomView : UIView

@property (nonatomic, weak) id<WarmIMImagePickerPreviewBottomViewDelegate> delegate;

@property (nonatomic, strong) UIButton *originalButton; // 原图
@property (nonatomic, strong) UIButton *determineButton;

@end
