//
//  WarmIMImagePickerManager.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/4/28.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMImagePickerManager.h"

#import <Photos/Photos.h>


@interface WarmIMImagePickerManager ()

//@property (nonatomic, strong) NSMutableDictionary *imagePickerConfig;
@property (nonatomic, assign) BOOL isShowImagePicker; // 是否已经展示页面

@end



@implementation WarmIMImagePickerManager

static WarmIMImagePickerManager *_instance;


#pragma mark - init
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (instancetype)sharedManager {
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        _instance = [[self alloc] init];
        _instance.libraryType = WarmIMImagePickerTypeAll; // 图片选择的类型
        _instance.jumpAllPicturesView = YES; // 是否直接跳转到所有照片页面
        _instance.showEmptyAlbum = YES; // 是否显示空的相册
        _instance.livePhotoLevel = WarmIMImagePickerLivePhotoLevelTranslate; // Live图片支持的等级
        _instance.imageCountMax = 20; // 图片的最大选择数量
        _instance.lineNumber = 4;
        _instance.allowScrollSelect = YES; // 是否允许滑动选择
//        _instance.markType = WarmIMImagePickerSelectedTypeCheckmark; // 选中图片的标记的类型
        _instance.isShowSendSource = YES; // 是否显示发送原图
        _instance.isShowTakePhoto = NO; // 是否在相片的最后显示打开摄像头的选项，默认为 NO。
        _instance.showPicturesSequential = YES; // 顺序展示相片，默认为YES。
        _instance.isFollowCustomNavigation = YES; // 是否跟随自定义的Navigation，默认为 YES。
        _instance.navigationBackgroundColor = [UIColor whiteColor]; // isFollowCustomNavigation为NO时，该设置有效。默认为白色。
        _instance.navigationTitleColor = [UIColor blueColor];
        _instance.allowiCloudDownload = WarmIMImagePickeriCloudDownloadTypeNo;
        
        _instance.selectedImageModels = [NSMutableArray array];
        _instance.selectedOriginalImageCount = 0;
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

#pragma mark - set&get

// lineNumber
- (void)setLineNumber:(NSInteger)lineNumber {
    if (_lineNumber != lineNumber) {
        if (lineNumber < 1) {
            _lineNumber = 1;
        }else if (lineNumber > 10) {
            _lineNumber = 10;
        }else {
            _lineNumber = lineNumber;
        }
    }
}

// currentDisplayCollection
- (void)setCurrentDisplayCollection:(WarmIMImagePickerCollectionModel *)currentDisplayCollection {
    if (_currentDisplayCollection != currentDisplayCollection) {
        // 取消缓存
//        [_cachingImageManager stopCachingImagesForAssets:_currentDisplayCollection.assets targetSize:CGSizeMake([self calculateThumbnailSize], [self calculateThumbnailSize]) contentMode:PHImageContentModeAspectFit options:nil];
        // 给定新的页面数据
        _currentDisplayCollection = currentDisplayCollection;
//        if (_currentDisplayCollection != nil) {
//            if (!_cachingImageManager) {
//                _cachingImageManager = [[PHCachingImageManager alloc]init];
//            }
//            if (_currentDisplayCollection.collectionFetchResult.count > 0) {
//                if (!_currentDisplayCollection.assets || _currentDisplayCollection.assets.count <= 0) {
//                    NSMutableArray *tempAssets = [NSMutableArray array];
//                    // 获取资源数组
//                    [_currentDisplayCollection.collectionFetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                        [tempAssets addObject:(PHAsset *)obj];
//                    }];
//                    _currentDisplayCollection.assets = tempAssets;
//                }
//                // 请求预缓存
//                [_cachingImageManager startCachingImagesForAssets:_currentDisplayCollection.assets targetSize:CGSizeMake([self calculateThumbnailSize], [self calculateThumbnailSize]) contentMode:PHImageContentModeAspectFit options:nil];
//            }
//            
//        }
    }
}

- (PHCachingImageManager *)cachingImageManager {
    if (!_cachingImageManager) {
        _cachingImageManager = [[PHCachingImageManager alloc]init];
    }
    return _cachingImageManager;
}



#pragma mark - functions
// 请求相册权限
- (void)requestPhotoLibraryAuthorization {
    [self requestPhotoLibraryAuthorization:nil];
}

- (void)requestPhotoLibraryAuthorization:(void(^)(void))successedResultBlock {
    WarmIMWeakSelf
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            if ([WeakSelf.delegate respondsToSelector:@selector(requestPhotoLibraryAuthorizationSuccessed)]) {
                [WeakSelf.delegate requestPhotoLibraryAuthorizationSuccessed];
            }
            if (successedResultBlock) {
                successedResultBlock();
            }
        }else {
            if ([WeakSelf.delegate respondsToSelector:@selector(requestPhotoLibraryAuthorizationFailed:)]) {
                [WeakSelf.delegate requestPhotoLibraryAuthorizationFailed:status];
            }
        }
    }];
}

