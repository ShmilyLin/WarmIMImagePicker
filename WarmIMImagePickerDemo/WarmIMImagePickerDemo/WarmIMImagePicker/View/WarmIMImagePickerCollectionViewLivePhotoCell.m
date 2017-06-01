//
//  WarmIMImagePickerCollectionViewLivePhotoCell.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/18.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMImagePickerCollectionViewLivePhotoCell.h"

#import "WarmIMImagePickerManager.h"

@interface WarmIMImagePickerCollectionViewLivePhotoCell() <UIGestureRecognizerDelegate, PHLivePhotoViewDelegate>

@property (nonatomic, strong) UIView *selectedView;

@property (nonatomic, strong) UIView *badgeView;
@property (nonatomic, strong) NSLayoutConstraint *badgeViewLayoutConstraintWidth;
@property (nonatomic, strong) UILabel *badgeLabel;
@property (nonatomic, strong) UIImageView *badgeImageView;

@property (nonatomic, assign) BOOL isPlayback;

@end

@implementation WarmIMImagePickerCollectionViewLivePhotoCell

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isPlayback = NO;
        [self setupSubViews];
    }
    return self;
}

#pragma mark - UI

- (void)setupSubViews {
    if (!_livePhotoView) {
        _livePhotoView = [[PHLivePhotoView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _livePhotoView.translatesAutoresizingMaskIntoConstraints = NO;
        _livePhotoView.contentMode = UIViewContentModeScaleAspectFill;
        _livePhotoView.clipsToBounds = YES;
        _livePhotoView.muted = YES;
        _livePhotoView.delegate = self;
        [_livePhotoView.playbackGestureRecognizer cancelsTouchesInView];
//        [_livePhotoView.playbackGestureRecognizer addTarget:self action:@selector(fouceLivePhotoView:)];
//        _livePhotoView.playbackGestureRecognizer.delegate = self;
        [self.contentView addSubview:_livePhotoView];
    }
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _contentImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.clipsToBounds = YES;
        [self.contentView addSubview:_contentImageView];
    }
    if (!_badgeView) {
        _badgeView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
        _badgeView.translatesAutoresizingMaskIntoConstraints = NO;
        _badgeView.layer.cornerRadius = 3;
        _badgeView.layer.masksToBounds = YES;
        _badgeView.contentMode = UIViewContentModeScaleAspectFill;
        _badgeView.clipsToBounds = YES;
        [self.contentView addSubview:_badgeView];
    }
    if (!_badgeImageView) {
        _badgeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        _badgeImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _badgeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _badgeImageView.clipsToBounds = YES;
        [_badgeImageView setImage:[PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent]];
        [_badgeView addSubview:_badgeImageView];
    }
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 30, 25)];
        _badgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _badgeLabel.text = @"LIVE";
        _badgeLabel.font = [UIFont systemFontOfSize:12];
        [_badgeView addSubview:_badgeLabel];
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
    // LivePhoto
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_livePhotoView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_livePhotoView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_livePhotoView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_livePhotoView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    // contentImageView
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    // badgeView
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_badgeView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_livePhotoView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:4.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_badgeView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_livePhotoView attribute:NSLayoutAttributeTop multiplier:1.0 constant:4.0]];
    _badgeViewLayoutConstraintWidth = [NSLayoutConstraint constraintWithItem:_badgeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20.0];
    [self.contentView addConstraint:_badgeViewLayoutConstraintWidth];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_badgeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20.0]];
    
    // badgeImageView
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_badgeImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_badgeView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_badgeImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_badgeView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_badgeImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_badgeView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_badgeImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_badgeImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    
    // badgeLabel
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_badgeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_badgeImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_badgeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_badgeView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_badgeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_badgeView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_badgeLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_badgeView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    // selectedButton
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:25.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_selectButton attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
}

#pragma mark - functions

- (void)setLivePhoto:(PHLivePhoto *)livePhoto {
    _livePhotoView.livePhoto = livePhoto;
    if (_isPlayback) {
        [_livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
        _isPlayback = NO;
    }
}

- (void)showSelectedView {
    if (!_selectedView) {
        _selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _selectedView.translatesAutoresizingMaskIntoConstraints = NO;
        _selectedView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [self.livePhotoView addSubview:_selectedView];
        [self.contentView bringSubviewToFront:_selectButton];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_livePhotoView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_livePhotoView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_livePhotoView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_livePhotoView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    }
    _selectedView.hidden = NO;
    if (_livePhotoView.livePhoto) {
        [_livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
    }else {
        _isPlayback = YES;
    }
    
    if (_badgeView) {
        _badgeViewLayoutConstraintWidth.constant = 50;
        _badgeLabel.hidden = NO;
        _badgeView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    }
}

- (void)dismissSelectedView {
    if (_selectedView) {
        _selectedView.hidden = YES;
    }
    if (_livePhotoView) {
        [_livePhotoView stopPlayback];
    }
    if (_badgeView) {
        _badgeViewLayoutConstraintWidth.constant = 20;
        _badgeLabel.hidden = YES;
        _badgeView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - actions
- (void)selectButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WarmIMImagePickerCollectionViewLivePhotoCell:selectButtonClickedModel:indexPath:)]) {
        WarmIMWeak(self);
        WarmIMWeak(_assetModel);
        WarmIMWeak(_index);
        [self.delegate WarmIMImagePickerCollectionViewLivePhotoCell:Weakself selectButtonClickedModel:Weak_assetModel indexPath:Weak_index];
    }
}

- (void)fouceLivePhotoView:(UIGestureRecognizer *)playbackGestureRecognizer {
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return NO;
}

#pragma mark - PHLivePhotoViewDelegate

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView willBeginPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle {
    if (_contentImageView) {
        _contentImageView.hidden = YES;
    }
}

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView didEndPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle {
    _contentImageView.hidden = NO;
}

@end
