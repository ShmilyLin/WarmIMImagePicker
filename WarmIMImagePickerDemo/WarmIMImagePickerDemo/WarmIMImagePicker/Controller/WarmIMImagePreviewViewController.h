//
//  WarmIMImagePreviewViewController.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/17.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WarmIMImagePreviewViewControllerType) {
    WarmIMImagePreviewViewControllerTypeAll     = 0, // 预览所有图片
    WarmIMImagePreviewViewControllerTypeSelected = 1  // 预览选中图片
};

@protocol WarmIMImagePreviewViewControllerDelegate <NSObject>

@optional

- (void)WarmIMImagePreviewViewControllerDelegateSelectedChanged;

@end

@interface WarmIMImagePreviewViewController : UIViewController

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL forceTouch; // 是否是3DTouch进入页面

@property (nonatomic, weak) id<WarmIMImagePreviewViewControllerDelegate> delegate;

@property (nonatomic, assign) WarmIMImagePreviewViewControllerType type;

@end
