//
//  WarmIMImagePickerCollectionViewLayout.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/11.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WarmIMImagePickerCollectionViewLayout;

@protocol WarmIMImagePickerCollectionViewLayoutDelegate <UICollectionViewDelegate>

@optional

// Cell的大小
- (CGSize)sizeForCollectionViewItem:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout;
// Content的偏移量
- (UIEdgeInsets)insetForCollectionViewContent:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout;
// Section中每行的最小距离
- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout;
// 每个Cell之间的距离
- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout;

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

@end



@interface WarmIMImagePickerCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) CGFloat minimumLineSpacing; // 每行的最小距离
@property (nonatomic) CGFloat minimumInteritemSpacing; // 每个item的最小距离
@property (nonatomic) CGSize itemSize; // item的大小
@property (nonatomic) UIEdgeInsets contentInset; // section偏移量

@end
