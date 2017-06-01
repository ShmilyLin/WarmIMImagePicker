//
//  WarmIMImagePickerAssetModel.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/5.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface WarmIMImagePickerAssetModel : NSObject

@property (nonatomic, strong) PHAsset *asset; // 对应的资源

@property (nonatomic, assign) BOOL selected; // 是否被选择

@property (nonatomic, assign) BOOL isSelectedOriginalImage; // 是否选择了原图

@property (nonatomic, assign, getter=isIniCloud) BOOL iniCloud; // 是否在iCloud上

@property (nonatomic, assign) BOOL isDownloading; // 是否正在下载

@property (nonatomic, assign) BOOL isDownload; // 下载完成

@property (nonatomic, assign) PHImageRequestID requestID; // 请求ID
@property (nonatomic, assign) BOOL downloadRequestID;

@end
