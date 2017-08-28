//
//  WarmIMTestBasicViewController.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/4/27.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMTestBasicViewController.h"
#import "WarmIMImagePickerManager.h"

#import "WarmIMHUD.h"

#import "WarmIMTestOptionItemModel.h"
#import "WarmIMTestColorModel.h"

#import "WarmIMTestTableViewDefaultCell.h"
#import "WarmIMTestTableViewSwitchCell.h"
#import "WarmIMTestTableViewMoreCell.h"
#import "WarmIMTestTableViewPickCell.h"
#import "WarmIMTestTableViewShowCell.h"

#import "WarmIMAlertController.h"


#define WarmIMTestDataVersion 2

@interface WarmIMTestBasicViewController ()<UITableViewDelegate, UITableViewDataSource, WarmIMImagePickerManagerDelegate, WarmIMTestTableViewPickCellDelegate, WarmIMTestTableViewSwitchCellDelegate, WarmIMTestTableViewMoreCellDelegate>


@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSString *sourceDataPath;
@property (nonatomic, strong) NSMutableDictionary *sourceDictionary;
@property (nonatomic, strong) NSMutableArray<WarmIMTestOptionItemModel *> *sourceData;

@property (nonatomic, strong) NSMutableArray<WarmIMTestColorModel *> *colorData;

@end

@implementation WarmIMTestBasicViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [[WarmIMGlobal sharedGlobal] showText:@"Test"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self dealData];
    [self setupSubViews];
    [WarmIMImagePickerManager sharedManager].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Data

- (void)dealData {
    if (!_colorData) {
        _colorData = [NSMutableArray array];
        NSString *tempColorDataPath = [[NSBundle mainBundle] pathForResource:@"TestColorData" ofType:@"plist"];
        NSDictionary *sourceColorDictionary =[[NSMutableDictionary alloc] initWithContentsOfFile:tempColorDataPath];
        for (NSString *tempColorKey in sourceColorDictionary.allKeys) {
            WarmIMTestColorModel *tempColorModel = [WarmIMTestColorModel initWithDictionary:[sourceColorDictionary objectForKey:tempColorKey]];
            [tempColorModel setColorWithRGB];
            [_colorData addObject:tempColorModel];
        }
        [_colorData sortUsingComparator:^NSComparisonResult(WarmIMTestColorModel *obj1, WarmIMTestColorModel *obj2) {
            return [[NSNumber numberWithInteger:obj1.index] compare:[NSNumber numberWithInteger:obj2.index]];
        }];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    if (basePath) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *tempCurrentFileName = [NSString stringWithFormat:@"TestOptionData%d.plist", WarmIMTestDataVersion];
        NSString *filePath = [basePath stringByAppendingPathComponent:tempCurrentFileName];
        if ([fileManager fileExistsAtPath:filePath]) {
            _sourceDataPath = filePath;
            [self getSourceDataFromPath];
        }else {
            if (WarmIMTestDataVersion > 1) {
                NSString *tempLastFileName = [NSString stringWithFormat:@"TestOptionData%d.plist", WarmIMTestDataVersion - 1];
                NSString *tempLastFilePath = [basePath stringByAppendingPathComponent:tempLastFileName];
                if ([fileManager fileExistsAtPath:tempLastFilePath]) {
                    [fileManager removeItemAtPath:tempLastFilePath error:nil];
                }
            }
            NSString *sourceFilePath = [[NSBundle mainBundle] pathForResource:@"TestOptionData" ofType:@"plist"];
            NSError *fileCopyError;
            if([fileManager copyItemAtPath:sourceFilePath toPath:filePath error:&fileCopyError]) {
                _sourceDataPath = filePath;
                [self getSourceDataFromPath];
            }else {
                [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"配置文件拷入失败，请检查剩余存储空间。" imageName:@"WarmIM_error_tip" timeInterval:1.0];
            }
        }
    }else {
        [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"配置文件拷入失败，请检重新启动App，如再出现此情况请等待更新。" imageName:@"WarmIM_error_tip" timeInterval:1.0];
    }
    
    
}

