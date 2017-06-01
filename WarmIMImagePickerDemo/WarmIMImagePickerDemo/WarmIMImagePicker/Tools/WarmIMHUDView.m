//
//  WarmIMHUDView.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/8.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMHUDView.h"

@interface WarmIMHUDView()


@property (nonatomic, strong) NSDictionary *info;

@end

@implementation WarmIMHUDView

#pragma mark - Init
- (instancetype)initWithType:(WarmIMHUDViewType)type information:(NSDictionary *)info {
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)]) {
        _type = type;
        _info = info;
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)]) {
        _type = WarmIMHUDViewTypeLoading;
        [self setupSubViews];
    }
    return self;
}

#pragma mark - UI

- (void)setupSubViews {
    
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _backgroundView.layer.cornerRadius = 8;
        _backgroundView.layer.masksToBounds = YES;
        [self addSubview:_backgroundView];
    }
    
    switch (_type) {
        case WarmIMHUDViewTypeLoading: {
            if (!_activityIndicatorView) {
                _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
                [self addSubview:_activityIndicatorView];
            }
        }
            break;
        case WarmIMHUDViewTypeText: {
            if (!_titleLabel) {
                _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
                _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
                _titleLabel.numberOfLines = 0;
                _titleLabel.textColor = [UIColor whiteColor];
                _titleLabel.text = [_info objectForKey:@"title"];
                [self addSubview:_titleLabel];
            }
        }
            break;
        case WarmIMHUDViewTypeImageText: {
            if (!_tipImageView) {
                _tipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
                _tipImageView.contentMode = UIViewContentModeCenter;
                _tipImageView.translatesAutoresizingMaskIntoConstraints = NO;
                [_tipImageView setImage:[UIImage imageNamed:[_info objectForKey:@"image"]]];
                [self addSubview:_tipImageView];
            }
            if (!_titleLabel) {
                _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
                _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
                _titleLabel.numberOfLines = 0;
                _titleLabel.textColor = [UIColor whiteColor];
                _titleLabel.text = [_info objectForKey:@"title"];
                [self addSubview:_titleLabel];
            }
        }
            break;
        default:
            break;
    }
    
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    
    
    switch (_type) {
        case WarmIMHUDViewTypeLoading: {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
            
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_activityIndicatorView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        }
            break;
        case WarmIMHUDViewTypeText: {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
            NSLayoutConstraint *titleLabelLayoutConstraintWidth = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width - 100 - 40];
            [self addConstraint:titleLabelLayoutConstraintWidth];
            NSLayoutConstraint *titleLabelLayoutConstraintHeight = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.height - 100 - 40];
            [self addConstraint:titleLabelLayoutConstraintHeight];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeWidth multiplier:1.0 constant:100]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeHeight multiplier:1.0 constant:60]];
        }
            break;
        case WarmIMHUDViewTypeImageText: {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
            NSLayoutConstraint *titleLabelLayoutConstraintWidth = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width - 100 - 40];
            [self addConstraint:titleLabelLayoutConstraintWidth];
            NSLayoutConstraint *titleLabelLayoutConstraintHeight = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.height - 70 - 40 - 50 - 10];
            [self addConstraint:titleLabelLayoutConstraintHeight];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:30]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_tipImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_tipImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:-10.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_tipImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_tipImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_tipImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-5.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeWidth multiplier:1.0 constant:100]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeHeight multiplier:1.0 constant:60+50+10]];
        }
            break;
        default:
            break;
    }
    
    
}

- (void)reloadWithInformation:(NSDictionary *)info {
    _info = info;
    switch (_type) {
        case WarmIMHUDViewTypeText: {
            if (_titleLabel) {
                _titleLabel.text = [_info objectForKey:@"title"];
            }
        }
            break;
        case WarmIMHUDViewTypeImageText: {
            if (_tipImageView) {
                [_tipImageView setImage:[UIImage imageNamed:[_info objectForKey:@"image"]]];
            }
            if (_titleLabel) {
                _titleLabel.text = [_info objectForKey:@"title"];
            }
        }
            break;
        default:
            break;
    }
}


@end
