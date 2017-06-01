//
//  NSObject+model.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/21.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (model)

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)translateToDictionary;

@end
