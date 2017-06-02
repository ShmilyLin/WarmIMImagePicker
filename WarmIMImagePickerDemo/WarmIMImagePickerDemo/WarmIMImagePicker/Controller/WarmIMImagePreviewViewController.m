//
//  WarmIMImagePreviewViewController.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/17.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMImagePreviewViewController.h"

#import "WarmIMImagePickerManager.h"
#import "WarmIMHUD.h"

#import "WarmIMImagePickerCollectionViewImagePreviewCell.h"
#import "WarmIMImagePickerLivePhotoPreviewCell.h"
#import "WarmIMImagePickerPreviewBottomView.h"

@interface WarmIMImagePreviewViewController ()
<UICollectionViewDataSource,
WarmIMImagePickerPreviewBottomViewDelegate,
UIScrollViewDelegate,
UICollectionViewDelegateFlowLayout,
WarmIMImagePickerCollectionViewImagePreviewCellDelegate,
WarmIMImagePickerLivePhotoPreviewCellDelegate> {
    NSInteger isScrollBottom;
    NSInteger is3DTouchInViewWillAppear;
}

@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, strong) WarmIMImagePickerPreviewBottomView *bottomView;

@property (nonatomic, strong) UIButton *rightBarItem;


@property (nonatomic, assign) NSInteger currenImageIndex;

@property (nonatomic, strong) NSMutableArray<WarmIMImagePickerAssetModel *> *sourceSelectedArray;

@end

@implementation WarmIMImagePreviewViewController


#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isScrollBottom = 0;
    is3DTouchInViewWillAppear = 0;
    
//    self.navigationController.hidesBarsOnTap = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_type == WarmIMImagePreviewViewControllerTypeAll) {
        _currenImageIndex = [[WarmIMImagePickerManager sharedManager].currentDisplayCollection.collectionImageFetchResult indexOfObject:[WarmIMImagePickerManager sharedManager].currenDisplayModel.asset];
    }else {
        _sourceSelectedArray = [NSMutableArray arrayWithArray:[WarmIMImagePickerManager sharedManager].selectedImageModels];
        _currenImageIndex = [_sourceSelectedArray indexOfObject:[WarmIMImagePickerManager sharedManager].currenDisplayModel];
    }
    
    
//    PHFetchResult *tempCurrenFetResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[[WarmIMImagePickerManager sharedManager].currenDisplayModel.asset.localIdentifier] options:nil];
//    if (tempCurrenFetResult.count > 0) {
    
