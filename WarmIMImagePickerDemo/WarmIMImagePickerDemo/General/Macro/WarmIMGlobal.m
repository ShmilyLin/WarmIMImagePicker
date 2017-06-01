//
//  WarmIMGlobal.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/4/30.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMGlobal.h"


@interface WarmIMGlobal () {
    NSString *_localized; // 设置语言
}

@end


@implementation WarmIMGlobal


static WarmIMGlobal *_instance;


#pragma mark - init
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedGlobal {
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        _instance = [[self alloc] init];
//        NSString *tempLocalized = [[NSUserDefaults standardUserDefaults] objectForKey:@"WarmIM_Localized"];
//        if (!tempLocalized) {
//            _instance.localized = WarmIMCurrentLanguage;
//        }else {
//            _instance.localized = tempLocalized;
//        }
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"WarmIM_Localized"];
        NSString *tempLocalized = [[NSUserDefaults standardUserDefaults] objectForKey:@"WarmIM_Localized"];
        if (!tempLocalized) {
            NSString *tempLanguage = WarmIMCurrentLanguage;
            NSLog(@"当前的语言：%@", tempLanguage);
            if ([tempLanguage isEqual: @"zh-Hans-US"] || [tempLanguage isEqual: @"zh-Hans-CN"]) {
                _localized = @"zh-Hans";
            }else {
                _localized = @"en";
            }
        }else {
            _localized = tempLocalized;
        }
    }
    return self;
}

#pragma mark - set & get

- (void)setLocalized:(NSString *)localized {
    if (_localized != localized) {
        _localized = localized;
        [[NSUserDefaults standardUserDefaults] setObject:_localized forKey:@"WarmIM_Localized"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // TODO: 代理过去重载页面
    }
}

- (NSString *)getLocalized {
    return _localized;
}


#pragma mark - Language

-(NSString *)showText:(NSString *)key {
    NSString *path = [[NSBundle mainBundle] pathForResource:_localized ofType:@"lproj"];
    return [[NSBundle bundleWithPath:path] localizedStringForKey:key value:nil table:@"WarmIMLocalizable"];
}

@end