// 展示相册选择
- (void)showPhotoLibrary {
    _isShowImagePicker = YES;
    if ([self.delegate respondsToSelector:@selector(WarmIMImagePickerShow)]) {
        [self.delegate WarmIMImagePickerShow];
    }
    // 监听按下home键
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(applicationWillResignActive:)
//                                                 name:UIApplicationWillResignActiveNotification
//                                               object:nil];
//    // 监听重新进入
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(applicationDidBecomeActive:)
//                                                 name:UIApplicationDidBecomeActiveNotification
//                                               object:nil];
}

- (void)dismissPhotoLibrary {
    [_cachingImageManager stopCachingImagesForAllAssets];
    [self cancelAllSelected];
    if ([self.delegate respondsToSelector:@selector(WarmIMImagePickerDismiss)]) {
        [self.delegate WarmIMImagePickerDismiss];
    }
//    _currentFetchResult = nil;
//    _currentDisplayCollection = nil;
}

// 获取所有系统内置相册
- (WarmIMImagePickerFetchResults *)getAllSmartAblum {
    // 初始化结果
    if (!_currentFetchResult) {
        _currentFetchResult = [[WarmIMImagePickerFetchResults alloc]init];
    }else {
        _currentFetchResult.userFetchResult = nil;
    }
    
    NSMutableArray *tempCollections = [[NSMutableArray alloc]init];
    // 获取系统相册
    PHFetchResult *tempAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    _currentFetchResult.systemFetchResult = tempAlbums;
    // 枚举相册
    [tempAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection *tempAlbum = (PHAssetCollection *)obj;
        // 初始化相簿模型
        WarmIMImagePickerCollectionModel *tempCollection = [[WarmIMImagePickerCollectionModel alloc]init];
        tempCollection.collection = tempAlbum;
        tempCollection.collectionFetchResult = [PHAsset fetchAssetsInAssetCollection:tempAlbum options:nil];
        [tempCollections addObject:tempCollection];
    }];
    _currentFetchResult.collections = tempCollections;
    NSLog(@"获取系统内置相册完毕");
    return _currentFetchResult;
}

// 获取所有用户自定义相册
- (WarmIMImagePickerFetchResults *)getAllUserAblum {
    // 初始化结果
    if (!_currentFetchResult) {
        _currentFetchResult = [[WarmIMImagePickerFetchResults alloc]init];
    }else {
        _currentFetchResult.systemFetchResult = nil;
    }
    NSMutableArray *tempCollections = [[NSMutableArray alloc]init];
    // 获取用户自定义相册
    PHFetchResult *tempAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    _currentFetchResult.userFetchResult = tempAlbums;
    [tempAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection *tempAlbum = (PHAssetCollection *)obj;
        WarmIMImagePickerCollectionModel *tempCollection = [[WarmIMImagePickerCollectionModel alloc]init];
        tempCollection.collection = tempAlbum;
        tempCollection.collectionFetchResult = [PHAsset fetchAssetsInAssetCollection:tempAlbum options:nil];
        [tempCollections addObject:tempCollection];
    }];
    _currentFetchResult.collections = tempCollections;
    NSLog(@"获取用户自定义相册完毕");
    return _currentFetchResult;
}


