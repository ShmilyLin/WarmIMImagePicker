//
//  WarmIMAlertAction.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMAlertAction.h"

@interface WarmIMAlertAction ()

@end

@implementation WarmIMAlertAction

- (instancetype)initWithTitle:(NSString *)title style:(WarmIMAlertActionStyle)style handler:(void (^ __nullable)(WarmIMAlertAction * _Nonnull action))handler {
    if (self = [super init]) {
        _height = 44.0;
        _title = title;
        _style = style;
        _enabled = YES;
        _actionHandler = handler;
        switch (style) {
            case WarmIMAlertActionStyleDefault: {
                _backgroundColor = [UIColor whiteColor];
                _tintColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1.0];
            }
                break;
            case WarmIMAlertActionStyleCancel: {
                _backgroundColor = [UIColor whiteColor];
                _tintColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1.0];
            }
                break;
            case WarmIMAlertActionStyleDestructive: {
                _backgroundColor = [UIColor whiteColor];
                _tintColor = [UIColor redColor];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

+ (instancetype _Nonnull)actionWithTitle:(nullable NSString *)title style:(WarmIMAlertActionStyle)style handler:(void (^ __nullable)(WarmIMAlertAction * _Nonnull action))handler {
    WarmIMAlertAction *action = [[WarmIMAlertAction alloc]initWithTitle:title style:style handler:handler];
    return action;
}

- (UIView *)addViewToAction {
    return nil;
}

@end
