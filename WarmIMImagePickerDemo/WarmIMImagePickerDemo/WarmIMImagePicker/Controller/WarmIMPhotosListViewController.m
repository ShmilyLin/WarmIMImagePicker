//
//  WarmIMPhotosListViewController.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/4/29.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMPhotosListViewController.h"

#import "WarmIMImagePickerManager.h"
#import "WarmIMHUD.h"

#import "UINavigationController+BackButtonHandler.h"

#import "WarmIMImagePickerCollectionViewImageCell.h"
#import "WarmIMImagePickerCollectionViewVideoCell.h"
#import "WarmIMImagePickerCollectionViewLivePhotoCell.h"
#import "WarmIMImagePickerCollectionBottomView.h"
#import "WarmIMImagePickerCollectionViewCameraCell.h"
#import "WarmIMImagePickerCollectionViewLayout.h"

#import "WarmIMHorizontalPanGestureRecognizer.h"

#import "WarmIMImagePreviewViewController.h"
#import "WarmIMVideoPreviewViewController.h"
#import "WarmIMCameraViewController.h"


typedef NS_ENUM(NSInteger, WarmIMImagePickerScrollSelectType) {
    WarmIMImagePickerScrollSelectTypeNotScroll = 0, // 还没有开始滑动
    WarmIMImagePickerScrollSelectTypeNone      = 1, // 不选
    WarmIMImagePickerScrollSelectTypeSelect    = 2, // 选
    WarmIMImagePickerScrollSelectTypeDeselect  = 3  // 取消选择
};

@interface WarmIMPhotosListViewController ()
<UICollectionViewDataSource,
WarmIMImagePickerCollectionViewLayoutDelegate,
WarmIMImagePickerCollectionBottomViewDelegate,
WarmIMImagePickerCollectionViewImageCellDelegate,
WarmIMImagePickerCollectionViewLivePhotoCellDelegate,
UIViewControllerPreviewingDelegate,
WarmIMImagePreviewViewControllerDelegate,
WarmIMNavigationControllerBackHanderDelegate> {
    NSInteger isScrollBottom;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) WarmIMImagePickerCollectionBottomView *bottomView; // 底部视图

@property (nonatomic, strong) dispatch_queue_t assetDataQueue; // 数据处理线程

@property (nonatomic, assign) WarmIMImagePickerScrollSelectType scrollSelectType; // 滑动选择类型
@property (nonatomic, assign) CGPoint scrollSelectStartPoint; // 滑动选择的初始点
@property (nonatomic, strong) NSIndexPath *scrollSelectStartIndex; // 滑动选择的初始点
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *scrollSelectedIndexs; // 滑动选择的项的索引集合
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *scrollDeselectedIndexs; // 滑动取消选择的索引集合

@end

