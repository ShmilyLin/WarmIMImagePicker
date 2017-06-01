//
//  WarmIMImagePickerCollectionModel.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/1.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

#import "WarmIMImagePickerAssetModel.h"

@interface WarmIMImagePickerCollectionModel : NSObject

@property (nonatomic, strong) PHAssetCollection *collection; // 相簿
@property (nonatomic, strong) PHFetchResult *collectionFetchResult; // 相簿内容
@property (nonatomic, strong) PHFetchResult *collectionImageFetchResult; // 相册中的图片内容

@property (nonatomic, strong) PHAsset *keyAsset;

@property (nonatomic, strong) NSMutableArray<PHAsset *> *assets; // 相片集合
@property (nonatomic, strong) NSMutableArray<WarmIMImagePickerAssetModel *> *assetModels; // 相片模型集合

@property (nonatomic, strong) NSMutableArray<PHAsset *> *imageAssets; // 图片集合
@property (nonatomic, strong) NSMutableArray<WarmIMImagePickerAssetModel *> *imageAssetModels; // 图片模型集合

@property (nonatomic, strong) NSString *name; // 相簿名字
@property (nonatomic, assign) NSInteger count; // 相簿中相片的名字
@property (nonatomic, assign) BOOL selected; // 是否被选中






@end
