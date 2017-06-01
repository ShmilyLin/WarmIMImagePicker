//
//  WarmIMImagePickerVideoPreviewBottomView.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/22.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMImagePickerVideoPreviewBottomView.h"

@implementation WarmIMImagePickerVideoPreviewBottomView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self setupSubViews];
    }
    return self;
}

#pragma mark - UI
- (void)setupSubViews {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 0, 0);
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_cancelButton];
    }
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(0, 0, 0, 0);
//        [_playButton setTitle:@"好" forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"WarmIM_video_play"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"WarmIM_video_pause"] forState:UIControlStateSelected];
//        [_playButton setBackgroundColor:[UIColor redColor]];
        _playButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_playButton];
    }
    if (!_determineButton) {
        _determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _determineButton.frame = CGRectMake(0, 0, 0, 0);
        [_determineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_determineButton setTitle:@"选择" forState:UIControlStateNormal];
        _determineButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_determineButton];
    }
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_playButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_playButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_playButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_playButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_playButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_cancelButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_cancelButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_cancelButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_cancelButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_determineButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_determineButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_determineButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_determineButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
}

@end
