//
//  WarmIMImagePickerCollectionViewCameraCell.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/9.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMImagePickerCollectionViewCameraCell.h"

@implementation WarmIMImagePickerCollectionViewCameraCell

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark - UI
- (void)setupSubViews {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _contentImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.clipsToBounds = YES;
        [_contentImageView setImage:[UIImage imageNamed:@"WarmIM_camera_purple"]];
        [self.contentView addSubview:_contentImageView];
    }
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10.0]];
}

@end
