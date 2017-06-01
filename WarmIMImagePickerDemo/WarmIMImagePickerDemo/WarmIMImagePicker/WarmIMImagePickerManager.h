//
//  WarmIMImagePickerManager.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/4/28.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WarmIMImagePickerFetchResults.h"

//#define WarmIMWeakSelf typeof(self) __weak WeakSelf = self;
#define WarmIMWeak(type)  __weak typeof(type) Weak##type = type;
#define WarmIMStrong(type)  __strong typeof(type) Strong##type = Weak##type;

#define WarmIMWeakSelf __weak typeof(self) WeakSelf = self;
#define WarmIMStrongSelf __strong typeof(WeakSelf) StrongSelf = WeakSelf;

#pragma mark - Enum
// 图像选择类型
typedef NS_ENUM(NSInteger, WarmIMImagePickerType) {
    WarmIMImagePickerTypeAll    = 0, // 可以选择图片或视频
    WarmIMImagePickerTypeImages = 1, // 只选择图片
    WarmIMImagePickerTypeVideo  = 2  // 只选择视频
};

// Live图片展示类型
typedef NS_ENUM(NSInteger, WarmIMImagePickerLivePhotoLevel) {
    WarmIMImagePickerLivePhotoLevelTranslate     = 0, // 将Live图片作为普通图片显示
//    WarmIMImagePickerLivePhotoLevelDisable       = 1, // 不显示Live图片
    WarmIMImagePickerLivePhotoLevelNormal        = 2, // Live图片正常显示，也可以选择
//    WarmIMImagePickerLivePhotoLevelCustomDefault = 3, // Live图片正常显示，让使用者自己决定是否选中Live，默认不选中Live
//    WarmIMImagePickerLivePhotoLevelCustom        = 4  // Live图片正常显示，让使用者自己决定是否选中Live，默认选中Live
};

// 选中图片的标记类型
typedef NS_ENUM(NSInteger, WarmIMImagePickerSelectedType) {
    WarmIMImagePickerSelectedTypeCheckmark = 0, // 对勾
    WarmIMImagePickerSelectedTypeCircle    = 1, // 圆
    WarmIMImagePickerSelectedTypeNumber    = 2  // 数字
};

// 从iCLoud上下载的选项
typedef NS_ENUM(NSInteger, WarmIMImagePickeriCloudDownloadType) {
    WarmIMImagePickeriCloudDownloadTypeNo          = 0, // 不下载任何资源
    WarmIMImagePickeriCloudDownloadTypeAny         = 1, // 自动下载任何资源
//    WarmIMImagePickeriCloudDownloadTypeOnWiFi      = 2, // 只在WiFi环境下自动下载任何资源
    WarmIMImagePickeriCloudDownloadTypeImage       = 3, // 只自动下载图片
//    WarmIMImagePickeriCloudDownloadTypeImageOnWiFi = 4  // 只在WiFi环境下自动下载图片
};

#pragma mark - Delegate
@protocol WarmIMImagePickerManagerDelegate <NSObject>

@optional

- (void)requestPhotoLibraryAuthorizationSuccessed; // 请求相册权限成功
- (void)requestPhotoLibraryAuthorizationFailed:(NSInteger)status; // 请求相册权限失败

// 展示图片选择页面
- (void)WarmIMImagePickerShow;

// 取消展示图片选择页面
- (void)WarmIMImagePickerDismiss;

// 选择了视频
- (void)WarmIMImagePickerSelectedVideo:(PHAsset *)videoAsset;

// 选择了图片
- (void)WarmIMImagePickerSelectedImages:(NSArray<WarmIMImagePickerAssetModel *> *)imageAssets;

// 什么都没选择
- (void)WarmIMImagePickerSelectedNone;

@end




#pragma mark - Interface
@interface WarmIMImagePickerManager : NSObject

+ (instancetype)sharedManager; // 初始化方法

@property (nonatomic, weak) id<WarmIMImagePickerManagerDelegate> delegate;

