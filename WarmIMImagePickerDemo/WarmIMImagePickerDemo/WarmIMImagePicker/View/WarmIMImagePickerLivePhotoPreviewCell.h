//
//  WarmIMImagePickerLivePhotoPreviewCell.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/18.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>


@protocol WarmIMImagePickerLivePhotoPreviewCellDelegate <NSObject>

@optional
- (void)livePhotoPreviewCellScrollViewSimpleTap;

@end

@interface WarmIMImagePickerLivePhotoPreviewCell : UICollectionViewCell

@property (nonatomic, weak) id<WarmIMImagePickerLivePhotoPreviewCellDelegate> delegate;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) PHLivePhotoView *livePhotoView;

- (void)setScrollViewContentSizeWithWidth:(CGFloat)imageWidth height:(CGFloat)imageHeight;

@end
