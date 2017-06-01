//
//  UINavigationController+BackButtonHandler.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/19.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WarmIMNavigationControllerBackHanderDelegate <NSObject>

-(BOOL)navigationControllerShouldPopOnBackButton;

@end

@interface UINavigationController (BackButtonHandler) <WarmIMNavigationControllerBackHanderDelegate>

@end