#pragma mark - 配置
// 下列属性为配置属性，打开相册期间请不要修改下列配置
@property (nonatomic, assign) WarmIMImagePickerType libraryType; // 图片选择的类型，默认为 WarmIMImagePickerTypeAll。【支持】
@property (nonatomic, assign) BOOL jumpAllPicturesView; // 是否直接跳转到所有照片页面，默认为YES。【支持】
@property (nonatomic, assign) BOOL showEmptyAlbum; // 是否显示空的相册，默认为 YES。【支持】
@property (nonatomic, assign) WarmIMImagePickerLivePhotoLevel livePhotoLevel; // Live图片支持的等级，默认为 WarmIMImagePickerLivePhotoLevelTranslate。【支持】
@property (nonatomic, assign) NSInteger imageCountMax; // 图片的最大选择数量，默认为 20。【支持】
@property (nonatomic, assign) NSInteger lineNumber; // 每行图片的数量（1-10），默认为4。【支持】
@property (nonatomic, assign) BOOL allowScrollSelect; // 是否允许滑动选择，默认为 YES。【支持】
@property (nonatomic, assign) BOOL isShowSendSource; // 是否显示发送原图，默认为 YES。【支持】
@property (nonatomic, assign) BOOL isShowTakePhoto; // 是否在相片的最后显示打开摄像头的选项，默认为 NO。【支持】
@property (nonatomic, assign) BOOL showPicturesSequential; // 顺序展示相片，默认为YES。【支持】
@property (nonatomic, assign) BOOL isFollowCustomNavigation; // 是否跟随自定义的Navigation，默认为 YES。【支持】
@property (nonatomic, strong) UIColor *navigationBackgroundColor; // isFollowCustomNavigation为NO时，该设置有效。默认为白色。【支持】
@property (nonatomic, strong) UIColor *navigationTitleColor; // isFollowCustomNavigation为NO时，该设置有效。默认为蓝色。【支持】
@property (nonatomic, assign, getter=isAllowiCloudDownload) WarmIMImagePickeriCloudDownloadType allowiCloudDownload; // 是否允许从iCLoud上下载资源，默认为WarmIMImagePickeriCloudDownloadTypeNo【支持】


#pragma mark - 其他属性
@property (nullable, nonatomic, strong) WarmIMImagePickerFetchResults *currentFetchResult; // 当前正在展示的相簿列表

@property (nullable, nonatomic, strong) WarmIMImagePickerCollectionModel *currentDisplayCollection; // 当前正在展示的相簿

@property (nullable, nonatomic, strong) WarmIMImagePickerAssetModel *currenDisplayModel; // 当前正在展示的模型

@property (nullable, nonatomic, strong) NSMutableArray<WarmIMImagePickerAssetModel *> *selectedImageModels; // 已选择的图片资源。
@property (nullable, nonatomic, strong) WarmIMImagePickerAssetModel *selectedVideoModel; // 已选择的视频资源

@property (nonatomic, assign) NSInteger selectedOriginalImageCount; // 选择了原图的数量





#pragma mark - 方法
// 下面方法为可调用方法，不建议单独使用。
- (void)requestPhotoLibraryAuthorization; // 请求相册权限
- (void)requestPhotoLibraryAuthorization:(void(^__nullable)(void))successedResultBlock;

- (WarmIMImagePickerFetchResults *__nullable)getAllSmartAblum; // 获取所有系统内置相册
- (WarmIMImagePickerFetchResults *__nullable)getAllUserAblum; // 获取所有用户创建相册
- (WarmIMImagePickerFetchResults *__nullable)getAllAblums; // 获取所有相册

- (void)cachingAssets; // 缓存相册缩略图


/**
 请求图库中的图片数据，回调中返回UIImage类型

 @param asset 要请求的资源对象
 @param targetSize 想要的图片大小
 @param contentMode 图片适应给定大小的方式
 @param options 请求图片的其他设置
 @param resultHandler 请求回调
 @return 请求的识别码，可以通过这个识别码取消对应的请求
 */
