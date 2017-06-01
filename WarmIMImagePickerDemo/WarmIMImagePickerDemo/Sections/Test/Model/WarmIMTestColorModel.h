//
//  WarmIMTestColorModel.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/21.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WarmIMTestColorModel : NSObject

@property (nonatomic, strong) NSString *colorName;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) CGFloat red;

@property (nonatomic, assign) CGFloat blue;

@property (nonatomic, assign) CGFloat green;

@property (nonatomic, assign) UIColor *inverseColor;

- (void)setColorWithRGB;

@end
