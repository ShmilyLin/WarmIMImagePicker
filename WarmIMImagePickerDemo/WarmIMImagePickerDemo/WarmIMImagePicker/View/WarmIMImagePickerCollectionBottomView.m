//
//  WarmIMImagePickerCollectionBottomView.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/9.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMImagePickerCollectionBottomView.h"

#import "WarmIMImagePickerManager.h"


@interface WarmIMImagePickerCollectionBottomView()

@property (nonatomic, strong) UIView *lineView;
@end
@implementation WarmIMImagePickerCollectionBottomView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark - UI
- (void)setupSubViews {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _lineView.translatesAutoresizingMaskIntoConstraints = NO;
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_lineView];
    }
    if (!_previewButton) {
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previewButton.enabled = NO;
        _previewButton.frame = CGRectMake(0, 0, 0, 0);
        _previewButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_previewButton setTitle:[[WarmIMGlobal sharedGlobal] showText:@"Preview"] forState:UIControlStateNormal];
        [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_previewButton setTitleColor:[UIColor colorWithRed:142/255.0 green:86/255.0 blue:246/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_previewButton addTarget:self action:@selector(previewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_previewButton];
    }
    if ([WarmIMImagePickerManager sharedManager].isShowSendSource) {
        if (!_originalButton) {
            _originalButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _originalButton.enabled = NO;
            _originalButton.frame = CGRectMake(0, 0, 0, 0);
            _originalButton.translatesAutoresizingMaskIntoConstraints = NO;
            _originalButton.imageEdgeInsets = UIEdgeInsetsMake(3, 11, 3, 45);
            [_originalButton setTitle:[[WarmIMGlobal sharedGlobal] showText:@"Original"] forState:UIControlStateNormal];
            [_originalButton setImage:[UIImage imageNamed:@"WarmIM_not_selected_gray"] forState:UIControlStateDisabled];
            [_originalButton setImage:[UIImage imageNamed:@"WarmIM_not_selected_purple"] forState:UIControlStateNormal];
            [_originalButton setImage:[UIImage imageNamed:@"WarmIM_checkbox_selected"] forState:UIControlStateSelected];
            [_originalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            [_originalButton setTitleColor:[UIColor colorWithRed:142/255.0 green:86/255.0 blue:246/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_originalButton addTarget:self action:@selector(originalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_originalButton];
        }
    }
    if (!_determineButton) {
        _determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _determineButton.enabled = NO;
        _determineButton.frame = CGRectMake(0, 0, 0, 0);
        _determineButton.translatesAutoresizingMaskIntoConstraints = NO;
        _determineButton.layer.cornerRadius = 5;
        _determineButton.layer.masksToBounds = YES;
        [_determineButton setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
        [_determineButton setTitle:[[WarmIMGlobal sharedGlobal] showText:@"OK"] forState:UIControlStateNormal];
        [_determineButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_determineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_determineButton addTarget:self action:@selector(determineButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_determineButton];
    }
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_previewButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_previewButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_previewButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_previewButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    
    if ([WarmIMImagePickerManager sharedManager].isShowSendSource) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_originalButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_previewButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:10.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_originalButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_originalButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_originalButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    }
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_determineButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_determineButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_determineButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_determineButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35.0]];
}


#pragma mark - actions
- (void)previewButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WarmIMImagePickerCollectionBottomView:previewButtonClicked:)]) {
        WarmIMWeak(self);
        WarmIMWeak(sender);
        [self.delegate WarmIMImagePickerCollectionBottomView:Weakself previewButtonClicked:Weaksender];
    }
}
- (void)originalButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WarmIMImagePickerCollectionBottomView:originalButtonClicked:)]) {
        WarmIMWeak(self);
        WarmIMWeak(sender);
        [self.delegate WarmIMImagePickerCollectionBottomView:Weakself originalButtonClicked:Weaksender];
    }
}
- (void)determineButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WarmIMImagePickerCollectionBottomView:determineButtonClicked:)]) {
        WarmIMWeak(self);
        WarmIMWeak(sender);
        [self.delegate WarmIMImagePickerCollectionBottomView:Weakself determineButtonClicked:Weaksender];
    }
}
@end