- (PHImageRequestID)requestImageForAsset:(PHAsset *__nonnull)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(nullable PHImageRequestOptions *)options resultHandler:(void (^__nonnull)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler;

/**
 请求图库中的图片数据，回调中返回NSData类型

 @param asset 要请求的资源对象
 @param options 请求图片的其他设置
 @param resultHandler 请求回调
 @return 请求的识别码，可以通过这个识别码取消对应的请求
 */
- (PHImageRequestID)requestImageDataForAsset:(PHAsset *__nonnull)asset options:(nullable PHImageRequestOptions *)options resultHandler:(void(^__nonnull)(NSData *__nullable imageData, NSString *__nullable dataUTI, UIImageOrientation orientation, NSDictionary *__nullable info))resultHandler;

/**
 请求图库中的LivePhoto，回调中返回PHLivePhoto类型。
 展示LivePhoto请使用PHLivePhotoView。

 @param asset 要请求的资源对象
 @param targetSize 想要的LivePhoto的大小
 @param contentMode LivePhoto适应给定大小的方式
 @param options 请求LivePhoto的其他设置
 @param resultHandler 请求回调
 @return 请求的识别码，可以通过这个识别码取消对应的请求
 */
- (PHImageRequestID)requestLivePhotoForAsset:(PHAsset *__nonnull)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(nullable PHLivePhotoRequestOptions *)options resultHandler:(void (^__nonnull)(PHLivePhoto *__nullable livePhoto, NSDictionary *__nullable info))resultHandler PHOTOS_AVAILABLE_IOS_TVOS(9_1, 10_0);


/**
 请求图片库中的视频，回调中返回AVPlayerItem类型。
 AVPlayerItem类型适合直接播放

 @param asset 要请求的资源对象
 @param options 请求视频的其他设置
 @param resultHandler 请求回调
 @return 请求的识别码，可以通过这个识别码取消对应的请求
 */
- (PHImageRequestID)requestPlayerItemForVideo:(PHAsset *__nonnull)asset options:(nullable PHVideoRequestOptions *)options resultHandler:(void (^__nonnull)(AVPlayerItem *__nullable playerItem, NSDictionary *__nullable info))resultHandler;


/**
 请求图片库中的视频，回调中返回AVAssetExportSession类型。
 AVAssetExportSession类型适合导出视频

 @param asset 要请求的资源对象
 @param options 请求视频的其他设置
 @param exportPreset 要导出的资源的导出预设名
 @param resultHandler 请求回调
 @return 请求的识别码，可以通过这个识别码取消对应的请求
 */
- (PHImageRequestID)requestExportSessionForVideo:(PHAsset *__nonnull)asset options:(nullable PHVideoRequestOptions *)options exportPreset:(NSString *__nonnull)exportPreset resultHandler:(void (^__nonnull)(AVAssetExportSession *__nullable exportSession, NSDictionary *__nullable info))resultHandler;


/**
 请求图片库中的视频，回调中返回AVAsset类型。
 AVAsset可以获取更多关于视频的信息

 @param asset 要请求的资源对象
 @param options 请求视频的其他设置
 @param resultHandler 请求回调
 @return 请求的识别码，可以通过这个识别码取消对应的请求
 */
- (PHImageRequestID)requestAVAssetForVideo:(PHAsset *__nonnull)asset options:(nullable PHVideoRequestOptions *)options resultHandler:(void (^__nonnull)(AVAsset *__nullable asset, AVAudioMix *__nullable audioMix, NSDictionary *__nullable info))resultHandler;

/**
 取消请求图片／视频

 @param requestID 请求的识别码
 */
- (void)cancelImageRequest:(PHImageRequestID)requestID;

#pragma mark - 即将移除
// !!!!!!!
// 请不要使用下面的接口，原本要再单封装一个单例里面的，最近比较懒，等有时间之后下面接口会被移除。
// FIXME: 移除下面接口
@property (nullable ,nonatomic, strong) PHCachingImageManager *cachingImageManager;

- (CGFloat)calculateThumbnailSize; // 计算缩略图尺寸

- (void)cancelAllSelected; // 清空所有选择

- (void)showPhotoLibrary; // 进入页面的消息传递
- (void)dismissPhotoLibrary; // 退出页面的消息传递

@end
