//
//  WarmIMAboutBasicViewController.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/4/27.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMAboutBasicViewController.h"

#import "WarmIMImagePickerCollectionViewLayout.h"

#import "WarmIMHUD.h"

@interface WarmIMAboutBasicViewController ()

@end

@implementation WarmIMAboutBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [[WarmIMGlobal sharedGlobal] showText:@"About"];
    
    UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tempButton setTitle:@"测试" forState:UIControlStateNormal];
    [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    tempButton.frame = CGRectMake(100, 100, 100, 100);
    tempButton.layer.borderColor = [UIColor blueColor].CGColor;
    tempButton.layer.borderWidth = 1;
    tempButton.layer.cornerRadius = 5;
    tempButton.layer.masksToBounds = YES;
    [tempButton addTarget:self action:@selector(tempButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)tempButtonClicked:(UIButton *)sender {
    
}


@end
