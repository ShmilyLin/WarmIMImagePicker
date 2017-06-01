//
//  WarmIMImagePickerFetchResults.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/5.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

#import "WarmIMImagePickerCollectionModel.h"

@interface WarmIMImagePickerFetchResults : NSObject


@property (nonatomic, strong) PHFetchResult *systemFetchResult; // 系统自带
@property (nonatomic, strong) PHFetchResult *userFetchResult; // 用户创建

@property (nonatomic, strong) NSMutableArray<WarmIMImagePickerCollectionModel *> *collections; // 相簿数组



@end
