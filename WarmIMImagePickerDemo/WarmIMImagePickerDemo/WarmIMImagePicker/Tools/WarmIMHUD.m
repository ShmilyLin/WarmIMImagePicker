//
//  WarmIMHUD.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/8.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMHUD.h"
#import "WarmIMHUDView.h"
#import "WarmIMImagePickerManager.h"

@interface WarmIMHUD()

@property (nonatomic, strong) WarmIMHUDView *backgroundView;

@property (nonatomic, strong) NSTimer *timer;



@end

@implementation WarmIMHUD


static WarmIMHUD *_instance;


#pragma mark - init
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        _instance = [super allocWithZone:zone];
        _instance.duration = 1.0f;
        _instance->_isShowing = NO;
    });
    return _instance;
}
+ (instancetype)sharedHUD {
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}


#pragma mark - functions
// 菊花提示框
- (void)showWarmIMHUD:(double)timeInterval {
    if (_isShowing && _backgroundView.type == WarmIMHUDViewTypeLoading) {
        [_backgroundView reloadWithInformation:nil];
    }else {
        [self dismissWarmIMHUDWithAnimated:NO];
        [self setupSubViews:WarmIMHUDViewTypeLoading information:nil];
    }
    
    if (timeInterval > 0) {
        [self startTimer:timeInterval];
    }
}

// 文字提示框
- (void)showWarmIMTitleHUD:(NSString *)title timeInterval:(double)timeInterval {
    if (_isShowing && _backgroundView.type == WarmIMHUDViewTypeText) {
        [_backgroundView reloadWithInformation:@{@"title":title}];
    }else {
        [self dismissWarmIMHUDWithAnimated:NO];
        [self setupSubViews:WarmIMHUDViewTypeText information:@{@"title":title}];
    }
    
    if (timeInterval > 0) {
        [self startTimer:timeInterval];
    }
}

// 文字和图片提示框
- (void)showWarmIMTitleHUD:(NSString *)title imageName:(NSString *)imageName timeInterval:(double)timeInterval {
    if (_isShowing && _backgroundView.type == WarmIMHUDViewTypeImageText) {
        [_backgroundView reloadWithInformation:@{@"title":title, @"image":imageName}];
    }else {
        [self dismissWarmIMHUDWithAnimated:NO];
        [self setupSubViews:WarmIMHUDViewTypeImageText information:@{@"title":title, @"image":imageName}];
    }
    if (timeInterval > 0) {
        [self startTimer:timeInterval];
    }
}

// 取消提示框
- (void)dismissWarmIMHUDWithAnimated:(BOOL)animated {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_backgroundView) {
        if (animated) {
            WarmIMWeakSelf;
            [UIView animateWithDuration:_duration animations:^{
                WeakSelf.backgroundView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                WarmIMStrongSelf;
                [StrongSelf.backgroundView removeFromSuperview];
                StrongSelf.backgroundView = nil;
            }];
        }else {
            [_backgroundView.activityIndicatorView stopAnimating];
            [_backgroundView removeFromSuperview];
            _backgroundView = nil;
        }
    }
}

// 初始化内部控件
- (void)setupSubViews:(WarmIMHUDViewType)type information:(NSDictionary *)info {
    if (!_backgroundView) {
        _backgroundView = [[WarmIMHUDView alloc] initWithType:type information:info];
        UITapGestureRecognizer *tempTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEvent:)];
        [_backgroundView addGestureRecognizer:tempTapGesture];
        UIWindow *tempWindow = [self getCurrentWindow];
        [tempWindow addSubview:_backgroundView];
        if (type == WarmIMHUDViewTypeLoading) {
            [_backgroundView.activityIndicatorView startAnimating];
        }
    }
}

// 开始计时
- (void)startTimer:(double)timeInterval {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerEvent) userInfo:nil repeats:NO];
    }
}
// 计时器事件
- (void)timerEvent {
    [self dismissWarmIMHUDWithAnimated:YES];
}

- (UIWindow *)getCurrentWindow {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }

    return window;
}

#pragma mark - actions
- (void)tapGestureEvent:(UIGestureRecognizer *)gesture {
    if (self.isTapDismiss) {
        if (_timer) {
            [self dismissWarmIMHUDWithAnimated:NO];
        }
    }
}

@end
