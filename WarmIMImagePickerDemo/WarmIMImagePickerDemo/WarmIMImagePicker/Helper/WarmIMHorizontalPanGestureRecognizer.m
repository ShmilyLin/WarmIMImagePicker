//
//  WarmIMHorizontalPanGestureRecognizer.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/11.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMHorizontalPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

int const static kDirectionPanThreshold = 10;

@interface WarmIMHorizontalPanGestureRecognizer() {
    BOOL _drag;
    int _moveX;
    int _moveY;
}

@end

@implementation WarmIMHorizontalPanGestureRecognizer


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) {
        return;
    }
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    if (!_drag) {
        if (abs(_moveX) > kDirectionPanThreshold) {
            _drag = YES;
        }else if (abs(_moveY) > kDirectionPanThreshold) {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
}

- (void)reset {
    [super reset];
    _drag = NO;
    _moveX = 0;
    _moveY = 0;
}

@end
