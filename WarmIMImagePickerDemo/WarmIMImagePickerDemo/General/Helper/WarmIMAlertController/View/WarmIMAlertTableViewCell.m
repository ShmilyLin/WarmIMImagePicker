//
//  WarmIMAlertTableViewCell.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMAlertTableViewCell.h"

@implementation WarmIMAlertTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark - UI

- (void)setupSubViews {
    if (!_mainLabel) {
        _mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _mainLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _mainLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_mainLabel];
    }
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_mainLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_mainLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_mainLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_mainLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
}
@end
