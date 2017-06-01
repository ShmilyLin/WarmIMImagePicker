//
//  WarmIMImagePickerCollectionViewImageCell.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/9.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WarmIMImagePickerAssetModel.h"

@class WarmIMImagePickerCollectionViewImageCell;

@protocol WarmIMImagePickerCollectionViewImageCellDelegate <NSObject>

@optional
- (void)WarmIMImagePickerCollectionViewImageCell:(WarmIMImagePickerCollectionViewImageCell *)imageCell selectButtonClickedModel:(WarmIMImagePickerAssetModel *)assetModel indexPath:(NSIndexPath *)indexPath;


@end

@interface WarmIMImagePickerCollectionViewImageCell : UICollectionViewCell

@property (nonatomic, weak) id<WarmIMImagePickerCollectionViewImageCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, strong) WarmIMImagePickerAssetModel *assetModel;
//@property (nonatomic, strong) UIImageView *identificationView;

- (void)showSelectedView;
- (void)dismissSelectedView;

@end
