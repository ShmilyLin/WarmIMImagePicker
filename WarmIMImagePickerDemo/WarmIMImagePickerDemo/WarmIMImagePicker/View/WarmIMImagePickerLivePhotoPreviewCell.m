//
//  WarmIMImagePickerLivePhotoPreviewCell.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/18.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMImagePickerLivePhotoPreviewCell.h"

@interface WarmIMImagePickerLivePhotoPreviewCell() <UIScrollViewDelegate>

@end

@implementation WarmIMImagePickerLivePhotoPreviewCell

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark - UI
- (void)setupSubViews {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_scrollView];
    }
    UITapGestureRecognizer *simpleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSimpleTap:)];
    [_scrollView addGestureRecognizer:simpleTapGesture];
    
    if (!_livePhotoView) {
        _livePhotoView = [[PHLivePhotoView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, 0, 0)];
        _livePhotoView.backgroundColor = [UIColor blackColor];
        _livePhotoView.contentMode = UIViewContentModeScaleAspectFit;
        _livePhotoView.userInteractionEnabled = YES;
        [_scrollView addSubview:_livePhotoView];
    }
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [_livePhotoView addGestureRecognizer:doubleTapGesture];
    
    [simpleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
}
#pragma mark - Functions

- (void)setScrollViewContentSizeWithWidth:(CGFloat)imageWidth height:(CGFloat)imageHeight {
    
    [_scrollView setZoomScale:1.0];
    _scrollView.maximumZoomScale = 3;
    
    CGFloat tempScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat tempScreenHeight = [UIScreen mainScreen].bounds.size.height;
    if (imageWidth/imageHeight > tempScreenWidth/tempScreenHeight) { // 宽了
        if (imageWidth > tempScreenWidth) {
            _livePhotoView.frame = CGRectMake(0, (tempScreenHeight - tempScreenWidth*imageHeight/imageWidth)/2, tempScreenWidth, tempScreenWidth*imageHeight/imageWidth);
            _scrollView.contentSize = CGSizeMake(_livePhotoView.frame.size.width, _livePhotoView.frame.size.height);
        }else {
            _livePhotoView.frame = CGRectMake((tempScreenWidth - imageWidth)/2, (tempScreenHeight - imageHeight)/2, imageWidth, imageHeight);
            _scrollView.contentSize = CGSizeMake(_livePhotoView.frame.size.width, _livePhotoView.frame.size.height);
        }
    }else if (imageWidth/imageHeight < tempScreenWidth/tempScreenHeight) { // 高了
        if (imageHeight > tempScreenHeight) {
            _livePhotoView.frame = CGRectMake((tempScreenWidth - tempScreenHeight*imageWidth/imageHeight)/2, 0, tempScreenHeight*imageWidth/imageHeight, tempScreenHeight);
            _scrollView.contentSize = CGSizeMake(_livePhotoView.frame.size.width, _livePhotoView.frame.size.height);
            if (imageHeight/imageWidth - tempScreenHeight/tempScreenWidth > 0.5) { // 特长
                CGFloat tempRatio = tempScreenWidth/(tempScreenHeight*imageWidth/imageHeight);
                if (tempRatio > 3) {
                    _scrollView.maximumZoomScale = tempRatio;
                    _scrollView.zoomScale = tempRatio;
                }else {
                    _scrollView.zoomScale = tempRatio;
                }
                _scrollView.contentOffset = CGPointMake(0, 0);
            }
        }else {
            _livePhotoView.frame = CGRectMake((tempScreenWidth - imageWidth)/2, (tempScreenHeight - imageHeight)/2, imageWidth, imageHeight);
            _scrollView.contentSize = CGSizeMake(_livePhotoView.frame.size.width, _livePhotoView.frame.size.height);
        }
    }else { // 等于
        if (imageWidth <= tempScreenWidth) {
            _livePhotoView.frame = CGRectMake((tempScreenWidth-imageWidth)/2, (tempScreenHeight - imageHeight)/2, imageWidth, imageHeight);
            _scrollView.contentSize = CGSizeMake(_livePhotoView.frame.size.width, _livePhotoView.frame.size.height);
        }else {
            _livePhotoView.frame = CGRectMake(0, 0, tempScreenWidth, tempScreenHeight);
            _scrollView.contentSize = CGSizeMake(_livePhotoView.frame.size.width, _livePhotoView.frame.size.height);
        }
    }
    
}
#pragma mark - Actions
- (void)handleDoubleTap:(UIGestureRecognizer *)gesture {
    CGFloat zoomScale = _scrollView.minimumZoomScale;
    if (_scrollView.zoomScale == _scrollView.minimumZoomScale) {
        zoomScale = _scrollView.maximumZoomScale;
    }
    CGRect zoomRect = [self zoomRectForScale:zoomScale withCenter:[gesture locationInView:gesture.view]];
    [_scrollView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height =self.frame.size.height / scale;
    zoomRect.size.width  =self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

- (void)handleSimpleTap:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(livePhotoPreviewCellScrollViewSimpleTap)]) {
        [self.delegate livePhotoPreviewCellScrollViewSimpleTap];
    }
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    _livePhotoView.center = CGPointMake(scrollView.bounds.size.width > scrollView.contentSize.width ? scrollView.bounds.size.width/2 : scrollView.contentSize.width/2, scrollView.bounds.size.height > scrollView.contentSize.height ? scrollView.bounds.size.height/2 : scrollView.contentSize.height/2);
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _livePhotoView;
}

@end
