//
//  WarmIMVideoPreviewViewController.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/18.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMVideoPreviewViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "WarmIMImagePickerManager.h"

#import "WarmIMImagePickerVideoPreviewBottomView.h"

#import "WarmIMHUD.h"

@interface WarmIMVideoPreviewViewController () {
    NSInteger is3DTouchInViewWillAppear;
}

@property (nonatomic, strong) UIView *progressBackgroundView;
@property (nonatomic, strong) UIView *progressFrontView;
@property (nonatomic, strong) NSLayoutConstraint *progressFrontViewLayoutConstraintWidth;
@property (nonatomic, strong) NSLayoutConstraint *progressBackgroundViewLayoutConstraintBottom;

@property (nonatomic, strong) WarmIMImagePickerVideoPreviewBottomView *bottomView;

@property (nonatomic, strong) UIView *playerView;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *videoItem;

@property (nonatomic, strong) AVPlayerLayer * playerLayer;

@property (nonatomic, strong) id timeObserverToken;

@end

@implementation WarmIMVideoPreviewViewController


#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupSubViews];
    [self dealData];
    [self addKVO];
    [self addNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"WarmIMVideoPreviewViewController 页面收到内存警告");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGRect rect = CGRectMake(0.0f, 0.0f, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.0 alpha:0.5].CGColor);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:theImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    if (is3DTouchInViewWillAppear < 2) {
        if (!_forceTouch && is3DTouchInViewWillAppear == 0) {
            _bottomView.hidden = NO;
            _progressBackgroundViewLayoutConstraintBottom.constant = -60;
            [self setNeedsStatusBarAppearanceUpdate];
        }
        if (_forceTouch && is3DTouchInViewWillAppear == 1) {
            _bottomView.hidden = NO;
            _progressBackgroundViewLayoutConstraintBottom.constant = -60;
            [self setNeedsStatusBarAppearanceUpdate];
        }
        is3DTouchInViewWillAppear++;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    if (![WarmIMImagePickerManager sharedManager].isFollowCustomNavigation) {
        CGRect rect = CGRectMake(0.0f, 0.0f, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [WarmIMImagePickerManager sharedManager].navigationBackgroundColor.CGColor);
        CGContextFillRect(context, rect);
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.navigationController.navigationBar setBackgroundImage:theImage forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[WarmIMImagePickerManager sharedManager].navigationTitleColor,NSForegroundColorAttributeName,nil]];
        
        [self.navigationController.navigationBar setTintColor:[WarmIMImagePickerManager sharedManager].navigationTitleColor];
    }else {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:nil];
        [self.navigationController.navigationBar setTintColor:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.playerLayer.frame = _playerView.bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return _bottomView.hidden;
}

- (void)dealloc {
    NSLog(@"WarmIMVideoPreviewViewController dealloc");
    if (_timeObserverToken) {
        [_player removeTimeObserver:_timeObserverToken];
        _timeObserverToken = nil;
    }
    [self removeKVO];
    [self removeNotification];
//    if (_playerLayer) {
//        [_playerLayer removeFromSuperlayer];
//        _playerLayer = nil;
//    }
//    if (_player) {
//        _player = nil;
//    }
//    if (_videoItem) {
//        _videoItem = nil;
//    }
}

#pragma mark - UI

