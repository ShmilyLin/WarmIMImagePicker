//
//  WarmIMBasicTabbarController.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/4/27.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMBasicTabbarController.h"
#import "WarmIMBasicNavigationController.h"

#import "WarmIMTestBasicViewController.h"
#import "WarmIMAboutBasicViewController.h"

@interface WarmIMBasicTabbarController ()

@end

@implementation WarmIMBasicTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubViews {
    // Test
    WarmIMTestBasicViewController *testBasicVC = [[WarmIMTestBasicViewController alloc]init];
    WarmIMBasicNavigationController *testNavigationVC = [[WarmIMBasicNavigationController alloc]initWithRootViewController:testBasicVC];
    UITabBarItem *testTabbarItem = [[UITabBarItem alloc]initWithTitle:[[WarmIMGlobal sharedGlobal] showText:@"Test"] image:[[UIImage imageNamed:@"WarmIM_tabbar_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"WarmIM_tabbar_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    testNavigationVC.tabBarItem = testTabbarItem;
    
    // About
    WarmIMAboutBasicViewController *aboutBasicVC = [[WarmIMAboutBasicViewController alloc]init];
    WarmIMBasicNavigationController *aboutNavigationVC = [[WarmIMBasicNavigationController alloc]initWithRootViewController:aboutBasicVC];
    UITabBarItem *aboutTabbarItem = [[UITabBarItem alloc]initWithTitle:[[WarmIMGlobal sharedGlobal] showText:@"About"] image:[UIImage imageNamed:@"WarmIM_tabbar_about"] selectedImage:[UIImage imageNamed:@"WarmIM_tabbar_about_selected"]];
    aboutNavigationVC.tabBarItem = aboutTabbarItem;
    
    [self setViewControllers:@[testNavigationVC, aboutNavigationVC] animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
