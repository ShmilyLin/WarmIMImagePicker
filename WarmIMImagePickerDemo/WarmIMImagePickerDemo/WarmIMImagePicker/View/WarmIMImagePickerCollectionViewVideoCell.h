//
//  WarmIMImagePickerCollectionViewVideoCell.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/9.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WarmIMImagePickerCollectionViewVideoCell : UICollectionViewCell


@property (nonatomic, strong) UIImageView *contentImageView; // 缩略图
@property (nonatomic, strong) UIView *bottomView; // 底部背景
@property (nonatomic, strong) UIImageView *logoImageView; // 视频logo
@property (nonatomic, strong) UILabel *durationLabel; // 视频时长

@end