- (void)getSourceDataFromPath {
    _sourceDictionary =[[NSMutableDictionary alloc] initWithContentsOfFile:_sourceDataPath];
    _sourceData = [NSMutableArray array];
    for (NSString *tempKey in _sourceDictionary.allKeys) {
        WarmIMTestOptionItemModel *tempModel = [WarmIMTestOptionItemModel initWithDictionary:[_sourceDictionary objectForKey:tempKey]];
        tempModel.key = tempKey;
        [tempModel calculateDescriptionHeight];
        tempModel.index = [[tempKey substringFromIndex:4] integerValue];
        switch (tempModel.index) {
            case 1: {
                [WarmIMImagePickerManager sharedManager].libraryType = tempModel.selectedNumber;
            }
                break;
            case 2: {
                [WarmIMImagePickerManager sharedManager].jumpAllPicturesView = tempModel.isSelected;
            }
                break;
            case 3: {
                [WarmIMImagePickerManager sharedManager].showEmptyAlbum = tempModel.isSelected;
            }
                break;
            case 4: {
                [WarmIMImagePickerManager sharedManager].livePhotoLevel = tempModel.selectedNumber;
            }
                break;
            case 5: {
                [WarmIMImagePickerManager sharedManager].imageCountMax = tempModel.selectedNumber;
            }
                break;
            case 6: {
                [WarmIMImagePickerManager sharedManager].lineNumber = tempModel.selectedNumber;
            }
                break;
            case 7: {
                [WarmIMImagePickerManager sharedManager].allowScrollSelect = tempModel.isSelected;
            }
                break;
            case 8: {
                [WarmIMImagePickerManager sharedManager].isShowSendSource = tempModel.isSelected;
            }
                break;
            case 9: {
                [WarmIMImagePickerManager sharedManager].isShowTakePhoto = tempModel.isSelected;
            }
                break;
            case 10: {
                [WarmIMImagePickerManager sharedManager].showPicturesSequential = tempModel.isSelected;
            }
                break;
            case 11: {
                [WarmIMImagePickerManager sharedManager].isFollowCustomNavigation = tempModel.isSelected;
            }
                break;
            case 12: {
                for (int m = 0;m < _colorData.count;m++) {
                    if ([tempModel.selectedContent isEqualToString:_colorData[m].colorName]) {
                        [WarmIMImagePickerManager sharedManager].navigationBackgroundColor = _colorData[m].color;
                        break;
                    }
                }
            }
                break;
            case 13: {
                for (int m = 0;m < _colorData.count;m++) {
                    if ([tempModel.selectedContent isEqualToString:_colorData[m].colorName]) {
                        [WarmIMImagePickerManager sharedManager].navigationTitleColor = _colorData[m].color;
                        break;
                    }
                }
            }
                break;
            case 14: {
                [WarmIMImagePickerManager sharedManager].allowiCloudDownload = tempModel.selectedNumber;
            }
                break;
            default:
                break;
        }
        [_sourceData addObject:tempModel];
    }
    
    [_sourceData sortUsingComparator:^NSComparisonResult(WarmIMTestOptionItemModel *obj1, WarmIMTestOptionItemModel *obj2) {
        return [[NSNumber numberWithInteger:obj1.index] compare:[NSNumber numberWithInteger:obj2.index]];
    }];
}

- (void)saveData:(NSInteger)index key:(NSString *)key {
    NSDictionary *tempDic = [_sourceData[index] translateToDictionary];
    [_sourceDictionary setObject:tempDic forKey:key];
    BOOL tempResult = [_sourceDictionary writeToFile:_sourceDataPath atomically:YES];
    if (!tempResult) {
        [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"设置保存失败，仍可以正常使用" imageName:@"WarmIM_error_tip" timeInterval:1.0];
    }
}

#pragma mark - UI

