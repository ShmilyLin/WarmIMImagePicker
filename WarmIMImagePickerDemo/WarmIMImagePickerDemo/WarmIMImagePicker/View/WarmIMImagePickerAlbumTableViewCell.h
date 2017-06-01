//
//  WarmIMImagePickerAlbumTableViewCell.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/4/30.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarmIMImagePickerAlbumTableViewCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;


@property (nonatomic, strong) UIImageView *logoImageView; // 左侧图片

@property (nonatomic, strong) UILabel *nameLabel; // 相簿名字

@property (nonatomic, strong) UILabel *countLabel; // 相簿数量

@property (nonatomic, strong) UIImageView *rightArrowImageView; // 右侧箭头

@end