- (void)setupSubViews {
    if (!_playerView) {
        _playerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//        _playerView.backgroundColor = [UIColor greenColor];
        UITapGestureRecognizer *playerViewTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playerViewtapped:)];
        [_playerView addGestureRecognizer:playerViewTapGesture];
        [self.view addSubview:_playerView];
        if (!_player) {
            _player = [[AVPlayer alloc]init];
            WarmIMWeakSelf
            self.timeObserverToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                float current = CMTimeGetSeconds(time);
                NSLog(@"当前已经播放%.2fs.",current);
                float total = CMTimeGetSeconds(WeakSelf.videoItem.duration);
                if (current) {
                    WeakSelf.progressFrontViewLayoutConstraintWidth.constant = [UIScreen mainScreen].bounds.size.width * (current/total);
//                    [WeakSelf.view layoutIfNeeded];
                }
            }];
        }
        if (!_playerLayer) {
            _playerLayer = [[AVPlayerLayer alloc]init];
            _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
            _playerLayer.frame = _playerView.frame;
            _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            [_playerLayer setPlayer:_player];
            [_playerView.layer insertSublayer:_playerLayer atIndex:0];
        }
    }
    if (!_progressBackgroundView) {
        _progressBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _progressBackgroundView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.4];
        _progressBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_progressBackgroundView];
        if (!_progressFrontView) {
            _progressFrontView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            _progressFrontView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
//            _progressFrontView.backgroundColor = [UIColor redColor];
            _progressFrontView.translatesAutoresizingMaskIntoConstraints = NO;
            [_progressBackgroundView addSubview:_progressFrontView];
        }
    }
    if (!_bottomView) {
        _bottomView = [[WarmIMImagePickerVideoPreviewBottomView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _bottomView.hidden = YES;
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        [_bottomView.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.determineButton addTarget:self action:@selector(determineButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bottomView];
    }
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_progressBackgroundView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_progressBackgroundView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    _progressBackgroundViewLayoutConstraintBottom = [NSLayoutConstraint constraintWithItem:_progressBackgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.view addConstraint:_progressBackgroundViewLayoutConstraintBottom];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_progressBackgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:3.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_progressFrontView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_progressBackgroundView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_progressFrontView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_progressBackgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_progressFrontView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_progressBackgroundView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    _progressFrontViewLayoutConstraintWidth = [NSLayoutConstraint constraintWithItem:_progressFrontView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.0];
    [self.view addConstraint:_progressFrontViewLayoutConstraintWidth];
}

#pragma mark - Data

- (void)dealData {
    [[WarmIMHUD sharedHUD] showWarmIMHUD:0];
//    WarmIMWeakSelf
    WarmIMWeakSelf
    [[WarmIMImagePickerManager sharedManager].cachingImageManager requestPlayerItemForVideo:[WarmIMImagePickerManager sharedManager].currenDisplayModel.asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (playerItem) {
                WeakSelf.videoItem = playerItem;
                if (!WeakSelf.player) {
                    WeakSelf.player = [[AVPlayer alloc]initWithPlayerItem:WeakSelf.videoItem];
                }else {
                    [WeakSelf.player replaceCurrentItemWithPlayerItem:WeakSelf.videoItem];
                }
                [[WarmIMHUD sharedHUD] dismissWarmIMHUDWithAnimated:YES];
            }else {
                //TODO: 获取资源错误
                NSLog(@"获取资源错误");
                [[WarmIMHUD sharedHUD] showWarmIMTitleHUD:@"资源不存在。" imageName:@"WarmIM_error_tip" timeInterval:1.0];
            }
        });
    }];
}

#pragma mark - KVO

- (void)addKVO {
    // 是否可以播放
    [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 播放速率
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"status"]) {
//        AVPlayerStatus tempStatus = [self.player valueForKey:@"status"];
//        if () {
//            
//        }
    }else if ([keyPath isEqualToString:@"rate"]) {
        if ([[self.player valueForKey:@"rate"] floatValue] == 0.0) {
            _bottomView.playButton.selected = NO;
//            [self.player seekToTime:kCMTimeZero];
            _progressFrontViewLayoutConstraintWidth.constant = 0.0;
            if (_bottomView.hidden) {
                _bottomView.hidden = NO;
                self.navigationController.navigationBar.hidden = NO;
                _progressBackgroundViewLayoutConstraintBottom.constant = -60;
                [self setNeedsStatusBarAppearanceUpdate];
            }
            
        }
    }
}

- (void)removeKVO {
    [self.player removeObserver:self forKeyPath:@"status"];
    [self.player removeObserver:self forKeyPath:@"rate"];
}



#pragma mark - Notification

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Functions
// 视频播放完毕的通知
-(void)playbackFinished:(NSNotification *)notification{
    [self.player seekToTime:kCMTimeZero];
}

#pragma mark - Actions
// 单击播放页面
- (void)playerViewtapped:(UITapGestureRecognizer *)gesture {
    _bottomView.hidden = !_bottomView.isHidden;
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.isHidden;
    if (_bottomView.isHidden) {
        _progressBackgroundViewLayoutConstraintBottom.constant = 0;
    }else {
        _progressBackgroundViewLayoutConstraintBottom.constant = -60;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}
// 点击取消
- (void)cancelButtonClicked:(UIButton *)sender {
    [self.player pause];
    [self.navigationController popViewControllerAnimated:YES];
}

// 点击播放
- (void)playButtonClicked:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
        [self.player pause];
    }else {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            sender.selected = YES;
            [self.player play];
        }
    }
}

// 点击选择
- (void)determineButtonClicked:(UIButton *)sender {
    [self.player pause];
    if ([[WarmIMImagePickerManager sharedManager].delegate respondsToSelector:@selector(WarmIMImagePickerSelectedVideo:)]) {
        [[WarmIMImagePickerManager sharedManager].delegate WarmIMImagePickerSelectedVideo:[WarmIMImagePickerManager sharedManager].selectedVideoModel.asset];
    }
    [[WarmIMImagePickerManager sharedManager] dismissPhotoLibrary];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
