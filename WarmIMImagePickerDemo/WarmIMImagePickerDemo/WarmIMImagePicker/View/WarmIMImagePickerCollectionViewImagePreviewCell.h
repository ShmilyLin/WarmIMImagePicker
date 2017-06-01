//
//  WarmIMImagePickerCollectionViewImagePreviewCell.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/17.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WarmIMImagePickerCollectionViewImagePreviewCellDelegate <NSObject>

@optional
- (void)imagePreviewCellScrollViewSimpleTap;

@end

@interface WarmIMImagePickerCollectionViewImagePreviewCell : UICollectionViewCell

@property (nonatomic, weak) id<WarmIMImagePickerCollectionViewImagePreviewCellDelegate> delegate;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

- (void)setScrollViewContentSizeWithWidth:(CGFloat)imageWidth height:(CGFloat)imageHeight;

@end
