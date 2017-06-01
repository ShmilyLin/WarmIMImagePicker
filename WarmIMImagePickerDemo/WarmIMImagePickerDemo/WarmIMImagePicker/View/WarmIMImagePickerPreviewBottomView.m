//
//  WarmIMImagePickerPreviewBottomView.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/17.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMImagePickerPreviewBottomView.h"
#import "WarmIMImagePickerManager.h"

@implementation WarmIMImagePickerPreviewBottomView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [self setupSubViews];
    }
    return self;
}

#pragma mark - UI
- (void)setupSubViews {
    if ([WarmIMImagePickerManager sharedManager].isShowSendSource) {
        if (!_originalButton) {
            _originalButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _originalButton.frame = CGRectMake(0, 0, 0, 0);
            _originalButton.translatesAutoresizingMaskIntoConstraints = NO;
            _originalButton.imageEdgeInsets = UIEdgeInsetsMake(3, 11, 3, 45);
            [_originalButton setTitle:[[WarmIMGlobal sharedGlobal] showText:@"Original"] forState:UIControlStateNormal];
            [_originalButton setImage:[UIImage imageNamed:@"WarmIM_not_selected_gray"] forState:UIControlStateNormal];
            [_originalButton setImage:[UIImage imageNamed:@"WarmIM_checkbox_selected"] forState:UIControlStateSelected];
            [_originalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_originalButton addTarget:self action:@selector(originalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_originalButton];
        }
    }
    
    if (!_determineButton) {
        _determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _determineButton.frame = CGRectMake(0, 0, 0, 0);
        _determineButton.translatesAutoresizingMaskIntoConstraints = NO;
        _determineButton.layer.cornerRadius = 5;
        _determineButton.layer.masksToBounds = YES;
        [_determineButton setBackgroundColor:[UIColor colorWithRed:142/255.0 green:86/255.0 blue:246/255.0 alpha:1.0]];
        [_determineButton setTitle:[[WarmIMGlobal sharedGlobal] showText:@"OK"] forState:UIControlStateNormal];
        [_determineButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_determineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_determineButton addTarget:self action:@selector(determineButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_determineButton];
    }
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    if ([WarmIMImagePickerManager sharedManager].isShowSendSource) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_originalButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_originalButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_originalButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_originalButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    }
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_determineButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_determineButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_determineButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_determineButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35.0]];
}

- (void)originalButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WarmIMImagePickerPreviewBottomView:originalButtonClicked:)]) {
        WarmIMWeak(self);
        WarmIMWeak(sender);
        [self.delegate WarmIMImagePickerPreviewBottomView:Weakself originalButtonClicked:Weaksender];
    }
}
- (void)determineButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WarmIMImagePickerPreviewBottomView:determineButtonClicked:)]) {
        WarmIMWeak(self);
        WarmIMWeak(sender);
        [self.delegate WarmIMImagePickerPreviewBottomView:Weakself determineButtonClicked:Weaksender];
    }
}


@end
