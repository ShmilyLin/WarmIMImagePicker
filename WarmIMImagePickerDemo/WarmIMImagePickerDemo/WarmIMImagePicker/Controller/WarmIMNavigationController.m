//
//  WarmIMNavigationController.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/19.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMNavigationController.h"

@interface WarmIMNavigationController ()

@end

@implementation WarmIMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
