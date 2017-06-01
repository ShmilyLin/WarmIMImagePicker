//
//  WarmIMImagePickerCollectionViewVideoCell.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/9.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMImagePickerCollectionViewVideoCell.h"

@implementation WarmIMImagePickerCollectionViewVideoCell

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
        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _contentImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.clipsToBounds = YES;
        [self.contentView addSubview:_contentImageView];
    }
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
        [self.contentView addSubview:_bottomView];
    }
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_logoImageView setImage:[UIImage imageNamed:@"WarmIM_video_logo"]];
        [self.contentView addSubview:_logoImageView];
    }
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _durationLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.font = [UIFont systemFontOfSize:12];
        _durationLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_durationLabel];
    }
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:25.0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_logoImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_durationLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_durationLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_durationLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_durationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_logoImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:5.0]];
    
}
@end
