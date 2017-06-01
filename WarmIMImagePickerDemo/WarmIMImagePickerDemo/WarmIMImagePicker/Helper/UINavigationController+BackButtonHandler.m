//
//  UINavigationController+BackButtonHandler.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/19.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "UINavigationController+BackButtonHandler.h"


@implementation UINavigationController (BackButtonHandler)


- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    if ([[self topViewController] conformsToProtocol:@protocol(WarmIMNavigationControllerBackHanderDelegate)]) {
        BOOL shouldPop = YES;
        if([(UIViewController<WarmIMNavigationControllerBackHanderDelegate> *)[self topViewController] respondsToSelector:@selector(navigationControllerShouldPopOnBackButton)]) {
            shouldPop = [(UIViewController<WarmIMNavigationControllerBackHanderDelegate> *)[self topViewController] navigationControllerShouldPopOnBackButton];
        }
        if(shouldPop) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self popViewControllerAnimated:YES];
            });
        } else {
            for(UIView *subview in [navigationBar subviews]) {
                if(0. < subview.alpha && subview.alpha < 1.) {
                    [UIView animateWithDuration:.25 animations:^{
                        subview.alpha = 1.;
                    }];
                }
            }
        }
        return NO;
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
        return YES;
    }
}

@end
