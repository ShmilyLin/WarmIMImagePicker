//
//  UIViewController+WarmIMImagePicker.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/4/28.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "UIViewController+WarmIMImagePicker.h"

#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

//#import "WarmIMImagePickerManager.h"

#import "WarmIMNavigationController.h"
#import "WarmIMAlbumsListViewController.h"

@implementation UIViewController (WarmIMImagePicker) 

- (void)WarmIM_showImagePicker {
    NSLog(@"%ld",(long)[PHPhotoLibrary authorizationStatus]);
//    [[WarmIMImagePickerManager sharedManager] showPhotoLibrary];
    
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusNotDetermined: { // 未确定
            WarmIMWeakSelf;
            [[WarmIMImagePickerManager sharedManager] requestPhotoLibraryAuthorization:^{
                [WeakSelf showAlbumListViewController];
            }];
            break;
        }
        case PHAuthorizationStatusAuthorized: { // 允许
            [self showAlbumListViewController];
            break;
        }
        default: { // 拒绝／限制
            if ([[WarmIMImagePickerManager sharedManager].delegate respondsToSelector:@selector(requestPhotoLibraryAuthorizationFailed:)]) {
                [[WarmIMImagePickerManager sharedManager].delegate requestPhotoLibraryAuthorizationFailed:[PHPhotoLibrary authorizationStatus]];
            }
        }
            break;
    }
}


//- (void)registerWarmIMImagePickerDelegate {
//    [WarmIMImagePickerManager sharedManager].delegate = self;
//}

- (void)showAlbumListViewController {
    
    WarmIMAlbumsListViewController *albumsListVC = [[WarmIMAlbumsListViewController alloc]init];
    WarmIMNavigationController *albumsListNavigation = [[WarmIMNavigationController alloc]initWithRootViewController:albumsListVC];
    [[WarmIMImagePickerManager sharedManager] showPhotoLibrary];
    [self presentViewController:albumsListNavigation animated:YES completion:nil];
}


@end
