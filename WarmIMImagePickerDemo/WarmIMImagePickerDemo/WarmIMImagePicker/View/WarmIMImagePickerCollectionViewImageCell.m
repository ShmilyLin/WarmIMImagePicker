//
//  WarmIMImagePickerCollectionViewImageCell.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/9.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMImagePickerCollectionViewImageCell.h"

#import "WarmIMImagePickerManager.h"

@interface WarmIMImagePickerCollectionViewImageCell()

@property (nonatomic, strong) UIView *selectedView;

@end

@implementation WarmIMImagePickerCollectionViewImageCell

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
        [self.contentView addSubview:_contentImageView];
    }
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(0, 0, 0, 0);
        _selectButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"WarmIM_checkbox_normal"] forState:UIControlStateNormal];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"WarmIM_checkbox_selected"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectButton];
    }
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:25.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_selectButton attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
}

#pragma mark - functions

- (void)showSelectedView {
    if (!_selectedView) {
        _selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _selectedView.translatesAutoresizingMaskIntoConstraints = NO;
        _selectedView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [self.contentImageView addSubview:_selectedView];
        [self.contentView bringSubviewToFront:_selectButton];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    }
    _selectedView.hidden = NO;
}

- (void)dismissSelectedView {
    if (_selectedView) {
        _selectedView.hidden = YES;
    }
}

#pragma mark - actions
- (void)selectButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WarmIMImagePickerCollectionViewImageCell:selectButtonClickedModel:indexPath:)]) {
        WarmIMWeak(self);
        WarmIMWeak(_assetModel);
        WarmIMWeak(_index);
        [self.delegate WarmIMImagePickerCollectionViewImageCell:Weakself selectButtonClickedModel:Weak_assetModel indexPath:Weak_index];
    }
}
@end