// 获取所有相册
- (WarmIMImagePickerFetchResults *)getAllAblums {
    if (!_currentFetchResult) {
        _currentFetchResult = [[WarmIMImagePickerFetchResults alloc]init];
    }
    NSMutableArray *tempCollections = [[NSMutableArray alloc]init];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    switch (_libraryType) {
        case WarmIMImagePickerTypeImages: {
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
        }
            break;
        case WarmIMImagePickerTypeVideo: {
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeVideo];
        }
            break;
        default:
            break;
    }
    // 获取系统相册
    PHFetchResult *tempSystemAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    _currentFetchResult.systemFetchResult = tempSystemAlbums;
    // 枚举相册
    WarmIMWeak(tempCollections)
    WarmIMWeak(fetchOptions)
    WarmIMWeakSelf
    [tempSystemAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *tempAlbum, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult *tempFetchResult = [PHAsset fetchAssetsInAssetCollection:tempAlbum options:WeakfetchOptions];
        if (_showEmptyAlbum || tempFetchResult.count > 0) {
            WarmIMImagePickerCollectionModel *tempCollection = [[WarmIMImagePickerCollectionModel alloc]init];
            tempCollection.collection = tempAlbum;
            tempCollection.collectionFetchResult = tempFetchResult;
            if (WeakSelf.libraryType == WarmIMImagePickerTypeImages) {
                tempCollection.collectionImageFetchResult = tempFetchResult;
            }else if (WeakSelf.libraryType == WarmIMImagePickerTypeAll) {
                PHFetchOptions *tempImageFetchOptions = [[PHFetchOptions alloc]init];
                tempImageFetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
                tempCollection.collectionImageFetchResult = [PHAsset fetchAssetsInAssetCollection:tempAlbum options:tempImageFetchOptions];
            }
            if (tempAlbum.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                [WeaktempCollections insertObject:tempCollection atIndex:0];
            }else {
                [WeaktempCollections addObject:tempCollection];
            }
        }
    }];
    // 获取用户自定义相册
    PHFetchResult *tempUserAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    _currentFetchResult.userFetchResult = tempUserAlbums;
    [tempUserAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *tempAlbum, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult *tempFetchResult =  [PHAsset fetchAssetsInAssetCollection:tempAlbum options:WeakfetchOptions];
        if (WeakSelf.showEmptyAlbum || tempFetchResult.count > 0) {
            WarmIMImagePickerCollectionModel *tempCollection = [[WarmIMImagePickerCollectionModel alloc]init];
            tempCollection.collection = tempAlbum;
            tempCollection.collectionFetchResult = tempFetchResult;
            [WeaktempCollections addObject:tempCollection];
        }
    }];
    _currentFetchResult.collections = tempCollections;
    return _currentFetchResult;
}

// 缓存当前页面的资源
- (void)cachingAssets {
    if (_currentDisplayCollection != nil) {
        if (!_cachingImageManager) {
            _cachingImageManager = [[PHCachingImageManager alloc]init];
        }
        if (_currentDisplayCollection.collectionFetchResult.count > 0) {
            if (!_currentDisplayCollection.assets || _currentDisplayCollection.assets.count <= 0) {
                NSMutableArray *tempAssets = [NSMutableArray array];
                NSMutableArray *tempAssetModels = [NSMutableArray array];
                NSMutableArray *tempImageAssets = [NSMutableArray array];
                NSMutableArray *tempImageAssetModels = [NSMutableArray array];
                // 获取资源数组
                [_currentDisplayCollection.collectionFetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    PHAsset *tempAsset = (PHAsset *)obj;
                    WarmIMImagePickerAssetModel *tempAssetModel = [[WarmIMImagePickerAssetModel alloc]init];
                    tempAssetModel.asset = tempAsset;
                    [tempAssets addObject:tempAsset];
                    [tempAssetModels addObject:tempAssetModel];
                    if (tempAsset.mediaType == PHAssetMediaTypeImage) {
                        [tempImageAssets addObject:tempAsset];
                        [tempImageAssetModels addObject:tempAssetModel];
                    }
                }];
                _currentDisplayCollection.assets = tempAssets;
                _currentDisplayCollection.assetModels = tempAssetModels;
                _currentDisplayCollection.imageAssets = tempImageAssets;
                _currentDisplayCollection.imageAssetModels = tempImageAssetModels;
            }
            // 请求预缓存
            [_cachingImageManager startCachingImagesForAssets:_currentDisplayCollection.assets targetSize:CGSizeMake([self calculateThumbnailSize], [self calculateThumbnailSize]) contentMode:PHImageContentModeAspectFill options:nil];
        }
        
    }
}

