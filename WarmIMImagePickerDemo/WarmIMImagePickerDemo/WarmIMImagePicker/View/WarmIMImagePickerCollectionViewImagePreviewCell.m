//
//  WarmIMImagePickerCollectionViewImagePreviewCell.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/17.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMImagePickerCollectionViewImagePreviewCell.h"

@interface WarmIMImagePickerCollectionViewImagePreviewCell () <UIScrollViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation WarmIMImagePickerCollectionViewImagePreviewCell


#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubViews];
    }
    return self;
}

//- (void)layoutSubviews {
//    
//}


#pragma mark - UI

- (void)setupSubViews {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.backgroundColor = [UIColor blackColor];
//        _scrollView.contentSize = CGSizeMake(320, 460*10);
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
    simpleTapGesture.delegate = self;
    [_scrollView addGestureRecognizer:simpleTapGesture];
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, 0, 0)];
//        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:_imageView];
    }
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [_imageView addGestureRecognizer:doubleTapGesture];
    
    [simpleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.height]];
}

#pragma mark - Functions

- (void)setScrollViewContentSizeWithWidth:(CGFloat)imageWidth height:(CGFloat)imageHeight {
    
    [_scrollView setZoomScale:1.0];
    _scrollView.maximumZoomScale = 3;
    
    CGFloat tempScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat tempScreenHeight = [UIScreen mainScreen].bounds.size.height;
    if (imageWidth/imageHeight > tempScreenWidth/tempScreenHeight) { // 宽了
        if (imageWidth > tempScreenWidth) {
            _imageView.frame = CGRectMake(0, (tempScreenHeight - tempScreenWidth*imageHeight/imageWidth)/2, tempScreenWidth, tempScreenWidth*imageHeight/imageWidth);
            _scrollView.contentSize = CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height);
        }else {
            _imageView.frame = CGRectMake((tempScreenWidth - imageWidth)/2, (tempScreenHeight - imageHeight)/2, imageWidth, imageHeight);
            _scrollView.contentSize = CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height);
        }
    }else if (imageWidth/imageHeight < tempScreenWidth/tempScreenHeight) { // 高了
        if (imageHeight > tempScreenHeight) {
            _imageView.frame = CGRectMake((tempScreenWidth - tempScreenHeight*imageWidth/imageHeight)/2, 0, tempScreenHeight*imageWidth/imageHeight, tempScreenHeight);
            _scrollView.contentSize = CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height);
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
            _imageView.frame = CGRectMake((tempScreenWidth - imageWidth)/2, (tempScreenHeight - imageHeight)/2, imageWidth, imageHeight);
            _scrollView.contentSize = CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height);
        }
    }else { // 等于
        if (imageWidth <= tempScreenWidth) {
            _imageView.frame = CGRectMake((tempScreenWidth-imageWidth)/2, (tempScreenHeight - imageHeight)/2, imageWidth, imageHeight);
            _scrollView.contentSize = CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height);
        }else {
            _imageView.frame = CGRectMake(0, 0, tempScreenWidth, tempScreenHeight);
            _scrollView.contentSize = CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height);
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
    if ([self.delegate respondsToSelector:@selector(imagePreviewCellScrollViewSimpleTap)]) {
        [self.delegate imagePreviewCellScrollViewSimpleTap];
    }
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"正缩放呢，别烦：{%f, %f}", scrollView.contentSize.width, scrollView.contentSize.height);
    _imageView.center = CGPointMake(scrollView.bounds.size.width > scrollView.contentSize.width ? scrollView.bounds.size.width/2 : scrollView.contentSize.width/2, scrollView.bounds.size.height > scrollView.contentSize.height ? scrollView.bounds.size.height/2 : scrollView.contentSize.height/2);
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    
//}
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    
//}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
//    
//}
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//    NSLog(@"缩放结束时，缩放大小：%f\n缩放后的内容大小:{%f, %f}\n缩放后的图片大小：{%f, %f}\ncontentInset：{%f, %f, %f, %f}\nscrollIndicatorInsets：{%f, %f, %f, %f}\ncontentOffset：(%f, %f)", scale, scrollView.contentSize.width, scrollView.contentSize.height, view.frame.size.width, view.frame.size.height, scrollView.contentInset.top, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right, scrollView.scrollIndicatorInsets.top, scrollView.scrollIndicatorInsets.left, scrollView.scrollIndicatorInsets.bottom, scrollView.scrollIndicatorInsets.right, scrollView.contentOffset.x, scrollView.contentOffset.y);
//}

//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
//    
//}
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
//    
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
//        NSLog(@"numberOfTapsRequired:%lu", (unsigned long)((UITapGestureRecognizer *)gestureRecognizer).numberOfTapsRequired);
//        if (gestureRecognizer.view == _scrollView) {
//            NSLog(@"手势接收者是ScrollView");
//        }
//    }
//    return NO;
//}

@end
