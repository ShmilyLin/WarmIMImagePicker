//
//  WarmIMGlobal.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/4/30.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WarmIMGlobal : NSObject

+ (instancetype)sharedGlobal;

- (void)setLocalized:(NSString *)localized; // 设置语言
- (NSString *)getLocalized; // 获取当前设置的语言
-(NSString *)showText:(NSString *)key; // 请求对应语言的文字

@end