// 取消所有选择
- (void)cancelAllSelected {
    _currenDisplayModel = nil; // 当前正在展示的模型
    if (_selectedImageModels && _selectedImageModels.count > 0) {
        for (int i = 0;i<_selectedImageModels.count;i++) {
            WarmIMImagePickerAssetModel *tempModel = _selectedImageModels[i];
            tempModel.selected = NO;
            tempModel.isSelectedOriginalImage = NO;
        }
        [_selectedImageModels removeAllObjects]; // 已选择的图片资源。
    }
    _selectedVideoModel = nil; // 已选择的视频资源
    _selectedOriginalImageCount = 0; // 选择了原图的数量
}

// 请求图片数据
- (PHImageRequestID)requestImageForAsset:(PHAsset *_Nonnull)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(nullable PHImageRequestOptions *)options resultHandler:(void (^_Nonnull)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler {
    return [_cachingImageManager requestImageForAsset:asset targetSize:targetSize contentMode:contentMode options:options resultHandler:resultHandler];
}
- (PHImageRequestID)requestImageDataForAsset:(PHAsset *_Nonnull)asset options:(nullable PHImageRequestOptions *)options resultHandler:(void(^_Nonnull)(NSData *__nullable imageData, NSString *__nullable dataUTI, UIImageOrientation orientation, NSDictionary *__nullable info))resultHandler {
    return [_cachingImageManager requestImageDataForAsset:asset options:options resultHandler:resultHandler];
}

// 请求LivePhoto
- (PHImageRequestID)requestLivePhotoForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(PHLivePhotoRequestOptions *)options resultHandler:(void (^)(PHLivePhoto * _Nullable, NSDictionary * _Nullable))resultHandler {
    return [_cachingImageManager requestLivePhotoForAsset:asset targetSize:targetSize contentMode:contentMode options:options resultHandler:resultHandler];
}

// 请求视频
- (PHImageRequestID)requestPlayerItemForVideo:(PHAsset *)asset options:(PHVideoRequestOptions *)options resultHandler:(void (^)(AVPlayerItem * _Nullable, NSDictionary * _Nullable))resultHandler {
    return [_cachingImageManager requestPlayerItemForVideo:asset options:options resultHandler:resultHandler];
}

- (PHImageRequestID)requestExportSessionForVideo:(PHAsset *)asset options:(PHVideoRequestOptions *)options exportPreset:(NSString *)exportPreset resultHandler:(void (^)(AVAssetExportSession * _Nullable, NSDictionary * _Nullable))resultHandler {
    return [_cachingImageManager requestExportSessionForVideo:asset options:options exportPreset:exportPreset resultHandler:resultHandler];
}

- (PHImageRequestID)requestAVAssetForVideo:(PHAsset *)asset options:(PHVideoRequestOptions *)options resultHandler:(void (^)(AVAsset * _Nullable, AVAudioMix * _Nullable, NSDictionary * _Nullable))resultHandler {
    return [_cachingImageManager requestAVAssetForVideo:asset options:options resultHandler:resultHandler];
}

// 取消请求
- (void)cancelImageRequest:(PHImageRequestID)requestID {
    [_cachingImageManager cancelImageRequest:requestID];
}

#pragma mark - NotificationEvents
// 监听按下home键
- (void)applicationWillResignActive:(NSNotification *)notification {
    if (_isShowImagePicker) {
//        NSLog(@"按下Home键：%@", notification);
    }
}

// 监听重新进入
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (_isShowImagePicker) {
//        NSLog(@"重新进入APP：%@", notification);
    }
}

#pragma mark - Tools

// 计算缩略图尺寸
- (CGFloat)calculateThumbnailSize {
    return ([UIScreen mainScreen].bounds.size.width - (_lineNumber + 1) * 10)/_lineNumber;
}

@end
