//
//  NSObject+model.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/21.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "NSObject+model.h"

#import <objc/runtime.h>

@implementation NSObject (model)

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    id tempClass = [[self alloc] init];
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self, &count);
    for (int i = 0 ; i < count; i++) {
        Ivar ivar = ivars[i];
        
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];

        NSString *propertyName = [ivarName substringFromIndex:1];
        if (dictionary[propertyName]) {
            id value = dictionary[propertyName];
            [tempClass setValue:value forKeyPath:ivarName];
        }
    }
    return tempClass;
}

- (NSDictionary *)translateToDictionary {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    unsigned int outCount;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:propertyName];
        if(value == nil) {
            value = [NSNull null];
        }else {
//            NSString *propertyAttributeName = [NSString stringWithUTF8String:property_getAttributes(properties[i])];
//            NSLog(@"属性类型：%@", propertyAttributeName);
//            NSString *tempPropertyAttributeName = [propertyAttributeName substringToIndex:2];
//            if ([tempPropertyAttributeName isEqualToString:@"TB"]) {
//                value = [NSNumber numberWithBool:value];
//            }else {
                value = [self getObjectInternal:value];
//            }
        }
        [tempDic setObject:value forKey:propertyName];
    }
    return (NSDictionary *)tempDic;
}

- (id)getObjectInternal:(id)obj {
    
    if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]]) {
        
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int i = 0; i < objarr.count; i++) {
            
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    if([obj isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys) {
            
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self translateToDictionary];
}

@end
