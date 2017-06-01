//
//  WarmIMImagePickerCollectionViewLivePhotoCell.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/18.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>

#import "WarmIMImagePickerAssetModel.h"

@class WarmIMImagePickerCollectionViewLivePhotoCell;
@protocol WarmIMImagePickerCollectionViewLivePhotoCellDelegate <NSObject>

@optional
- (void)WarmIMImagePickerCollectionViewLivePhotoCell:(WarmIMImagePickerCollectionViewLivePhotoCell *)imageCell selectButtonClickedModel:(WarmIMImagePickerAssetModel *)assetModel indexPath:(NSIndexPath *)indexPath;

@end

@interface WarmIMImagePickerCollectionViewLivePhotoCell : UICollectionViewCell

@property (nonatomic, weak) id<WarmIMImagePickerCollectionViewLivePhotoCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) PHLivePhotoView *livePhotoView;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, strong) WarmIMImagePickerAssetModel *assetModel;
//@property (nonatomic, strong) UIImageView *identificationView;

- (void)setLivePhoto:(PHLivePhoto *)livePhoto;

- (void)showSelectedView;
- (void)dismissSelectedView;

@end