@implementation WarmIMPhotosListViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isScrollBottom = 0;
    _scrollSelectType = WarmIMImagePickerScrollSelectTypeNotScroll;
    _scrollSelectedIndexs = [NSMutableArray array];
    _scrollDeselectedIndexs = [NSMutableArray array];
    
    if ([WarmIMImagePickerManager sharedManager].currentDisplayCollection.collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary && [[[WarmIMGlobal sharedGlobal] getLocalized] isEqual:@"zh-Hans"]) {
        self.title = @"所有照片";
    }else {
        self.title = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.collection.localizedTitle;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubViews];
    [[WarmIMHUD sharedHUD] showWarmIMHUD:0];
    WarmIMWeakSelf;
    self.assetDataQueue = dispatch_queue_create("AssetCollectionsDataQueue", NULL);
    dispatch_async(self.assetDataQueue, ^{
        [[WarmIMImagePickerManager sharedManager] cachingAssets];
        dispatch_async(dispatch_get_main_queue(), ^{
            [WeakSelf.collectionView reloadData];
            [[WarmIMHUD sharedHUD] dismissWarmIMHUDWithAnimated:NO];
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"WarmIMPhotosListViewController 页面收到内存警告");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([WarmIMImagePickerManager sharedManager].allowScrollSelect) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (isScrollBottom < 3 && [WarmIMImagePickerManager sharedManager].showPicturesSequential) {
        if (_collectionView.contentSize.height > _collectionView.bounds.size.height) {
            [_collectionView setContentOffset:CGPointMake(0, _collectionView.contentSize.height - _collectionView.bounds.size.height) animated:NO];
        }
        isScrollBottom++;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([WarmIMImagePickerManager sharedManager].allowScrollSelect) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (void)dealloc {
    NSLog(@"WarmIMPhotosListViewController dealoc");
}
#pragma mark - UI
- (void)setupSubViews {
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:[[WarmIMGlobal sharedGlobal] showText:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    if (!_collectionView) {
        WarmIMImagePickerCollectionViewLayout *tempCollectionViewLayout = [[WarmIMImagePickerCollectionViewLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:tempCollectionViewLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        _collectionView.allowsMultipleSelection = YES;
        [_collectionView registerClass:[WarmIMImagePickerCollectionViewImageCell class] forCellWithReuseIdentifier:@"WarmIMImagePickerCollectionViewImageCell"];
        [_collectionView registerClass:[WarmIMImagePickerCollectionViewVideoCell class] forCellWithReuseIdentifier:@"WarmIMImagePickerCollectionViewVideoCell"];
        if ([WarmIMImagePickerManager sharedManager].isShowTakePhoto) {
            [_collectionView registerClass:[WarmIMImagePickerCollectionViewCameraCell class] forCellWithReuseIdentifier:@"WarmIMImagePickerCollectionViewCameraCell"];
        }
        if ([WarmIMImagePickerManager sharedManager].livePhotoLevel == WarmIMImagePickerLivePhotoLevelNormal) {
            [_collectionView registerClass:[WarmIMImagePickerCollectionViewLivePhotoCell class] forCellWithReuseIdentifier:@"WarmIMImagePickerCollectionViewLivePhotoCell"];
        }
        [self.view addSubview:_collectionView];
    }
    if (!_bottomView) {
        _bottomView = [[WarmIMImagePickerCollectionBottomView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomView.delegate = self;
        [self.view addSubview:_bottomView];
    }
    
    [self setupSubViewConstraints];
    
    // 设置手势
    if ([WarmIMImagePickerManager sharedManager].allowScrollSelect) {
        WarmIMHorizontalPanGestureRecognizer *tempPanGesture = [[WarmIMHorizontalPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureEvent:)];
        [self.collectionView addGestureRecognizer:tempPanGesture];
    }
    
}


- (void)setupSubViewConstraints {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
}

- (void)reloadBottomView {
    if ([WarmIMImagePickerManager sharedManager].isShowSendSource) {
        if ([WarmIMImagePickerManager sharedManager].selectedOriginalImageCount < 1) {
            _bottomView.originalButton.selected = NO;
        }else {
            _bottomView.originalButton.selected = YES;
        }
    }
    if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count < 1) {
        _bottomView.determineButton.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        _bottomView.determineButton.enabled = NO;
        _bottomView.previewButton.enabled = NO;
        _bottomView.determineButton.selected = NO;
        if ([WarmIMImagePickerManager sharedManager].isShowSendSource) {
            _bottomView.originalButton.enabled = NO;
        }
//        [_bottomView.determineButton setTitle:[[WarmIMGlobal sharedGlobal]showText:@"OK"] forState:UIControlStateNormal];
    }else {
        if (_bottomView.determineButton.isEnabled == NO) {
            _bottomView.determineButton.backgroundColor = [UIColor colorWithRed:142/255.0 green:86/255.0 blue:246/255.0 alpha:1.0];
            _bottomView.determineButton.enabled = YES;
            _bottomView.determineButton.selected = YES;
            _bottomView.previewButton.enabled = YES;
            if ([WarmIMImagePickerManager sharedManager].isShowSendSource) {
                _bottomView.originalButton.enabled = YES;
            }
        }
        NSString *tempTitle = [NSString stringWithFormat:@"%@(%lu)", [[WarmIMGlobal sharedGlobal]showText:@"OK"], (unsigned long)[WarmIMImagePickerManager sharedManager].selectedImageModels.count];
        [_bottomView.determineButton setTitle:tempTitle forState:UIControlStateSelected];
    }
    
}

#pragma mark - functions
// 点击CollectionViewCell处理
- (void)collectionViewCellClicked:(WarmIMImagePickerAssetModel *)model indexPath:(NSIndexPath *)indexPath {
    if (model.asset.mediaType == PHAssetMediaTypeVideo) {
        if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count > 0) {
            [[WarmIMHUD sharedHUD]showWarmIMTitleHUD:@"不可以同时选择图片和视频" imageName:@"WarmIM_error_tip" timeInterval:1.0];
        }else {
            // 预览视频
            if (model.isIniCloud && model.isDownloading) {
                [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"正在从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                return;
            }
            if (model.iniCloud && [WarmIMImagePickerManager sharedManager].isAllowiCloudDownload != WarmIMImagePickeriCloudDownloadTypeAny) {
                [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"该资源尚未从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                return;
            }
            if (!model.isIniCloud && model.isDownload) {
                [WarmIMImagePickerManager sharedManager].currenDisplayModel = model;
                WarmIMVideoPreviewViewController *tempVideoVC = [[WarmIMVideoPreviewViewController alloc]init];
                [self.navigationController pushViewController:tempVideoVC animated:YES];
                return;
            }
            WarmIMWeak(model)
            WarmIMWeakSelf
            if (model.requestID) {
                if (model.downloadRequestID) {
                    return;
                }
                [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:model.requestID];
            }
            model.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestPlayerItemForVideo:model.asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
                if ([info objectForKey:@"PHImageFileSandboxExtensionTokenKey"]) { // 视频不在iCloud上
                    dispatch_async(dispatch_get_main_queue(), ^{
                        Weakmodel.isDownload = YES;
                        [WarmIMImagePickerManager sharedManager].currenDisplayModel = Weakmodel;
                        WarmIMVideoPreviewViewController *tempVideoVC = [[WarmIMVideoPreviewViewController alloc]init];
                        [WeakSelf.navigationController pushViewController:tempVideoVC animated:YES];
                    });
                }else { // 视频在iCloud上
                    dispatch_async(dispatch_get_main_queue(), ^{
                        Weakmodel.iniCloud = YES;
                        if ([WarmIMImagePickerManager sharedManager].isAllowiCloudDownload == WarmIMImagePickeriCloudDownloadTypeAny) {
                            Weakmodel.isDownloading = YES;
                            [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"正在从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                            PHVideoRequestOptions *tempVideoRequestOptions = [[PHVideoRequestOptions alloc]init];
                            tempVideoRequestOptions.networkAccessAllowed = YES;
                            if (Weakmodel.requestID) {
                                if (Weakmodel.downloadRequestID) {
                                    return;
                                }
                                [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:Weakmodel.requestID];
                            }
                            Weakmodel.downloadRequestID = YES;
                            Weakmodel.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestPlayerItemForVideo:Weakmodel.asset options:tempVideoRequestOptions resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
                                if ([info objectForKey:@"PHImageFileSandboxExtensionTokenKey"]) {
                                    Weakmodel.iniCloud = NO;
                                    Weakmodel.isDownloading = NO;
                                    Weakmodel.isDownload = YES;
                                    Weakmodel.downloadRequestID = NO;
                                }
                            }];
                        }else {
                            [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"该资源尚未从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                        }
                    });
                }
            }];
        }
    }else {
        if (model.iniCloud && model.isDownloading) {
            [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"正在从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
            return;
        }
        if (model.iniCloud && [WarmIMImagePickerManager sharedManager].isAllowiCloudDownload == WarmIMImagePickeriCloudDownloadTypeNo) {
            [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"该资源尚未从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
            return;
        }
        if (!model.iniCloud && model.isDownload) {
            [WarmIMImagePickerManager sharedManager].currenDisplayModel = model;
            WarmIMImagePreviewViewController *tempPreviewVC = [[WarmIMImagePreviewViewController alloc]init];
            tempPreviewVC.currentIndex = indexPath.row;
            tempPreviewVC.delegate = self;
            UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationItem setBackBarButtonItem:backButtonItem];
            [self.navigationController pushViewController:tempPreviewVC animated:YES];
            return;
        }
        // 预览所有图片
        WarmIMWeak(model)
        WarmIMWeak(indexPath)
        WarmIMWeakSelf
        
        if ([WarmIMImagePickerManager sharedManager].livePhotoLevel == WarmIMImagePickerLivePhotoLevelNormal) {
            if (model.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                if (model.requestID) {
                    if (model.downloadRequestID) {
                        return;
                    }
                    [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:model.requestID];
                }
                model.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestLivePhotoForAsset:model.asset targetSize:CGSizeMake(model.asset.pixelWidth, model.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
                    if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) { // 原始图片
                        if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) { // 在iCloud上
                            Weakmodel.iniCloud = YES;
                            if ([WarmIMImagePickerManager sharedManager].isAllowiCloudDownload != WarmIMImagePickeriCloudDownloadTypeNo) {
                                Weakmodel.isDownloading = YES;
                                [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"正在从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                                PHLivePhotoRequestOptions *tempLiveRequestOptions = [[PHLivePhotoRequestOptions alloc]init];
                                tempLiveRequestOptions.networkAccessAllowed = YES;
                                if (Weakmodel.requestID) {
                                    if (Weakmodel.downloadRequestID) {
                                        return;
                                    }
                                    [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:Weakmodel.requestID];
                                }
                                Weakmodel.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestLivePhotoForAsset:Weakmodel.asset targetSize:CGSizeMake(Weakmodel.asset.pixelWidth, Weakmodel.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:tempLiveRequestOptions resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable downloadInfo) {
                                    if (![[downloadInfo objectForKey:PHImageResultIsDegradedKey] boolValue] && ![[downloadInfo objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                                        Weakmodel.iniCloud = NO;
                                        Weakmodel.isDownload = YES;
                                        Weakmodel.isDownloading = NO;
                                        Weakmodel.downloadRequestID = NO;
                                    }
                                }];
                            }else {
                                Weakmodel.isDownload = NO;
                                Weakmodel.isDownloading = NO;
                                [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"该资源尚未从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                            }
                        }else { // 不在iCloud上
                            Weakmodel.iniCloud = NO;
                            Weakmodel.isDownloading = NO;
                            Weakmodel.isDownload = YES;
                            [WarmIMImagePickerManager sharedManager].currenDisplayModel = Weakmodel;
                            WarmIMImagePreviewViewController *tempPreviewVC = [[WarmIMImagePreviewViewController alloc]init];
                            tempPreviewVC.currentIndex = WeakindexPath.row;
                            tempPreviewVC.delegate = WeakSelf;
                            UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                            [WeakSelf.navigationItem setBackBarButtonItem:backButtonItem];
                            [WeakSelf.navigationController pushViewController:tempPreviewVC animated:YES];
                        }
                    }
                }];
                return;
            }
        }
        if (model.requestID) {
            if (model.downloadRequestID) {
                return;
            }
            [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:model.requestID];
        }
        
        model.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestImageForAsset:model.asset targetSize:CGSizeMake(model.asset.pixelWidth, model.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) { // 原始图片
                if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) { // 在iCloud上
                    Weakmodel.iniCloud = YES;
                    if ([WarmIMImagePickerManager sharedManager].isAllowiCloudDownload != WarmIMImagePickeriCloudDownloadTypeNo) {
                        Weakmodel.isDownloading = YES;
                        [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"正在从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                        PHImageRequestOptions *tempRequestOptions = [[PHImageRequestOptions alloc]init];
                        tempRequestOptions.networkAccessAllowed = YES;
                        if (Weakmodel.requestID) {
                            if (Weakmodel.downloadRequestID) {
                                return;
                            }
                            [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:model.requestID];
                        }
                        Weakmodel.downloadRequestID = YES;
                        Weakmodel.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestImageForAsset:Weakmodel.asset targetSize:CGSizeMake(Weakmodel.asset.pixelWidth, Weakmodel.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:tempRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable downloadInfo) {
                            if (![[downloadInfo objectForKey:PHImageResultIsDegradedKey] boolValue] && ![[downloadInfo objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                                Weakmodel.iniCloud = NO;
                                Weakmodel.isDownload = YES;
                                Weakmodel.isDownloading = NO;
                                Weakmodel.downloadRequestID = NO;
                            }
                        }];
                    }else {
                        Weakmodel.isDownload = NO;
                        Weakmodel.isDownloading = NO;
                        [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"该资源尚未从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                    }
                }else { // 不在iCloud上
                    Weakmodel.iniCloud = NO;
                    Weakmodel.isDownloading = NO;
                    Weakmodel.isDownload = YES;
                    [WarmIMImagePickerManager sharedManager].currenDisplayModel = Weakmodel;
                    WarmIMImagePreviewViewController *tempPreviewVC = [[WarmIMImagePreviewViewController alloc]init];
                    tempPreviewVC.currentIndex = WeakindexPath.row;
                    tempPreviewVC.delegate = WeakSelf;
                    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                    [WeakSelf.navigationItem setBackBarButtonItem:backButtonItem];
                    [WeakSelf.navigationController pushViewController:tempPreviewVC animated:YES];
                }
            }
        }];
    }
}



// 选择图片
- (void)selectedImageWithModel:(WarmIMImagePickerAssetModel *)model withCell:(__kindof UICollectionViewCell *)imageCell indexPath:(NSIndexPath *)indexPath {
    
    if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count >= [WarmIMImagePickerManager sharedManager].imageCountMax) { // 超出可选择数量过
        NSString *tempTipString = [NSString stringWithFormat:@"图片最多可以选择%ld张", (long)[WarmIMImagePickerManager sharedManager].imageCountMax];
        [[WarmIMHUD sharedHUD]showWarmIMTitleHUD:tempTipString imageName:@"WarmIM_error_tip" timeInterval:1.0];
    }else { // 小于可选择数量
        if (!model) {
            if ([WarmIMImagePickerManager sharedManager].showPicturesSequential) {
                model = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[indexPath.row];
            }else {
                model = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[[WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels.count - indexPath.row - 1];
            }
        }
        if (model.iniCloud && model.isDownloading) {
            [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"正在从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
            return;
        }
        if (model.iniCloud && [WarmIMImagePickerManager sharedManager].isAllowiCloudDownload == WarmIMImagePickeriCloudDownloadTypeNo) {
            [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"该资源尚未从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
            return;
        }
        if (!imageCell) {
            if (model.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                imageCell = (WarmIMImagePickerCollectionViewLivePhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            }else {
                imageCell = (WarmIMImagePickerCollectionViewImageCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            }
        }
        WarmIMWeak(model)
        WarmIMWeak(imageCell)
        WarmIMWeakSelf
        
        if (!model.iniCloud && model.isDownload) { // 本地
            if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count < [WarmIMImagePickerManager sharedManager].imageCountMax && !model.selected) { // 小于可选择数量
                model.selected = YES;
                if ([imageCell isKindOfClass:[WarmIMImagePickerCollectionViewImageCell class]]) {
                    ((WarmIMImagePickerCollectionViewImageCell *)imageCell).selectButton.selected = YES;
                    [((WarmIMImagePickerCollectionViewImageCell *)imageCell) showSelectedView];
                }else {
                    ((WarmIMImagePickerCollectionViewLivePhotoCell *)imageCell).selectButton.selected = YES;
                    if (model.requestID) {
                        if (model.downloadRequestID) {
                            return;
                        }
                        [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:model.requestID];
                    }
                    model.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestLivePhotoForAsset:model.asset targetSize:CGSizeMake([[WarmIMImagePickerManager sharedManager] calculateThumbnailSize], [[WarmIMImagePickerManager sharedManager] calculateThumbnailSize]) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
                        if (livePhoto) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
                                [((WarmIMImagePickerCollectionViewLivePhotoCell *)WeakimageCell) setLivePhoto:livePhoto];
//                            });
                        }
                    }];
                    [((WarmIMImagePickerCollectionViewLivePhotoCell *)imageCell) showSelectedView];
                }
                [[WarmIMImagePickerManager sharedManager].selectedImageModels addObject:model];
                [self reloadBottomView];
            }
            return;
        }
        
        
        if ([WarmIMImagePickerManager sharedManager].livePhotoLevel == WarmIMImagePickerLivePhotoLevelNormal) {
            if (model.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                if (model.requestID) {
                    if (model.downloadRequestID) {
                        return;
                    }
                    [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:model.requestID];
                }
                model.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestLivePhotoForAsset:model.asset targetSize:CGSizeMake(model.asset.pixelWidth, model.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) { // 原始图片
                            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) { // 在iCloud上
                                Weakmodel.iniCloud = YES;
                                if ([WarmIMImagePickerManager sharedManager].isAllowiCloudDownload != WarmIMImagePickeriCloudDownloadTypeNo) {
                                    Weakmodel.isDownloading = YES;
                                    [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"正在从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                                    PHLivePhotoRequestOptions *tempLiveRequestOptions = [[PHLivePhotoRequestOptions alloc]init];
                                    tempLiveRequestOptions.networkAccessAllowed = YES;
                                    if (Weakmodel.requestID) {
                                        if (Weakmodel.downloadRequestID) {
                                            return;
                                        }
                                        [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:Weakmodel.requestID];
                                    }
                                    Weakmodel.downloadRequestID = YES;
                                    Weakmodel.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestLivePhotoForAsset:Weakmodel.asset targetSize:CGSizeMake(Weakmodel.asset.pixelWidth, Weakmodel.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:tempLiveRequestOptions resultHandler:^(PHLivePhoto * _Nullable result, NSDictionary * _Nullable downloadInfo) {
                                        if (![[downloadInfo objectForKey:PHImageResultIsDegradedKey] boolValue] && ![[downloadInfo objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                Weakmodel.iniCloud = NO;
                                                Weakmodel.isDownload = YES;
                                                Weakmodel.isDownloading = NO;
                                                Weakmodel.downloadRequestID = NO;
                                            });
                                        }
                                    }];
                                }else {
                                    Weakmodel.isDownload = NO;
                                    Weakmodel.isDownloading = NO;
                                    [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"该资源尚未从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                                }
                            }else { // 不在iCloud上
                                Weakmodel.iniCloud = NO;
                                Weakmodel.isDownloading = NO;
                                Weakmodel.isDownload = YES;
                                if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count < [WarmIMImagePickerManager sharedManager].imageCountMax && !Weakmodel.selected) { // 小于可选择数量
                                    Weakmodel.selected = YES;
                                    ((WarmIMImagePickerCollectionViewLivePhotoCell *)WeakimageCell).selectButton.selected = YES;
                                    [((WarmIMImagePickerCollectionViewLivePhotoCell *)WeakimageCell) setLivePhoto:livePhoto];
                                    [((WarmIMImagePickerCollectionViewLivePhotoCell *)WeakimageCell) showSelectedView];
                                    [[WarmIMImagePickerManager sharedManager].selectedImageModels addObject:Weakmodel];
                                    [WeakSelf reloadBottomView];
                                }
                            }
                        }
                    });
                }];
                return;
            }
        }
        if (model.requestID) {
            if (model.downloadRequestID) {
                return;
            }
            [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:model.requestID];
        }
        model.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestImageForAsset:model.asset targetSize:CGSizeMake(model.asset.pixelWidth, model.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) { // 原始图片
                    if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) { // 在iCloud上
                        Weakmodel.iniCloud = YES;
                        if ([WarmIMImagePickerManager sharedManager].isAllowiCloudDownload != WarmIMImagePickeriCloudDownloadTypeNo) {
                            Weakmodel.isDownloading = YES;
                            [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"正在从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                            PHImageRequestOptions *tempRequestOptions = [[PHImageRequestOptions alloc]init];
                            tempRequestOptions.networkAccessAllowed = YES;
                            if (Weakmodel.requestID) {
                                if (Weakmodel.downloadRequestID) {
                                    return;
                                }
                                [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:Weakmodel.requestID];
                            }
                            Weakmodel.downloadRequestID = YES;
                            Weakmodel.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestImageForAsset:Weakmodel.asset targetSize:CGSizeMake(Weakmodel.asset.pixelWidth, Weakmodel.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:tempRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable downloadInfo) {
                                if (![[downloadInfo objectForKey:PHImageResultIsDegradedKey] boolValue] && ![[downloadInfo objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                                    Weakmodel.iniCloud = NO;
                                    Weakmodel.isDownload = YES;
                                    Weakmodel.isDownloading = NO;
                                    Weakmodel.downloadRequestID = NO;
                                }
                            }];
                        }else {
                            Weakmodel.isDownload = NO;
                            Weakmodel.isDownloading = NO;
                            [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"该资源尚未从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                        }
                    }else { // 不在iCloud上
                        Weakmodel.iniCloud = NO;
                        Weakmodel.isDownloading = NO;
                        Weakmodel.isDownload = YES;
                        if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count < [WarmIMImagePickerManager sharedManager].imageCountMax && !Weakmodel.selected) { // 小于可选择数量
                            Weakmodel.selected = YES;
                            if ([WeakimageCell isKindOfClass:[WarmIMImagePickerCollectionViewImageCell class]]) {
                                ((WarmIMImagePickerCollectionViewImageCell *)WeakimageCell).selectButton.selected = YES;
                                [((WarmIMImagePickerCollectionViewImageCell *)WeakimageCell) showSelectedView];
                            }else {
                                ((WarmIMImagePickerCollectionViewLivePhotoCell *)WeakimageCell).selectButton.selected = YES;
                                if (Weakmodel.requestID) {
                                    if (Weakmodel.downloadRequestID) {
                                        return;
                                    }
                                    [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:Weakmodel.requestID];
                                }
                                Weakmodel.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestLivePhotoForAsset:Weakmodel.asset targetSize:CGSizeMake([[WarmIMImagePickerManager sharedManager] calculateThumbnailSize], [[WarmIMImagePickerManager sharedManager] calculateThumbnailSize]) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
                                    if (livePhoto) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [((WarmIMImagePickerCollectionViewLivePhotoCell *)WeakimageCell) setLivePhoto:livePhoto];
                                        });
                                    }
                                }];
                                [((WarmIMImagePickerCollectionViewLivePhotoCell *)WeakimageCell) showSelectedView];
                            }
                            [[WarmIMImagePickerManager sharedManager].selectedImageModels addObject:Weakmodel];
                            [WeakSelf reloadBottomView];
                        }
                    }
                }
            });
        }];
    }
}

// 取消选择图片
- (void)deselectedImageWithModel:(WarmIMImagePickerAssetModel *)model withCell:(__kindof UICollectionViewCell *)imageCell indexPath:(NSIndexPath *)indexPath {
    if (!model) {
        if ([WarmIMImagePickerManager sharedManager].showPicturesSequential) {
            model = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[indexPath.row];
        }else {
            model = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[[WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels.count - indexPath.row - 1];
        }
    }
    [[WarmIMImagePickerManager sharedManager].selectedImageModels removeObject:model];
    model.selected = NO;
    if (!imageCell) {
        if (model.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
            imageCell = (WarmIMImagePickerCollectionViewLivePhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        }else {
            imageCell = (WarmIMImagePickerCollectionViewImageCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        }
    }
    if ([imageCell isKindOfClass:[WarmIMImagePickerCollectionViewImageCell class]]) {
        ((WarmIMImagePickerCollectionViewImageCell *)imageCell).selectButton.selected = NO;
        [((WarmIMImagePickerCollectionViewImageCell *)imageCell) dismissSelectedView];
    }else {
        ((WarmIMImagePickerCollectionViewLivePhotoCell *)imageCell).selectButton.selected = NO;
        [((WarmIMImagePickerCollectionViewLivePhotoCell *)imageCell) dismissSelectedView];
    }
    
    if (model.isSelectedOriginalImage) {
        model.isSelectedOriginalImage = NO;
        [WarmIMImagePickerManager sharedManager].selectedOriginalImageCount--;
    }
    [self reloadBottomView];
}

- (WarmIMImagePickerAssetModel *)getModelWithIndexPath:(NSIndexPath *)indexPath {
    if ([WarmIMImagePickerManager sharedManager].showPicturesSequential) { // 顺序
        if ([WarmIMImagePickerManager sharedManager].isShowTakePhoto) { // 展示相机
            if (indexPath.section == 1) { // 相机Cell
                _scrollSelectType = WarmIMImagePickerScrollSelectTypeNone;
                [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"相机不可以被选择。" imageName:@"WarmIM_error_tip" timeInterval:1.0];
                return nil;
            }
        }
        // 没展示相机或者当前不是相机Cell
        return [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[indexPath.row];
    }else { // 倒叙
        if ([WarmIMImagePickerManager sharedManager].isShowTakePhoto) { // 展示相机
            if (indexPath.section == 0) { // 相机Cell
                _scrollSelectType = WarmIMImagePickerScrollSelectTypeNone;
                [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"相机不可以被选择。" imageName:@"WarmIM_error_tip" timeInterval:1.0];
                return nil;
            }
        }
        return [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[[WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels.count - indexPath.row - 1];
    }
}


// 滑动选择的遍历处理
- (void)scrollSelectedHandleWithStartIndexPath:(NSIndexPath *)startIndexPath endIndexPath:(NSIndexPath *)endIndexPath isSelected:(BOOL)isSelected {
    NSMutableArray *tempArray = [NSMutableArray array];
    if (startIndexPath.row < endIndexPath.row) {
        for (long i = startIndexPath.row; i<=endIndexPath.row;i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:startIndexPath.section];
            WarmIMImagePickerAssetModel *tempModel;
            if ([WarmIMImagePickerManager sharedManager].showPicturesSequential) {
                tempModel = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[i];
            }else {
                tempModel = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[[WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels.count - i - 1];
            }
            if (tempModel.asset.mediaType != PHAssetMediaTypeVideo) { // 图片
                if (tempModel.selected != isSelected) {
                    [tempArray addObject:indexPath];
                    if (isSelected) {
                        [self selectedImageWithModel:tempModel withCell:nil indexPath:indexPath];
                    }else {
                        [self deselectedImageWithModel:tempModel withCell:nil indexPath:indexPath];
                    }
                }else {
                    if (isSelected) {
                        for (int j=0;j<_scrollSelectedIndexs.count;j++) {
                            NSIndexPath *tempIndexPath = _scrollSelectedIndexs[j];
                            if (tempIndexPath.row == i) {
                                [tempArray addObject:tempIndexPath];
                                [_scrollSelectedIndexs removeObject:tempIndexPath];
                                break;
                            }
                        }
                    }else {
                        for (int j=0;j<_scrollDeselectedIndexs.count;j++) {
                            NSIndexPath *tempIndexPath = _scrollDeselectedIndexs[j];
                            if (tempIndexPath.row == i) {
                                [tempArray addObject:tempIndexPath];
                                [_scrollDeselectedIndexs removeObject:tempIndexPath];
                                break;
                            }
                        }
                    }
                }
            }
        }
    }else {
        for (long i = startIndexPath.row; i>=endIndexPath.row;i--) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:startIndexPath.section];
            WarmIMImagePickerAssetModel *tempModel;
            if ([WarmIMImagePickerManager sharedManager].showPicturesSequential) {
                tempModel = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[i];
            }else {
                tempModel = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[[WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels.count - i - 1];
            }
            if (tempModel.asset.mediaType != PHAssetMediaTypeVideo) { // 图片
                if (tempModel.selected != isSelected) {
                    [tempArray addObject:indexPath];
                    if (isSelected) {
                        [self selectedImageWithModel:tempModel withCell:nil indexPath:indexPath];
                    }else {
                        [self deselectedImageWithModel:tempModel withCell:nil indexPath:indexPath];
                    }
                }else {
                    if (isSelected) {
                        for (int j=0;j<_scrollSelectedIndexs.count;j++) {
                            NSIndexPath *tempIndexPath = _scrollSelectedIndexs[j];
                            if (tempIndexPath.row == i) {
                                [tempArray addObject:tempIndexPath];
                                [_scrollSelectedIndexs removeObject:tempIndexPath];
                                break;
                            }
                        }
                    }else {
                        for (int j=0;j<_scrollDeselectedIndexs.count;j++) {
                            NSIndexPath *tempIndexPath = _scrollDeselectedIndexs[j];
                            if (tempIndexPath.row == i) {
                                [tempArray addObject:tempIndexPath];
                                [_scrollDeselectedIndexs removeObject:tempIndexPath];
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    if (isSelected) {
        if (_scrollSelectedIndexs.count > 0) {
            for (int m = 0; m<_scrollSelectedIndexs.count;m++) {
                [self deselectedImageWithModel:nil withCell:nil indexPath:_scrollSelectedIndexs[m]];
            }
        }
        _scrollSelectedIndexs = tempArray;
    }else {
        if (_scrollDeselectedIndexs.count > 0) {
            for (int n = 0; n<_scrollDeselectedIndexs.count;n++) {
                [self selectedImageWithModel:nil withCell:nil indexPath:_scrollDeselectedIndexs[n]];
            }
        }
        _scrollDeselectedIndexs = tempArray;
    }
}



// 滑动选择到相机上的遍历处理
- (void)scrollSelectedHandleInCameraIsSelected:(BOOL)isSelected {

    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSInteger tempSelectedCount = 0;
    if ([WarmIMImagePickerManager sharedManager].showPicturesSequential) { // 顺序
        tempSelectedCount = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels.count - _scrollSelectStartIndex.row;
    }else { // 倒叙
        tempSelectedCount = _scrollSelectStartIndex.row + 1;
    }
    
    for (long i = 0; i< tempSelectedCount;i++) {
        NSIndexPath *tempScrollIndexPath;
        WarmIMImagePickerAssetModel *tempModel;
        if ([WarmIMImagePickerManager sharedManager].showPicturesSequential) {
            tempScrollIndexPath = [NSIndexPath indexPathForRow:_scrollSelectStartIndex.row + i inSection:0];
            tempModel = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[tempScrollIndexPath.row];
        }else {
            tempScrollIndexPath = [NSIndexPath indexPathForRow:_scrollSelectStartIndex.row - i inSection:1];
            tempModel = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[[WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels.count - tempScrollIndexPath.row - 1];
        }
        
        if (tempModel.asset.mediaType != PHAssetMediaTypeVideo) { // 图片
            if (tempModel.selected != isSelected) {
                [tempArray addObject:tempScrollIndexPath];
                if (isSelected) {
                    [self selectedImageWithModel:tempModel withCell:nil indexPath:tempScrollIndexPath];
                }else {
                    [self deselectedImageWithModel:tempModel withCell:nil indexPath:tempScrollIndexPath];
                }
            }else {
                if (isSelected) {
                    for (int j=0;j<_scrollSelectedIndexs.count;j++) {
                        NSIndexPath *tempIndexPath = _scrollSelectedIndexs[j];
                        if (tempIndexPath.row == tempScrollIndexPath.row) {
                            [tempArray addObject:tempIndexPath];
                            [_scrollSelectedIndexs removeObject:tempIndexPath];
                            break;
                        }
                    }
                }else {
                    for (int j=0;j<_scrollDeselectedIndexs.count;j++) {
                        NSIndexPath *tempIndexPath = _scrollDeselectedIndexs[j];
                        if (tempIndexPath.row == tempScrollIndexPath.row) {
                            [tempArray addObject:tempIndexPath];
                            [_scrollDeselectedIndexs removeObject:tempIndexPath];
                            break;
                        }
                    }
                }
            }
        }else {
            if (isSelected) {
                [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"不可以同时选择图片和视频。" imageName:@"WarmIM_error_tip" timeInterval:1.0];
            }
        }
    }
    if (isSelected) {
        if (_scrollSelectedIndexs.count > 0) {
            for (int m = 0; m<_scrollSelectedIndexs.count;m++) {
                [self deselectedImageWithModel:nil withCell:nil indexPath:_scrollSelectedIndexs[m]];
            }
        }
        _scrollSelectedIndexs = tempArray;
    }else {
        if (_scrollDeselectedIndexs.count > 0) {
            for (int n = 0; n<_scrollDeselectedIndexs.count;n++) {
                [self selectedImageWithModel:nil withCell:nil indexPath:_scrollDeselectedIndexs[n]];
            }
        }
        _scrollDeselectedIndexs = tempArray;
    }
}

// 图片的poper视图大小计算
- (CGSize)getImagePreviewVCPoperSizeWithWidth:(CGFloat)imageWidth height:(CGFloat)imageHeight {
    CGFloat tempScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat tempScreenHeight = [UIScreen mainScreen].bounds.size.height;
    if (imageWidth/imageHeight > tempScreenWidth/tempScreenHeight) { // 宽了
        if (imageWidth > tempScreenWidth) {
            return CGSizeMake(tempScreenWidth, tempScreenWidth*imageHeight/imageWidth);
        }else {
            return CGSizeMake(imageWidth, imageHeight);
        }
    }else if (imageWidth/imageHeight < tempScreenWidth/tempScreenHeight) { // 高了
        if (imageHeight > tempScreenHeight) {
            if (imageHeight/imageWidth - tempScreenHeight/tempScreenWidth > 0.5) { // 特长
                return CGSizeMake(tempScreenWidth, tempScreenHeight);
            }
            return CGSizeMake(tempScreenHeight*imageWidth/imageHeight, tempScreenHeight);
        }else {
            return CGSizeMake(imageWidth, imageHeight);
        }
    }else { // 等于
        if (imageWidth <= tempScreenWidth) {
            return CGSizeMake(imageWidth, imageHeight);
        }else {
            return CGSizeMake(tempScreenWidth, tempScreenHeight);
        }
    }
    
}

#pragma mark - Actions
- (void)rightBarItemClicked:(UIBarButtonItem *)sender {
    if ([[WarmIMImagePickerManager sharedManager].delegate respondsToSelector:@selector(WarmIMImagePickerSelectedNone)]) {
        [[WarmIMImagePickerManager sharedManager].delegate WarmIMImagePickerSelectedNone];
    }
    [[WarmIMImagePickerManager sharedManager] dismissPhotoLibrary];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)panGestureEvent:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        _scrollSelectType = WarmIMImagePickerScrollSelectTypeNotScroll;
        [_scrollSelectedIndexs removeAllObjects];
        [_scrollDeselectedIndexs removeAllObjects];
        return;
    }
    if (_scrollSelectType != WarmIMImagePickerScrollSelectTypeNone) {
        // 当前坐标
        CGPoint locationPoint = [gesture locationInView:gesture.view];
        // 获取当前的索引值
        NSIndexPath *tempIndexPath = [_collectionView indexPathForItemAtPoint:locationPoint];
        if (tempIndexPath != nil) { // 不为空，即不在两个cell之间
            switch (_scrollSelectType) {
                case WarmIMImagePickerScrollSelectTypeNotScroll: { // 还没开始
                    _scrollSelectStartPoint = locationPoint; // 记录开始点
                    _scrollSelectStartIndex = tempIndexPath; // 记录开始索引
                    WarmIMImagePickerAssetModel *tempAssetModel = [self getModelWithIndexPath:tempIndexPath];
                    if (tempAssetModel) {
                        if (tempAssetModel.asset.mediaType == PHAssetMediaTypeVideo) { // 视频资源
                            if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count > 0) { // 已选择图片
                                _scrollSelectType = WarmIMImagePickerScrollSelectTypeNone;
                                [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"不可以同时选择图片和视频。" imageName:@"WarmIM_error_tip" timeInterval:1.0];
                            }else { // 什么都还没有选择
                                // TODO:取消手势，预览视频
                                _scrollSelectType = WarmIMImagePickerScrollSelectTypeNone;
                                
                                return;
                            }
                        }else { // 图片资源
                            // 获取Cell
                            WarmIMImagePickerCollectionViewImageCell *tempImageCell = (WarmIMImagePickerCollectionViewImageCell *)[_collectionView cellForItemAtIndexPath:tempIndexPath];
                            if (tempAssetModel.selected) { // 当前的资源是选中的资源
                                _scrollSelectType = WarmIMImagePickerScrollSelectTypeDeselect;
                                [_scrollDeselectedIndexs addObject:tempIndexPath];
                                [self deselectedImageWithModel:tempAssetModel withCell:tempImageCell indexPath:tempIndexPath];
                            }else { // 当前资源并未被选中
                                if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count >= [WarmIMImagePickerManager sharedManager].imageCountMax) { // 超出可选数量
                                    _scrollSelectType = WarmIMImagePickerScrollSelectTypeNone;
                                }else { // 没有超出可选数量
                                    _scrollSelectType = WarmIMImagePickerScrollSelectTypeSelect;
                                    [_scrollSelectedIndexs addObject:tempIndexPath];
                                }
                                [self selectedImageWithModel:tempAssetModel withCell:tempImageCell indexPath:tempIndexPath];
                            }
                        }
                    }else {
                        return;
                    }
                }
                    break;
                case WarmIMImagePickerScrollSelectTypeSelect: { // 选择模式
                    if ([WarmIMImagePickerManager sharedManager].showPicturesSequential) { // 顺序
                        if ([WarmIMImagePickerManager sharedManager].isShowTakePhoto) { // 展示相机
                            if (tempIndexPath.section == 1) { // 当前手指在相机cell上
                                [self scrollSelectedHandleInCameraIsSelected:YES];
                                return;
                            }
                        }
                    }else { // 倒叙
                        if ([WarmIMImagePickerManager sharedManager].isShowTakePhoto) { // 展示相机
                            if (tempIndexPath.section == 0) { // 当前手指在相机cell上
                                [self scrollSelectedHandleInCameraIsSelected:YES];
                                return;
                            }
                        }
                    }
                    [self scrollSelectedHandleWithStartIndexPath:_scrollSelectStartIndex endIndexPath:tempIndexPath isSelected:YES];
                }
                    break;
                case WarmIMImagePickerScrollSelectTypeDeselect: { //取消选择模式
                    if ([WarmIMImagePickerManager sharedManager].showPicturesSequential) { // 顺序
                        if ([WarmIMImagePickerManager sharedManager].isShowTakePhoto) { // 展示相机
                            if (tempIndexPath.section == 1) { // 当前手指在相机cell上
                                [self scrollSelectedHandleInCameraIsSelected:NO];
                                return;
                            }
                        }
                    }else { // 倒叙
                        if ([WarmIMImagePickerManager sharedManager].isShowTakePhoto) { // 展示相机
                            if (tempIndexPath.section == 0) { // 当前手指在相机cell上
                                [self scrollSelectedHandleInCameraIsSelected:NO];
                                return;
                            }
                        }
                    }
                    [self scrollSelectedHandleWithStartIndexPath:_scrollSelectStartIndex endIndexPath:tempIndexPath isSelected:NO];
                    
                }
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark - WarmIMImagePickerCollectionViewLayoutDelegate
// Cell的大小
- (CGSize)sizeForCollectionViewItem:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout {
    return CGSizeMake([[WarmIMImagePickerManager sharedManager] calculateThumbnailSize], [[WarmIMImagePickerManager sharedManager] calculateThumbnailSize]);
}
// Content的偏移量
- (UIEdgeInsets)insetForCollectionViewContent:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
// Section中每行的最小距离
- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout {
    return 10;
}
// 每个Cell之间的距离
- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout {
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([WarmIMImagePickerManager sharedManager].showPicturesSequential) { // 顺序
        if ([WarmIMImagePickerManager sharedManager].isShowTakePhoto) { // 展示相机
            if (indexPath.section == 1) {
                // 点击展示相机
                NSLog(@"点击展示相机");
                WarmIMCameraViewController *tempCameraVC = [[WarmIMCameraViewController alloc]init];
                [self presentViewController:tempCameraVC animated:YES completion:nil];
                return;
            }
        }
        [self collectionViewCellClicked:[WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[indexPath.row] indexPath:indexPath];
    }else { // 倒序
        if ([WarmIMImagePickerManager sharedManager].isShowTakePhoto) { // 展示相机
            if (indexPath.section == 0) {
                // 点击展示相机
                NSLog(@"点击展示相机");
                return;
            }
        }
        // 不展示相机
        [self collectionViewCellClicked:[WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[[WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels.count - indexPath.row - 1] indexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDataSource
// 每个section的item数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([WarmIMImagePickerManager sharedManager].showPicturesSequential) { // 顺序
        if ([WarmIMImagePickerManager sharedManager].isShowTakePhoto)
            if (section == 1)
                return 1;
    }else {
        if ([WarmIMImagePickerManager sharedManager].isShowTakePhoto)
            if (section == 0)
                return 1;
    }
    return [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WarmIMImagePickerAssetModel *tempAssetModel;
    // 获取模型
    if ([WarmIMImagePickerManager sharedManager].showPicturesSequential) { // 顺序
        if ([WarmIMImagePickerManager sharedManager].isShowTakePhoto) {
            if (indexPath.section == 1) {
                WarmIMImagePickerCollectionViewCameraCell *tempCameraCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WarmIMImagePickerCollectionViewCameraCell" forIndexPath:indexPath];
                return tempCameraCell;
            }
        }
        tempAssetModel = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[indexPath.row];
    }else { // 倒叙
        if ([WarmIMImagePickerManager sharedManager].isShowTakePhoto) { // 展示相机
            if (indexPath.section == 0) {
                WarmIMImagePickerCollectionViewCameraCell *tempCameraCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WarmIMImagePickerCollectionViewCameraCell" forIndexPath:indexPath];
                return tempCameraCell;
            }
        }
        tempAssetModel = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels[[WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels.count - indexPath.row - 1];
    }
    
    // 设置CELL
    if (tempAssetModel.asset.mediaType == PHAssetMediaTypeVideo) {
        WarmIMImagePickerCollectionViewVideoCell *tempVideoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WarmIMImagePickerCollectionViewVideoCell" forIndexPath:indexPath];
        WarmIMWeak(tempVideoCell);
        [[WarmIMImagePickerManager sharedManager].cachingImageManager requestImageForAsset:tempAssetModel.asset targetSize:CGSizeMake([[WarmIMImagePickerManager sharedManager] calculateThumbnailSize], [[WarmIMImagePickerManager sharedManager] calculateThumbnailSize]) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [WeaktempVideoCell.contentImageView setImage:result];
        }];
        NSString *tempDurationString = tempAssetModel.asset.duration<3600?[NSString stringWithFormat:@"%02ld:%02ld", (long)tempAssetModel.asset.duration/60, ((long)tempAssetModel.asset.duration%3600)%60]:[NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)tempAssetModel.asset.duration/3600, ((long)tempAssetModel.asset.duration%3600)/60, ((long)tempAssetModel.asset.duration%3600)%60];
        tempVideoCell.durationLabel.text = tempDurationString;
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            [self registerForPreviewingWithDelegate:self sourceView:tempVideoCell];
        }
        return tempVideoCell;
    }
    if ([WarmIMImagePickerManager sharedManager].livePhotoLevel == WarmIMImagePickerLivePhotoLevelNormal) {
        if (tempAssetModel.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
            WarmIMImagePickerCollectionViewLivePhotoCell *tempLivePhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WarmIMImagePickerCollectionViewLivePhotoCell" forIndexPath:indexPath];
            tempLivePhotoCell.livePhotoView.livePhoto = nil;
            WarmIMWeak(tempLivePhotoCell);
            [[WarmIMImagePickerManager sharedManager].cachingImageManager requestImageForAsset:tempAssetModel.asset targetSize:CGSizeMake([[WarmIMImagePickerManager sharedManager] calculateThumbnailSize], [[WarmIMImagePickerManager sharedManager] calculateThumbnailSize]) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [WeaktempLivePhotoCell.contentImageView setImage:result];
            }];
            tempLivePhotoCell.delegate = self;
            tempLivePhotoCell.selectButton.selected = tempAssetModel.selected;
            if (tempAssetModel.selected) {
                [tempLivePhotoCell showSelectedView];
            }else {
                [tempLivePhotoCell dismissSelectedView];
            }
            tempLivePhotoCell.index = indexPath;
            tempLivePhotoCell.assetModel = tempAssetModel;
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                [self registerForPreviewingWithDelegate:self sourceView:tempLivePhotoCell];
            }
            return tempLivePhotoCell;
        }
    }
    WarmIMImagePickerCollectionViewImageCell *tempImageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WarmIMImagePickerCollectionViewImageCell" forIndexPath:indexPath];
    WarmIMWeak(tempImageCell);
    [[WarmIMImagePickerManager sharedManager].cachingImageManager requestImageForAsset:tempAssetModel.asset targetSize:CGSizeMake([[WarmIMImagePickerManager sharedManager] calculateThumbnailSize], [[WarmIMImagePickerManager sharedManager] calculateThumbnailSize]) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [WeaktempImageCell.contentImageView setImage:result];
    }];
    tempImageCell.delegate = self;
    tempImageCell.selectButton.selected = tempAssetModel.selected;
    if (tempAssetModel.selected) {
        [tempImageCell showSelectedView];
    }else {
        [tempImageCell dismissSelectedView];
    }
    tempImageCell.index = indexPath;
    tempImageCell.assetModel = tempAssetModel;
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:tempImageCell];
    }
    return tempImageCell;
}

// section的数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([WarmIMImagePickerManager sharedManager].isShowTakePhoto)
        return 2;
    return 1;
}


#pragma mark - WarmIMImagePickerCollectionBottomViewDelegate
// 预览选择的图片
- (void)WarmIMImagePickerCollectionBottomView:(WarmIMImagePickerCollectionBottomView *)bottomView previewButtonClicked:(UIButton *)previewButton {
    [WarmIMImagePickerManager sharedManager].currenDisplayModel = [WarmIMImagePickerManager sharedManager].selectedImageModels.firstObject;
    WarmIMImagePreviewViewController *tempPreviewVC = [[WarmIMImagePreviewViewController alloc]init];
    tempPreviewVC.currentIndex = 0;
    tempPreviewVC.type = WarmIMImagePreviewViewControllerTypeSelected;
    tempPreviewVC.delegate = self;
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    [self.navigationController pushViewController:tempPreviewVC animated:YES];
}

// 选择原图
- (void)WarmIMImagePickerCollectionBottomView:(WarmIMImagePickerCollectionBottomView *)bottomView originalButtonClicked:(UIButton *)originalButton {
    // 遍历取消／选择所有以选择的资源的原图
    if ([WarmIMImagePickerManager sharedManager].selectedOriginalImageCount > 0) {
        if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count <= [WarmIMImagePickerManager sharedManager].selectedOriginalImageCount) {
            originalButton.selected = NO;
            [[WarmIMImagePickerManager sharedManager].selectedImageModels enumerateObjectsUsingBlock:^(WarmIMImagePickerAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.isSelectedOriginalImage = NO;
            }];
            [WarmIMImagePickerManager sharedManager].selectedOriginalImageCount = 0;
            return;
        }
        [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"已选择所有选中图片的原图。" imageName:@"WarmIM_right_tip" timeInterval:1.0];
    }
    originalButton.selected = YES;
    [[WarmIMImagePickerManager sharedManager].selectedImageModels enumerateObjectsUsingBlock:^(WarmIMImagePickerAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelectedOriginalImage = YES;
    }];
    [WarmIMImagePickerManager sharedManager].selectedOriginalImageCount = [WarmIMImagePickerManager sharedManager].selectedImageModels.count;
}

// 发送
- (void)WarmIMImagePickerCollectionBottomView:(WarmIMImagePickerCollectionBottomView *)bottomView determineButtonClicked:(UIButton *)determineButton {
    if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count > 0) {
        if ([[WarmIMImagePickerManager sharedManager].delegate respondsToSelector:@selector(WarmIMImagePickerSelectedImages:)]) {
            [[WarmIMImagePickerManager sharedManager].delegate WarmIMImagePickerSelectedImages:[WarmIMImagePickerManager sharedManager].selectedImageModels];
        }
    }else {
        if ([[WarmIMImagePickerManager sharedManager].delegate respondsToSelector:@selector(WarmIMImagePickerSelectedNone)]) {
            [[WarmIMImagePickerManager sharedManager].delegate WarmIMImagePickerSelectedNone];
        }
    }
    [[WarmIMImagePickerManager sharedManager] dismissPhotoLibrary];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - WarmIMImagePickerCollectionViewImageCellDelegate
// 点击图片右上角对勾
- (void)WarmIMImagePickerCollectionViewImageCell:(WarmIMImagePickerCollectionViewImageCell *)imageCell selectButtonClickedModel:(WarmIMImagePickerAssetModel *)assetModel indexPath:(NSIndexPath *)indexPath {
    if (assetModel.selected == NO) { // 选择
        [self selectedImageWithModel:assetModel withCell:imageCell indexPath:indexPath];
    }else { // 取消选择
        [self deselectedImageWithModel:assetModel withCell:imageCell indexPath:indexPath];
    }
    
}

#pragma mark - WarmIMImagePickerCollectionViewLivePhotoCellDelegate
- (void)WarmIMImagePickerCollectionViewLivePhotoCell:(WarmIMImagePickerCollectionViewLivePhotoCell *)imageCell selectButtonClickedModel:(WarmIMImagePickerAssetModel *)assetModel indexPath:(NSIndexPath *)indexPath {
    if (assetModel.selected == NO) { // 选择
        [self selectedImageWithModel:assetModel withCell:imageCell indexPath:indexPath];
    }else { // 取消选择
        [self deselectedImageWithModel:assetModel withCell:imageCell indexPath:indexPath];
    }
}

#pragma mark - WarmIMImagePreviewViewControllerDelegate

- (void)WarmIMImagePreviewViewControllerDelegateSelectedChanged {
    [_collectionView reloadData];
    [self reloadBottomView];
}

#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [_collectionView indexPathForCell:(UICollectionViewCell *)[previewingContext sourceView]];
    WarmIMImagePickerAssetModel *tempModel = [self getModelWithIndexPath:indexPath];
    
    [WarmIMImagePickerManager sharedManager].currenDisplayModel = tempModel;
    
    if (tempModel.asset.mediaType == PHAssetMediaTypeVideo) {
        WarmIMVideoPreviewViewController *tempVideoVC = [[WarmIMVideoPreviewViewController alloc]init];
        tempVideoVC.preferredContentSize = [self getImagePreviewVCPoperSizeWithWidth:tempModel.asset.pixelWidth height:tempModel.asset.pixelHeight];
        tempVideoVC.navigationController.navigationBarHidden = YES;
        tempVideoVC.forceTouch = YES;
        CGRect rect = CGRectMake(0, 0, previewingContext.sourceView.bounds.size.width, previewingContext.sourceView.bounds.size.height);
        previewingContext.sourceRect = rect;
        return tempVideoVC;
    }else {
        WarmIMImagePreviewViewController *tempPreviewVC = [[WarmIMImagePreviewViewController alloc]init];
        tempPreviewVC.forceTouch = YES;
        tempPreviewVC.delegate = self;
        tempPreviewVC.preferredContentSize = [self getImagePreviewVCPoperSizeWithWidth:tempModel.asset.pixelWidth height:tempModel.asset.pixelHeight];
        tempPreviewVC.navigationController.navigationBarHidden = YES;
        tempPreviewVC.currentIndex = indexPath.row;
        CGRect rect = CGRectMake(0, 0, previewingContext.sourceView.bounds.size.width, previewingContext.sourceView.bounds.size.height);
        previewingContext.sourceRect = rect;
        return tempPreviewVC;
    }
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    [self showViewController:viewControllerToCommit sender:self];
}

#pragma mark - WarmIMNavigationControllerBackHanderDelegate

-(BOOL)navigationControllerShouldPopOnBackButton {
    
    [[WarmIMImagePickerManager sharedManager] cancelAllSelected];
    
    return YES;
}


@end
