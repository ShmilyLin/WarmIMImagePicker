//
//  WarmIMAlbumsListViewController.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/4/29.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMAlbumsListViewController.h"

#import "WarmIMImagePickerManager.h"
#import "WarmIMImagePickerFetchResults.h"
#import "WarmIMHUD.h"

#import "WarmIMPhotosListViewController.h"
#import "WarmIMImagePickerAlbumTableViewCell.h"


@interface WarmIMAlbumsListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) WarmIMImagePickerFetchResults *collectionsFetchResult;

@property (nonatomic, strong) dispatch_queue_t dataQueue;

@end

@implementation WarmIMAlbumsListViewController

#pragma mark - init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [[WarmIMGlobal sharedGlobal] showText:@"Pictures"];
    
    if (![WarmIMImagePickerManager sharedManager].isFollowCustomNavigation) {
        // 设置导航栏背景颜色方法一：稍微透明
        CGRect rect = CGRectMake(0.0f, 0.0f, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [WarmIMImagePickerManager sharedManager].navigationBackgroundColor.CGColor);
        CGContextFillRect(context, rect);
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.navigationController.navigationBar setBackgroundImage:theImage forBarMetrics:UIBarMetricsDefault];
        
        // 设置导航栏背景颜色方法二：稍微色差
//        [self.navigationController.navigationBar setBarTintColor:[WarmIMImagePickerManager sharedManager].navigationBackgroundColor];
        
        // 设置导航栏背景颜色方法三：设置全体，稍微色差。
//        [[UINavigationBar appearance] setBarTintColor:[WarmIMImagePickerManager sharedManager].navigationBackgroundColor];
        
        // 设置导航栏标题颜色方法一：部分
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[WarmIMImagePickerManager sharedManager].navigationTitleColor,NSForegroundColorAttributeName,nil]];
        
        // 设置导航栏标题颜色方法二：全体
//        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        [self.navigationController.navigationBar setTintColor:[WarmIMImagePickerManager sharedManager].navigationTitleColor];
    }
    
    [[WarmIMHUD sharedHUD] showWarmIMHUD:0];
    WarmIMWeakSelf;
    self.dataQueue = dispatch_queue_create("AssetCollectionsDataQueue", NULL);
    dispatch_async(self.dataQueue, ^{
        WeakSelf.collectionsFetchResult = [[WarmIMImagePickerManager sharedManager] getAllAblums];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([WarmIMImagePickerManager sharedManager].jumpAllPicturesView) {
                if (WeakSelf.collectionsFetchResult.collections.count > 0) {
                    [WeakSelf pushPicturesListViewControllerWithIndex:0 animated:NO];
                }
            }
            [WeakSelf.tableview reloadData];
            [[WarmIMHUD sharedHUD] dismissWarmIMHUDWithAnimated:NO];
        });
    });
//    _collectionsFetchResult = [[WarmIMImagePickerManager sharedManager] getAllAblums];
    
    [self setupSubViews];
    
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector  = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationLandscapeRight;
//        // 从2开始是因为0 1 两个参数已经被selector和target占用
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 收到内存警告
    NSLog(@"WarmIMAlbumsListViewController 页面收到内存警告");
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [[WarmIMHUD sharedHUD] dismissWarmIMHUD];
//}

- (void)dealloc {
    NSLog(@"WarmIMAlbumsListViewController dealoc");
}

#pragma mark - UI
// 设置控件
- (void)setupSubViews {
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:[[WarmIMGlobal sharedGlobal] showText:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 68) style:UITableViewStyleGrouped];
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [self.view addSubview:_tableview];
    
    [self setupSubViewConstraints];
}

// 约束控件
- (void)setupSubViewConstraints {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushPicturesListViewControllerWithIndex:indexPath.row animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [WarmIMImagePickerManager sharedManager].currentFetchResult.collections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WarmIMImagePickerAlbumTableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier:@"WarmIMImagePickerAlbumTableViewCell"];
    if (!tempCell) {
        tempCell = [[WarmIMImagePickerAlbumTableViewCell alloc] initWithReuseIdentifier:@"WarmIMImagePickerAlbumTableViewCell"];
    }
    // 获取对应的相簿集合
    WarmIMImagePickerCollectionModel *tempCollectionModel = [WarmIMImagePickerManager sharedManager].currentFetchResult.collections[indexPath.row];
    // 设置图像
    if (!tempCollectionModel.keyAsset) {
        // 获取keyAsset
        PHFetchResult *tempKeyFetchResult = [PHAsset fetchKeyAssetsInAssetCollection:tempCollectionModel.collection options:nil];
        if (tempKeyFetchResult.count > 0) {
            tempCollectionModel.keyAsset = [tempKeyFetchResult firstObject];
            WarmIMWeak(tempCell);
            PHImageRequestOptions *tempImageOptions = [[PHImageRequestOptions alloc]init];
            tempImageOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageForAsset:tempCollectionModel.keyAsset targetSize:CGSizeMake(58, 58) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [WeaktempCell.logoImageView setImage:result];
            }];
        }else {
            [tempCell.logoImageView setImage:[UIImage imageNamed:@"WarmIM_none_image"]];
        }
    }else {
        WarmIMWeak(tempCell);
        [[PHImageManager defaultManager] requestImageForAsset:tempCollectionModel.keyAsset targetSize:CGSizeMake(58, 58) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [WeaktempCell.logoImageView setImage:result];
        }];
    }
    // 设置标题
    if (tempCollectionModel.collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary && [[[WarmIMGlobal sharedGlobal] getLocalized] isEqual:@"zh-Hans"]) {
        tempCell.nameLabel.text = @"所有照片";
    }else {
        tempCell.nameLabel.text = tempCollectionModel.collection.localizedTitle;
    }
    // 设置数量
    tempCell.countLabel.text = [NSString stringWithFormat:@"(%lu)", (unsigned long)tempCollectionModel.collectionFetchResult.count];
    
    return tempCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


#pragma mark - Actions
// 导航栏右侧按钮点击事件
- (void)rightBarItemClicked:(UIBarButtonItem *)sender {
    if ([[WarmIMImagePickerManager sharedManager].delegate respondsToSelector:@selector(WarmIMImagePickerSelectedNone)]) {
        [[WarmIMImagePickerManager sharedManager].delegate WarmIMImagePickerSelectedNone];
    }
    [[WarmIMImagePickerManager sharedManager] dismissPhotoLibrary];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 跳转图片展示页面
- (void)pushPicturesListViewControllerWithIndex:(NSInteger)index animated:(Boolean)animated {
    [WarmIMImagePickerManager sharedManager].currentDisplayCollection = [WarmIMImagePickerManager sharedManager].currentFetchResult.collections[index];
    WarmIMPhotosListViewController *tempPhotoListVC = [[WarmIMPhotosListViewController alloc] init];
    [self.navigationController pushViewController:tempPhotoListVC animated:animated];
}

@end
