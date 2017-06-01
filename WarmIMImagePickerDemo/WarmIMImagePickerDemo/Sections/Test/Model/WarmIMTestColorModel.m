//
//  WarmIMTestColorModel.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/21.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMTestColorModel.h"

@implementation WarmIMTestColorModel

- (void)setColorWithRGB {
    _color = [UIColor colorWithRed:_red/255.0 green:_green/255.0 blue:_blue/255.0 alpha:1.0];
    if (_red > 200 && _green > 200 && _blue > 200) {
        _inverseColor = [UIColor blackColor];
    }else {
        _inverseColor = [UIColor whiteColor];
    }
}

@end