//    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setupSubViews];
    [self reloadOtherViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"WarmIMImagePreviewViewController 页面收到内存警告");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGRect rect = CGRectMake(0.0f, 0.0f, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.0 alpha:0.5].CGColor);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:theImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    if (is3DTouchInViewWillAppear < 2) {
        if (_forceTouch && is3DTouchInViewWillAppear == 1) {
            _bottomView.hidden = NO;
            [self setNeedsStatusBarAppearanceUpdate];
        }
        if (!_forceTouch && is3DTouchInViewWillAppear == 0) {
            _bottomView.hidden = NO;
            [self setNeedsStatusBarAppearanceUpdate];
        }
        is3DTouchInViewWillAppear++;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    if (![WarmIMImagePickerManager sharedManager].isFollowCustomNavigation) {
        CGRect rect = CGRectMake(0.0f, 0.0f, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [WarmIMImagePickerManager sharedManager].navigationBackgroundColor.CGColor);
        CGContextFillRect(context, rect);
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.navigationController.navigationBar setBackgroundImage:theImage forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[WarmIMImagePickerManager sharedManager].navigationTitleColor,NSForegroundColorAttributeName,nil]];
        
        [self.navigationController.navigationBar setTintColor:[WarmIMImagePickerManager sharedManager].navigationTitleColor];
    }else {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:nil];
        [self.navigationController.navigationBar setTintColor:nil];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (isScrollBottom < 4) {
        isScrollBottom++;
        if (!_forceTouch && isScrollBottom == 2) {
//            _bottomView.hidden = NO;
            isScrollBottom = 4;
        }
        if ([WarmIMImagePickerManager sharedManager].showPicturesSequential) {
            [_collectionView setContentOffset:CGPointMake(([UIScreen mainScreen].bounds.size.width + 30)*_currenImageIndex, 0)];
        }else {
            [_collectionView setContentOffset:CGPointMake(([UIScreen mainScreen].bounds.size.width + 30)*([WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels.count - _currenImageIndex - 1), 0)];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return _bottomView.hidden;
}

- (void)dealloc {
    NSLog(@"WarmIMImagePreviewViewController dealoc");
}


#pragma mark - UI

- (void)setupSubViews {
    
    if (!_rightBarItem) {
        _rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_rightBarItem setImage:[UIImage imageNamed:@"WarmIM_not_selected_gray"] forState:UIControlStateNormal];
        [_rightBarItem setImage:[UIImage imageNamed:@"WarmIM_checkbox_selected"] forState:UIControlStateSelected];
        [_rightBarItem addTarget:self action:@selector(rightNavigationBarClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *tempBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarItem];
        self.navigationItem.rightBarButtonItem = tempBarButtonItem;
    }
    
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *tempFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        [tempFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        tempFlowLayout.minimumLineSpacing = 30;
        tempFlowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        tempFlowLayout.itemSize = self.view.bounds.size;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:tempFlowLayout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[WarmIMImagePickerCollectionViewImagePreviewCell class] forCellWithReuseIdentifier:@"WarmIMImagePickerCollectionViewImagePreviewCell"];
        if ([WarmIMImagePickerManager sharedManager].livePhotoLevel == WarmIMImagePickerLivePhotoLevelNormal) {
            [_collectionView registerClass:[WarmIMImagePickerLivePhotoPreviewCell class] forCellWithReuseIdentifier:@"WarmIMImagePickerLivePhotoPreviewCell"];
        }
        [self.view addSubview:_collectionView];
    }
    if (!_bottomView) {
        _bottomView = [[WarmIMImagePickerPreviewBottomView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomView.delegate = self;
        _bottomView.hidden = YES;
        [self.view addSubview:_bottomView];
    }
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-15.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:15.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
}

- (void)reloadOtherViews {
    NSInteger tempCurrenIndex = _currenImageIndex + 1;
    WarmIMImagePickerAssetModel *tempModel = [self getCurrentDisplayModel];
    NSString *tempTitle;
    if (_type == WarmIMImagePreviewViewControllerTypeAll) {
        if (![WarmIMImagePickerManager sharedManager].showPicturesSequential) {
            tempCurrenIndex = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.imageAssetModels.count - _currenImageIndex;
        }
        tempTitle = [NSString stringWithFormat:@"%ld/%lu", (long)tempCurrenIndex, (unsigned long)[WarmIMImagePickerManager sharedManager].currentDisplayCollection.imageAssetModels.count];
    }else {
        tempTitle = [NSString stringWithFormat:@"%ld/%lu", (long)tempCurrenIndex, (unsigned long)_sourceSelectedArray.count];
    }
    self.title = tempTitle;
    
    _rightBarItem.selected = tempModel.selected;
    _bottomView.originalButton.selected = tempModel.isSelectedOriginalImage;
    if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count > 0) {
        _bottomView.determineButton.backgroundColor = [UIColor colorWithRed:142/255.0 green:86/255.0 blue:246/255.0 alpha:1.0];
        NSString *tempDetermineButtonTitle = [NSString stringWithFormat:@"%@(%lu)", [[WarmIMGlobal sharedGlobal] showText:@"OK"], (unsigned long)[WarmIMImagePickerManager sharedManager].selectedImageModels.count];
        [_bottomView.determineButton setTitle:tempDetermineButtonTitle forState:UIControlStateSelected];
        _bottomView.determineButton.selected = YES;
    }else {
        _bottomView.determineButton.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        _bottomView.determineButton.selected = NO;
    }
}

#pragma mark - Functions

- (WarmIMImagePickerAssetModel *)getCurrentDisplayModel {
    if (_type == WarmIMImagePreviewViewControllerTypeAll) {
        if (![WarmIMImagePickerManager sharedManager].showPicturesSequential) {
            return [WarmIMImagePickerManager sharedManager].currentDisplayCollection.imageAssetModels[[WarmIMImagePickerManager sharedManager].currentDisplayCollection.imageAssetModels.count - _currenImageIndex - 1];
        }else {
            return [WarmIMImagePickerManager sharedManager].currentDisplayCollection.imageAssetModels[_currenImageIndex];
        }
    }else {
        return _sourceSelectedArray[_currenImageIndex];
    }
    
}


#pragma mark - Actions

- (void)rightNavigationBarClicked:(UIBarButtonItem *)sender {
    WarmIMImagePickerAssetModel *tempModel = [self getCurrentDisplayModel];
    if (tempModel.selected) {
        [[WarmIMImagePickerManager sharedManager].selectedImageModels removeObject:tempModel];
        tempModel.selected = NO;
        if (tempModel.isSelectedOriginalImage) {
            tempModel.isSelectedOriginalImage = NO;
//            _bottomView.originalButton.selected = NO;
            [WarmIMImagePickerManager sharedManager].selectedOriginalImageCount--;
        }
//        _rightBarItem.selected = NO;
        [self reloadOtherViews];
        if ([self.delegate respondsToSelector:@selector(WarmIMImagePreviewViewControllerDelegateSelectedChanged)]) {
            [self.delegate WarmIMImagePreviewViewControllerDelegateSelectedChanged];
        }
    }else {
        if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count >= [WarmIMImagePickerManager sharedManager].imageCountMax) {
            NSString *tempTipString = [NSString stringWithFormat:@"图片最多可以选择%ld张", (long)[WarmIMImagePickerManager sharedManager].imageCountMax];
            [[WarmIMHUD sharedHUD]showWarmIMTitleHUD:tempTipString imageName:@"WarmIM_error_tip" timeInterval:1.0];
        }else {
            if (tempModel.iniCloud && tempModel.isDownloading) {
                [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"正在从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                return;
            }
            if (tempModel.iniCloud && [WarmIMImagePickerManager sharedManager].isAllowiCloudDownload == WarmIMImagePickeriCloudDownloadTypeNo) {
                [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"该资源尚未从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                return;
            }
            if (!tempModel.iniCloud && tempModel.isDownload) {
                tempModel.selected = YES;
                [[WarmIMImagePickerManager sharedManager].selectedImageModels addObject:tempModel];
                [self reloadOtherViews];
                if ([self.delegate respondsToSelector:@selector(WarmIMImagePreviewViewControllerDelegateSelectedChanged)]) {
                    [self.delegate WarmIMImagePreviewViewControllerDelegateSelectedChanged];
                }
                return;
            }
            
            WarmIMWeak(tempModel)
            WarmIMWeakSelf
            
            if ([WarmIMImagePickerManager sharedManager].livePhotoLevel == WarmIMImagePickerLivePhotoLevelNormal) {
                if (tempModel.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                    if (tempModel.requestID) {
                        if (tempModel.downloadRequestID) {
                            return;
                        }
                        [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:tempModel.requestID];
                    }
                    tempModel.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestLivePhotoForAsset:tempModel.asset targetSize:CGSizeMake(tempModel.asset.pixelWidth, tempModel.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
                        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) { // 原始图片
                            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) { // 在iCloud上
                                WeaktempModel.iniCloud = YES;
                                if ([WarmIMImagePickerManager sharedManager].isAllowiCloudDownload != WarmIMImagePickeriCloudDownloadTypeNo) {
                                    WeaktempModel.isDownloading = YES;
                                    [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"正在从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                                    PHLivePhotoRequestOptions *tempLiveRequestOptions = [[PHLivePhotoRequestOptions alloc]init];
                                    tempLiveRequestOptions.networkAccessAllowed = YES;
                                    if (WeaktempModel.requestID) {
                                        if (WeaktempModel.downloadRequestID) {
                                            return;
                                        }
                                        [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:WeaktempModel.requestID];
                                    }
                                    WeaktempModel.downloadRequestID = YES;
                                    WeaktempModel.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestLivePhotoForAsset:WeaktempModel.asset targetSize:CGSizeMake(WeaktempModel.asset.pixelWidth, WeaktempModel.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:tempLiveRequestOptions resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable downloadInfo) {
                                        if (![[downloadInfo objectForKey:PHImageResultIsDegradedKey] boolValue] && ![[downloadInfo objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                                            WeaktempModel.iniCloud = NO;
                                            WeaktempModel.isDownload = YES;
                                            WeaktempModel.isDownloading = NO;
                                            WeaktempModel.downloadRequestID = NO;
                                        }
                                    }];
                                }else {
                                    WeaktempModel.isDownload = NO;
                                    WeaktempModel.isDownloading = NO;
                                    [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"该资源尚未从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                                }
                            }else { // 不在iCloud上
                                WeaktempModel.iniCloud = NO;
                                WeaktempModel.isDownloading = NO;
                                WeaktempModel.isDownload = YES;
                                if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count < [WarmIMImagePickerManager sharedManager].imageCountMax && !WeaktempModel.selected) {
                                    WeaktempModel.selected = YES;
                                    [[WarmIMImagePickerManager sharedManager].selectedImageModels addObject:WeaktempModel];
                                    [WeakSelf reloadOtherViews];
                                    if ([WeakSelf.delegate respondsToSelector:@selector(WarmIMImagePreviewViewControllerDelegateSelectedChanged)]) {
                                        [WeakSelf.delegate WarmIMImagePreviewViewControllerDelegateSelectedChanged];
                                    }
                                }
                            }
                        }
                    }];
                    return;
                }
            }
            
            if (tempModel.requestID) {
                if (tempModel.downloadRequestID) {
                    return;
                }
                [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:tempModel.requestID];
            }
            tempModel.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestImageForAsset:tempModel.asset targetSize:CGSizeMake(tempModel.asset.pixelWidth, tempModel.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) { // 原始图片
                    if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) { // 在iCloud上
                        WeaktempModel.iniCloud = YES;
                        if ([WarmIMImagePickerManager sharedManager].isAllowiCloudDownload != WarmIMImagePickeriCloudDownloadTypeNo) {
                            WeaktempModel.isDownloading = YES;
                            [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"正在从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                            PHImageRequestOptions *tempRequestOptions = [[PHImageRequestOptions alloc]init];
                            tempRequestOptions.networkAccessAllowed = YES;
                            if (WeaktempModel.requestID) {
                                if (WeaktempModel.downloadRequestID) {
                                    return;
                                }
                                [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:WeaktempModel.requestID];
                            }
                            WeaktempModel.downloadRequestID = YES;
                            WeaktempModel.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestImageForAsset:WeaktempModel.asset targetSize:CGSizeMake(WeaktempModel.asset.pixelWidth, WeaktempModel.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:tempRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable downloadInfo) {
                                if (![[downloadInfo objectForKey:PHImageResultIsDegradedKey] boolValue] && ![[downloadInfo objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                                    WeaktempModel.iniCloud = NO;
                                    WeaktempModel.isDownload = YES;
                                    WeaktempModel.isDownloading = NO;
                                    WeaktempModel.downloadRequestID = NO;
                                }
                            }];
                        }else {
                            [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"该资源尚未从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                        }
                    }else { // 不在iCloud上
                        WeaktempModel.selected = YES;
                        WeaktempModel.iniCloud = NO;
                        WeaktempModel.isDownloading = NO;
                        WeaktempModel.isDownload = YES;
                        if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count < [WarmIMImagePickerManager sharedManager].imageCountMax && !WeaktempModel.selected) {
                            WeaktempModel.selected = YES;
                            [[WarmIMImagePickerManager sharedManager].selectedImageModels addObject:WeaktempModel];
                            [WeakSelf reloadOtherViews];
                            if ([WeakSelf.delegate respondsToSelector:@selector(WarmIMImagePreviewViewControllerDelegateSelectedChanged)]) {
                                [WeakSelf.delegate WarmIMImagePreviewViewControllerDelegateSelectedChanged];
                            }
                        }
                    }
                }
            }];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_type == WarmIMImagePreviewViewControllerTypeAll) {
        return [WarmIMImagePickerManager sharedManager].currentDisplayCollection.imageAssetModels.count;
    }
    return _sourceSelectedArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WarmIMImagePickerAssetModel *tempModel;
    if (_type == WarmIMImagePreviewViewControllerTypeAll) {
        if ([WarmIMImagePickerManager sharedManager].showPicturesSequential) {
            tempModel = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.imageAssetModels[indexPath.row];
        }else {
            tempModel = [WarmIMImagePickerManager sharedManager].currentDisplayCollection.imageAssetModels[[WarmIMImagePickerManager sharedManager].currentDisplayCollection.assetModels.count - indexPath.row - 1];
        }
    }else {
        tempModel = _sourceSelectedArray[indexPath.row];
    }
    
    
    if ([WarmIMImagePickerManager sharedManager].livePhotoLevel == WarmIMImagePickerLivePhotoLevelNormal) {
        if (tempModel.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
            WarmIMImagePickerLivePhotoPreviewCell *tempLivePhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WarmIMImagePickerLivePhotoPreviewCell" forIndexPath:indexPath];
            [tempLivePhotoCell setScrollViewContentSizeWithWidth:tempModel.asset.pixelWidth height:tempModel.asset.pixelHeight];
            PHLivePhotoRequestOptions *tempLiveRequestOptions = [[PHLivePhotoRequestOptions alloc]init];
            if ([WarmIMImagePickerManager sharedManager].isAllowiCloudDownload == WarmIMImagePickeriCloudDownloadTypeAny || [WarmIMImagePickerManager sharedManager].isAllowiCloudDownload == WarmIMImagePickeriCloudDownloadTypeImage) {
                tempLiveRequestOptions.networkAccessAllowed = YES;
            }
            WarmIMWeak(tempLivePhotoCell);
            [[WarmIMImagePickerManager sharedManager].cachingImageManager requestLivePhotoForAsset:tempModel.asset targetSize:CGSizeMake(tempModel.asset.pixelWidth, tempModel.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:tempLiveRequestOptions resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
                if (livePhoto) {
                    WeaktempLivePhotoCell.livePhotoView.livePhoto = livePhoto;
                }
            }];
            tempLivePhotoCell.delegate = self;
            return tempLivePhotoCell;
        }
    }
    WarmIMImagePickerCollectionViewImagePreviewCell *tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WarmIMImagePickerCollectionViewImagePreviewCell" forIndexPath:indexPath];
    [tempCell setScrollViewContentSizeWithWidth:tempModel.asset.pixelWidth height:tempModel.asset.pixelHeight];
    PHImageRequestOptions *tempRequestOptions = [[PHImageRequestOptions alloc]init];
    if ([WarmIMImagePickerManager sharedManager].isAllowiCloudDownload == WarmIMImagePickeriCloudDownloadTypeAny || [WarmIMImagePickerManager sharedManager].isAllowiCloudDownload == WarmIMImagePickeriCloudDownloadTypeImage) {
        tempRequestOptions.networkAccessAllowed = YES;
    }
    WarmIMWeak(tempCell);
    [[WarmIMImagePickerManager sharedManager].cachingImageManager requestImageForAsset:tempModel.asset targetSize:CGSizeMake(tempModel.asset.pixelWidth, tempModel.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:tempRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            [WeaktempCell.imageView setImage:result];
        }
    }];
    tempCell.delegate = self;
    return tempCell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _collectionView) {
        CGFloat tempPage = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width + 30);
        if (_currenImageIndex != tempPage && isScrollBottom >= 4) {
            _currenImageIndex = tempPage;
            [self reloadOtherViews];
        }
    }
}

#pragma mark - WarmIMImagePickerPreviewBottomViewDelegate
- (void)WarmIMImagePickerPreviewBottomView:(WarmIMImagePickerPreviewBottomView *)bottomView originalButtonClicked:(UIButton *)originalButton {
    WarmIMImagePickerAssetModel *tempModel = [self getCurrentDisplayModel];
    if (tempModel.selected) {
        if (tempModel.isSelectedOriginalImage) {
            tempModel.isSelectedOriginalImage = NO;
            _bottomView.originalButton.selected = NO;
            [WarmIMImagePickerManager sharedManager].selectedOriginalImageCount--;
        }else {
            tempModel.isSelectedOriginalImage = YES;
            _bottomView.originalButton.selected = YES;
            [WarmIMImagePickerManager sharedManager].selectedOriginalImageCount++;
        }
        if ([self.delegate respondsToSelector:@selector(WarmIMImagePreviewViewControllerDelegateSelectedChanged)]) {
            [self.delegate WarmIMImagePreviewViewControllerDelegateSelectedChanged];
        }
    }else {
        if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count >= [WarmIMImagePickerManager sharedManager].imageCountMax) {
            NSString *tempTipString = [NSString stringWithFormat:@"图片最多可以选择%ld张", (long)[WarmIMImagePickerManager sharedManager].imageCountMax];
            [[WarmIMHUD sharedHUD]showWarmIMTitleHUD:tempTipString imageName:@"WarmIM_error_tip" timeInterval:1.0];
        }else {
            if (tempModel.iniCloud && tempModel.isDownloading) {
                [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"正在从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                return;
            }
            if (tempModel.iniCloud && [WarmIMImagePickerManager sharedManager].isAllowiCloudDownload == WarmIMImagePickeriCloudDownloadTypeNo) {
                [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"该资源尚未从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                return;
            }
            if (!tempModel.iniCloud && tempModel.isDownload) {
                tempModel.selected = YES;
                tempModel.isSelectedOriginalImage = YES;
                [[WarmIMImagePickerManager sharedManager].selectedImageModels addObject:tempModel];
                [WarmIMImagePickerManager sharedManager].selectedOriginalImageCount++;
                [self reloadOtherViews];
                if ([self.delegate respondsToSelector:@selector(WarmIMImagePreviewViewControllerDelegateSelectedChanged)]) {
                    [self.delegate WarmIMImagePreviewViewControllerDelegateSelectedChanged];
                }
                return;
            }
            WarmIMWeak(tempModel)
//            WarmIMWeak(indexPath)
            WarmIMWeakSelf
            
            if ([WarmIMImagePickerManager sharedManager].livePhotoLevel == WarmIMImagePickerLivePhotoLevelNormal) {
                if (tempModel.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                    if (tempModel.requestID) {
                        if (tempModel.downloadRequestID) {
                            return;
                        }
                        [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:tempModel.requestID];
                    }
                    tempModel.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestLivePhotoForAsset:tempModel.asset targetSize:CGSizeMake(tempModel.asset.pixelWidth, tempModel.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
                        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) { // 原始图片
                            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) { // 在iCloud上
                                WeaktempModel.iniCloud = YES;
                                if ([WarmIMImagePickerManager sharedManager].isAllowiCloudDownload != WarmIMImagePickeriCloudDownloadTypeNo) {
                                    WeaktempModel.isDownloading = YES;
                                    [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"正在从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                                    PHLivePhotoRequestOptions *tempLiveRequestOptions = [[PHLivePhotoRequestOptions alloc]init];
                                    tempLiveRequestOptions.networkAccessAllowed = YES;
                                    if (WeaktempModel.requestID) {
                                        if (WeaktempModel.downloadRequestID) {
                                            return;
                                        }
                                        [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:WeaktempModel.requestID];
                                    }
                                    WeaktempModel.downloadRequestID = YES;
                                    WeaktempModel.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestLivePhotoForAsset:WeaktempModel.asset targetSize:CGSizeMake(WeaktempModel.asset.pixelWidth, WeaktempModel.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:tempLiveRequestOptions resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable downloadInfo) {
                                        if (![[downloadInfo objectForKey:PHImageResultIsDegradedKey] boolValue] && ![[downloadInfo objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                                            WeaktempModel.iniCloud = NO;
                                            WeaktempModel.isDownload = YES;
                                            WeaktempModel.isDownloading = NO;
                                            WeaktempModel.downloadRequestID = NO;
                                        }
                                    }];
                                }else {
                                    WeaktempModel.isDownload = NO;
                                    WeaktempModel.isDownloading = NO;
                                    [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"该资源尚未从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                                }
                            }else { // 不在iCloud上
                                WeaktempModel.iniCloud = NO;
                                WeaktempModel.isDownloading = NO;
                                WeaktempModel.isDownload = YES;
                                if ([WarmIMImagePickerManager sharedManager].selectedImageModels.count < [WarmIMImagePickerManager sharedManager].imageCountMax && !WeaktempModel.selected) {
                                    WeaktempModel.selected = YES;
                                    WeaktempModel.isSelectedOriginalImage = YES;
                                    [[WarmIMImagePickerManager sharedManager].selectedImageModels addObject:WeaktempModel];
                                    [WarmIMImagePickerManager sharedManager].selectedOriginalImageCount++;
                                    [WeakSelf reloadOtherViews];
                                    if ([WeakSelf.delegate respondsToSelector:@selector(WarmIMImagePreviewViewControllerDelegateSelectedChanged)]) {
                                        [WeakSelf.delegate WarmIMImagePreviewViewControllerDelegateSelectedChanged];
                                    }
                                }
                            }
                        }
                    }];
                    return;
                }
            }
            
            if (tempModel.requestID) {
                if (tempModel.downloadRequestID) {
                    return;
                }
                [[WarmIMImagePickerManager sharedManager].cachingImageManager cancelImageRequest:tempModel.requestID];
            }
            tempModel.requestID = [[WarmIMImagePickerManager sharedManager].cachingImageManager requestImageForAsset:WeaktempModel.asset targetSize:CGSizeMake(WeaktempModel.asset.pixelWidth, WeaktempModel.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
                    NSLog(@"原始图片");
                    if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                        NSLog(@"在iCloud上");
                        WeaktempModel.iniCloud = YES;
                        if ([WarmIMImagePickerManager sharedManager].isAllowiCloudDownload == WarmIMImagePickeriCloudDownloadTypeAny || [WarmIMImagePickerManager sharedManager].isAllowiCloudDownload == WarmIMImagePickeriCloudDownloadTypeImage) {
                            WeaktempModel.isDownloading = YES;
                            [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"正在从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                            PHImageRequestOptions *tempRequestOptions = [[PHImageRequestOptions alloc]init];
                            tempRequestOptions.networkAccessAllowed = YES;
                            [[WarmIMImagePickerManager sharedManager].cachingImageManager requestImageForAsset:WeaktempModel.asset targetSize:CGSizeMake(WeaktempModel.asset.pixelWidth, WeaktempModel.asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:tempRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable downloadInfo) {
                                if (![[downloadInfo objectForKey:PHImageResultIsDegradedKey] boolValue] && ![[downloadInfo objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                                    WeaktempModel.iniCloud = NO;
                                    WeaktempModel.isDownload = YES;
                                    WeaktempModel.isDownloading = NO;
                                    WeaktempModel.downloadRequestID = NO;
                                }
                            }];
                        }else {
                            [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"该资源尚未从iCloud上下载。" imageName:@"WarmIM_error_tip" timeInterval:1];
                        }
                    }else {
                        NSLog(@"不在iCloud上");
                        WeaktempModel.iniCloud = NO;
                        WeaktempModel.isDownloading = NO;
                        WeaktempModel.isDownload = YES;
                        WeaktempModel.selected = YES;
                        [[WarmIMImagePickerManager sharedManager].selectedImageModels addObject:WeaktempModel];
                        WeaktempModel.isSelectedOriginalImage = YES;
                        [WeakSelf reloadOtherViews];
                        [WarmIMImagePickerManager sharedManager].selectedOriginalImageCount++;
                        if ([WeakSelf.delegate respondsToSelector:@selector(WarmIMImagePreviewViewControllerDelegateSelectedChanged)]) {
                            [WeakSelf.delegate WarmIMImagePreviewViewControllerDelegateSelectedChanged];
                        }
                    }
                }
            }];
        }
    }
}

- (void)WarmIMImagePickerPreviewBottomView:(WarmIMImagePickerPreviewBottomView *)bottomView determineButtonClicked:(UIButton *)determineButton {
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

#pragma mark - WarmIMImagePickerCollectionViewImagePreviewCellDelegate
- (void)imagePreviewCellScrollViewSimpleTap {
    _bottomView.hidden = !_bottomView.isHidden;
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.isHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}
#pragma mark - WarmIMImagePickerLivePhotoPreviewCellDelegate
- (void)livePhotoPreviewCellScrollViewSimpleTap {
    _bottomView.hidden = !_bottomView.isHidden;
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.isHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}
@end