- (void)setupSubViews {
//    [UIScreen mainScreen].bounds.width
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    
    _tableview.translatesAutoresizingMaskIntoConstraints = NO;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [self.view addSubview:_tableview];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        WarmIMTestOptionItemModel *tempModel = _sourceData[indexPath.row];
        if (tempModel.showDescription) {
            return tempModel.descriptionHeight;
        }
        if (tempModel.type == WarmIMTestOptionItemModelTypePick) {
            return 100;
        }
        return 50;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 44;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        WarmIMTestOptionItemModel *tempModel = _sourceData[indexPath.row];
        if (tempModel.showDescription) {
            tempModel.showDescription = NO;
            [_tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else {
            if (![tempModel.descriptionContent isEqualToString:@""]) {
                tempModel.showDescription = YES;
                [_tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }else {
        [self WarmIM_showImagePicker];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return _sourceData.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        WarmIMTestOptionItemModel *tempModel = _sourceData[indexPath.row];
        switch (tempModel.type) {
            case WarmIMTestOptionItemModelTypeDefault: {
                WarmIMTestTableViewDefaultCell *tempDefaultCell = [tableView dequeueReusableCellWithIdentifier:@"WarmIMTestTableViewDefaultCell"];
                if (!tempDefaultCell) {
                    tempDefaultCell = [[WarmIMTestTableViewDefaultCell alloc]initWithReuseIdentifier:@"WarmIMTestTableViewDefaultCell"];
                }
                tempDefaultCell.userInteractionEnabled = !tempModel.isDisable;
                return tempDefaultCell;
            }
                break;
            case WarmIMTestOptionItemModelTypeMore: {
                WarmIMTestTableViewMoreCell *tempMoreCell = [tableView dequeueReusableCellWithIdentifier:@"WarmIMTestTableViewMoreCell"];
                if (!tempMoreCell) {
                    tempMoreCell = [[WarmIMTestTableViewMoreCell alloc]initWithReuseIdentifier:@"WarmIMTestTableViewMoreCell"];
                    tempMoreCell.delegate = self;
                }
                tempMoreCell.topTitleLabel.text = tempModel.title;
                tempMoreCell.descriptionLabel.text = tempModel.descriptionContent;
                tempMoreCell.rightContent.text = tempModel.selectedContent;
                tempMoreCell.lineView.hidden = !tempModel.isShowDescription;
                tempMoreCell.descriptionLabel.hidden = !tempModel.isShowDescription;
                tempMoreCell.userInteractionEnabled = !tempModel.isDisable;
                if (tempModel.isDisable) {
                    tempMoreCell.topTitleLabel.textColor = [UIColor lightGrayColor];
                }else {
                    tempMoreCell.topTitleLabel.textColor = [UIColor blackColor];
                }
                return tempMoreCell;
            }
                break;
            case WarmIMTestOptionItemModelTypeSwitch: {
                WarmIMTestTableViewSwitchCell *tempSwitchCell = [tableView dequeueReusableCellWithIdentifier:@"WarmIMTestTableViewSwitchCell"];
                if (!tempSwitchCell) {
                    tempSwitchCell = [[WarmIMTestTableViewSwitchCell alloc]initWithReuseIdentifier:@"WarmIMTestTableViewSwitchCell"];
                    tempSwitchCell.delegate = self;
                }
                
                tempSwitchCell.topTitleLabel.text = tempModel.title;
                tempSwitchCell.descriptionLabel.text = tempModel.descriptionContent;
                [tempSwitchCell.rightSwitch setOn:tempModel.isSelected];
                tempSwitchCell.lineView.hidden = !tempModel.isShowDescription;
                tempSwitchCell.descriptionLabel.hidden = !tempModel.isShowDescription;
                tempSwitchCell.userInteractionEnabled = !tempModel.isDisable;
                if (tempModel.isDisable) {
                    tempSwitchCell.topTitleLabel.textColor = [UIColor lightGrayColor];
                }else {
                    tempSwitchCell.topTitleLabel.textColor = [UIColor blackColor];
                }
                return tempSwitchCell;
            }
                break;
            case WarmIMTestOptionItemModelTypePick: {
                WarmIMTestTableViewPickCell *tempPickCell = [tableView dequeueReusableCellWithIdentifier:@"WarmIMTestTableViewPickCell"];
                if (!tempPickCell) {
                    tempPickCell = [[WarmIMTestTableViewPickCell alloc]initWithReuseIdentifier:@"WarmIMTestTableViewPickCell"];
                    tempPickCell.delegate = self;
                }
                tempPickCell.topTitleLabel.text = tempModel.title;
                tempPickCell.descriptionLabel.text = tempModel.descriptionContent;
                tempPickCell.lineView.hidden = !tempModel.isShowDescription;
                tempPickCell.descriptionLabel.hidden = !tempModel.isShowDescription;
                tempPickCell.pickViewData = tempModel.pickViewData;
                [tempPickCell.pickView reloadAllComponents];
                [tempPickCell.pickView selectRow:tempModel.selectedNumber - 1 inComponent:0 animated:NO];
                tempPickCell.userInteractionEnabled = !tempModel.isDisable;
                if (tempModel.isDisable) {
                    tempPickCell.topTitleLabel.textColor = [UIColor lightGrayColor];
                }else {
                    tempPickCell.topTitleLabel.textColor = [UIColor blackColor];
                }
                return tempPickCell;
            }
                break;
        }
    }else {
        WarmIMTestTableViewShowCell *tempShowCell = [tableView dequeueReusableCellWithIdentifier:@"WarmIMTestTableViewShowCell"];
        if (!tempShowCell) {
            tempShowCell = [[WarmIMTestTableViewShowCell alloc]initWithReuseIdentifier:@"WarmIMTestTableViewShowCell"];
        }
        tempShowCell.mainLabel.text = @"展示图片选择";
        return tempShowCell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark - WarmIMImagePickerManagerDelegate

// 权限请求失败的代理
- (void)requestPhotoLibraryAuthorizationFailed:(NSInteger)status {
    if (status == 1) { // 限制
        UIAlertController *tempAlertController = [UIAlertController alertControllerWithTitle:@"没有相册权限" message:@"你的权限受到限制，请解除限制后再设置访问权限。" preferredStyle:UIAlertControllerStyleAlert];
        [tempAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:tempAlertController animated:YES completion:nil];
    }else {
        UIAlertController *tempAlertController = [UIAlertController alertControllerWithTitle:@"没有相册权限" message:@"WarmIM没有访问您相册的权限，请给予权限后再试。" preferredStyle:UIAlertControllerStyleAlert];
        [tempAlertController addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [tempAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:tempAlertController animated:YES completion:nil];
    }
}

- (void)WarmIMImagePickerShow {
    NSLog(@"展示了图片选择器");
}

- (void)WarmIMImagePickerDismiss {
    NSLog(@"隐藏了图片选择器");
}

// 选择了视频
- (void)WarmIMImagePickerSelectedVideo:(PHAsset *)videoAsset {
    
}

// 选择了图片
- (void)WarmIMImagePickerSelectedImages:(NSArray<WarmIMImagePickerAssetModel *> *)imageAssets {
    
}

#pragma mark - WarmIMTestTableViewPickCellDelegate
-(void)testTableViewPickCell:(WarmIMTestTableViewPickCell *)cell didSelectedRow:(NSInteger)row {
    NSIndexPath *tempIndexPath = [_tableview indexPathForCell:cell];
    WarmIMTestOptionItemModel *tempModel = _sourceData[tempIndexPath.row];
    if ([tempModel.title isEqualToString:@"图片的最大选择数量"]) {
        [WarmIMImagePickerManager sharedManager].imageCountMax = row + 1;
    }else {
        [WarmIMImagePickerManager sharedManager].lineNumber = row + 1;
    }
    tempModel.selectedNumber = row + 1;
    [self saveData:tempIndexPath.row key:tempModel.key];
}
#pragma mark - WarmIMTestTableViewSwitchCellDelegate
-(void)testTableViewSwitchCell:(WarmIMTestTableViewSwitchCell *)cell onState:(BOOL)isOn {
    NSIndexPath *tempIndexPath = [_tableview indexPathForCell:cell];
    WarmIMTestOptionItemModel *tempModel = _sourceData[tempIndexPath.row];
    if ([tempModel.title isEqualToString:@"直接跳转到内容列表"]) {
        [WarmIMImagePickerManager sharedManager].jumpAllPicturesView = isOn;
    }else if ([tempModel.title isEqualToString:@"显示空的相册"]) {
        [WarmIMImagePickerManager sharedManager].showEmptyAlbum = isOn;
    }else if ([tempModel.title isEqualToString:@"滑动选择"]) {
        [WarmIMImagePickerManager sharedManager].allowScrollSelect = isOn;
    }else if ([tempModel.title isEqualToString:@"显示“原图”"]) {
        [WarmIMImagePickerManager sharedManager].isShowSendSource = isOn;
    }else if ([tempModel.title isEqualToString:@"显示打开摄像头"]) {
        [WarmIMImagePickerManager sharedManager].isShowTakePhoto = isOn;
    }else if ([tempModel.title isEqualToString:@"顺序展示资源"]) {
        [WarmIMImagePickerManager sharedManager].showPicturesSequential = isOn;
    }else if ([tempModel.title isEqualToString:@"跟随自定义的导航栏颜色"]) {
        [WarmIMImagePickerManager sharedManager].isFollowCustomNavigation = isOn;
        WarmIMTestOptionItemModel *navigationBackgroundColorModel = _sourceData[11];
        navigationBackgroundColorModel.disable = isOn;
        WarmIMTestOptionItemModel *navigationTitleColorModel = _sourceData[12];
        navigationTitleColorModel.disable = isOn;
        [_tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:11 inSection:1], [NSIndexPath indexPathForRow:12 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
    tempModel.selected = isOn;
    [self saveData:tempIndexPath.row key:tempModel.key];
}

#pragma mark - WarmIMTestTableViewMoreCellDelegate
- (void)testTableViewMoreCellRightContentClicked:(WarmIMTestTableViewMoreCell *)cell {
    NSIndexPath *tempIndexPath = [_tableview indexPathForCell:cell];
    WarmIMTestOptionItemModel *tempModel = _sourceData[tempIndexPath.row];
    WarmIMAlertController *tempAlertController = [WarmIMAlertController alertControllerWithTitle:tempModel.title message:nil];
    WarmIMWeakSelf
    WarmIMWeak(tempModel)
    WarmIMWeak(_tableview)
    WarmIMWeak(tempIndexPath)
    if ([tempModel.title isEqualToString:@"可以选择的资源类型"]) {
        WarmIMAlertAction *tempAllAction = [WarmIMAlertAction actionWithTitle:@"所有" style:WarmIMAlertActionStyleDefault handler:^(WarmIMAlertAction * _Nonnull action) {
            [WarmIMImagePickerManager sharedManager].libraryType = WarmIMImagePickerTypeAll;
            WeaktempModel.selectedNumber = 0;
            WeaktempModel.selectedContent = @"所有";
            [Weak_tableview reloadRowsAtIndexPaths:@[WeaktempIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [WeakSelf saveData:WeaktempIndexPath.row key:WeaktempModel.key];
        }];
        [tempAlertController addAction:tempAllAction];
        WarmIMAlertAction *tempImageAction = [WarmIMAlertAction actionWithTitle:@"图片" style:WarmIMAlertActionStyleDefault handler:^(WarmIMAlertAction * _Nonnull action) {
            [WarmIMImagePickerManager sharedManager].libraryType = WarmIMImagePickerTypeImages;
            WeaktempModel.selectedNumber = 1;
            WeaktempModel.selectedContent = @"图片";
            [Weak_tableview reloadRowsAtIndexPaths:@[WeaktempIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [WeakSelf saveData:WeaktempIndexPath.row key:WeaktempModel.key];
        }];
        [tempAlertController addAction:tempImageAction];
        WarmIMAlertAction *tempVideoAction = [WarmIMAlertAction actionWithTitle:@"视频" style:WarmIMAlertActionStyleDefault handler:^(WarmIMAlertAction * _Nonnull action) {
            [WarmIMImagePickerManager sharedManager].libraryType = WarmIMImagePickerTypeVideo;
            WeaktempModel.selectedNumber = 2;
            WeaktempModel.selectedContent = @"视频";
            [Weak_tableview reloadRowsAtIndexPaths:@[WeaktempIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [WeakSelf saveData:WeaktempIndexPath.row key:WeaktempModel.key];
        }];
        [tempAlertController addAction:tempVideoAction];
    }else if ([tempModel.title isEqualToString:@"LivePhoto支持"]) {
        WarmIMAlertAction *tempStaticAction = [WarmIMAlertAction actionWithTitle:@"普通图片" style:WarmIMAlertActionStyleDefault handler:^(WarmIMAlertAction * _Nonnull action) {
            [WarmIMImagePickerManager sharedManager].livePhotoLevel = WarmIMImagePickerLivePhotoLevelTranslate;
            WeaktempModel.selectedNumber = 0;
            WeaktempModel.selectedContent = @"普通图片";
            [Weak_tableview reloadRowsAtIndexPaths:@[WeaktempIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [WeakSelf saveData:WeaktempIndexPath.row key:WeaktempModel.key];
        }];
        [tempAlertController addAction:tempStaticAction];
        WarmIMAlertAction *tempLiveAction = [WarmIMAlertAction actionWithTitle:@"Live Photo" style:WarmIMAlertActionStyleDefault handler:^(WarmIMAlertAction * _Nonnull action) {
            [WarmIMImagePickerManager sharedManager].livePhotoLevel = WarmIMImagePickerLivePhotoLevelNormal;
            WeaktempModel.selectedNumber = 2;
            WeaktempModel.selectedContent = @"Live Photo";
            [Weak_tableview reloadRowsAtIndexPaths:@[WeaktempIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [WeakSelf saveData:WeaktempIndexPath.row key:WeaktempModel.key];
        }];
        [tempAlertController addAction:tempLiveAction];
    }else if ([tempModel.title isEqualToString:@"导航栏颜色"] || [tempModel.title isEqualToString:@"导航栏内容颜色"]) {
        for (int i = 0;i<_colorData.count;i++) {
            WarmIMTestColorModel *tempColorModel = _colorData[i];
            WarmIMWeak(tempColorModel)
            WarmIMAlertAction *tempBlackAction = [WarmIMAlertAction actionWithTitle:tempColorModel.colorName style:WarmIMAlertActionStyleDefault handler:^(WarmIMAlertAction * _Nonnull action) {
                if ([WeaktempModel.title isEqualToString:@"导航栏颜色"]) {
                    [WarmIMImagePickerManager sharedManager].navigationBackgroundColor = WeaktempColorModel.color;
                }else {
                    [WarmIMImagePickerManager sharedManager].navigationTitleColor = WeaktempColorModel.color;
                }
                WeaktempModel.selectedNumber = WeaktempColorModel.index;
                WeaktempModel.selectedContent = WeaktempColorModel.colorName;
                [WeakSelf saveData:WeaktempIndexPath.row key:WeaktempModel.key];
                [Weak_tableview reloadRowsAtIndexPaths:@[WeaktempIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            tempBlackAction.backgroundColor = tempColorModel.color;
            tempBlackAction.tintColor = tempColorModel.inverseColor;
            [tempAlertController addAction:tempBlackAction];
        }
    }else if ([tempModel.title isEqualToString:@"iCloud"]) {
        WarmIMAlertAction *tempNotDownloadAction = [WarmIMAlertAction actionWithTitle:@"不下载资源" style:WarmIMAlertActionStyleDefault handler:^(WarmIMAlertAction * _Nonnull action) {
            [WarmIMImagePickerManager sharedManager].allowiCloudDownload = WarmIMImagePickeriCloudDownloadTypeNo;
            WeaktempModel.selectedNumber = 0;
            WeaktempModel.selectedContent = @"不下载资源";
            [Weak_tableview reloadRowsAtIndexPaths:@[WeaktempIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [WeakSelf saveData:WeaktempIndexPath.row key:WeaktempModel.key];
        }];
        [tempAlertController addAction:tempNotDownloadAction];
        WarmIMAlertAction *tempDownloadAllAction = [WarmIMAlertAction actionWithTitle:@"下载所有资源" style:WarmIMAlertActionStyleDefault handler:^(WarmIMAlertAction * _Nonnull action) {
            [WarmIMImagePickerManager sharedManager].allowiCloudDownload = WarmIMImagePickeriCloudDownloadTypeAny;
            WeaktempModel.selectedNumber = 1;
            WeaktempModel.selectedContent = @"下载所有资源";
            [Weak_tableview reloadRowsAtIndexPaths:@[WeaktempIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [WeakSelf saveData:WeaktempIndexPath.row key:WeaktempModel.key];
        }];
        [tempAlertController addAction:tempDownloadAllAction];
        WarmIMAlertAction *tempDownloadImageAction = [WarmIMAlertAction actionWithTitle:@"只下载图片" style:WarmIMAlertActionStyleDefault handler:^(WarmIMAlertAction * _Nonnull action) {
            [WarmIMImagePickerManager sharedManager].allowiCloudDownload = WarmIMImagePickeriCloudDownloadTypeImage;
            WeaktempModel.selectedNumber = 3;
            WeaktempModel.selectedContent = @"只下载图片";
            [Weak_tableview reloadRowsAtIndexPaths:@[WeaktempIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [WeakSelf saveData:WeaktempIndexPath.row key:WeaktempModel.key];
        }];
        [tempAlertController addAction:tempDownloadImageAction];
    }
    WarmIMAlertAction *tempCancelAction = [WarmIMAlertAction actionWithTitle:@"取消" style:WarmIMAlertActionStyleCancel handler:nil];
    [tempAlertController addAction:tempCancelAction];
    [self presentViewController:tempAlertController animated:YES completion:nil];
}


@end
