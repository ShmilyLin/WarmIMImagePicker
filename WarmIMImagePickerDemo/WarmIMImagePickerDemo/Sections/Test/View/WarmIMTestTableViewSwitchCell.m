//
//  WarmIMTestTableViewSwitchCell.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMTestTableViewSwitchCell.h"

@implementation WarmIMTestTableViewSwitchCell

#pragma mark - Init
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark - UI
- (void)setupSubViews {
    if (!_rightSwitch) {
        _rightSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _rightSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        [_rightSwitch addTarget:self action:@selector(rightSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rightSwitch];
    }
    if (!_topTitleLabel) {
        _topTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _topTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _topTitleLabel.numberOfLines = 1;
        [self.contentView addSubview:_topTitleLabel];
    }
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _lineView.hidden = YES;
        _lineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        _lineView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_lineView];
    }
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.font = [UIFont systemFontOfSize:14];
        _descriptionLabel.textColor = [UIColor lightGrayColor];
        _descriptionLabel.hidden = YES;
        [self.contentView addSubview:_descriptionLabel];
    }
    
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    // _rightSwitch
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightSwitch attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightSwitch attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightSwitch attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightSwitch attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    
    // _topTitleLabel
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_topTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_topTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_rightSwitch attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_topTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_rightSwitch attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_topTitleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_rightSwitch attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-10.0]];
    
    // _lineView
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_topTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150.0]];
    
    // _descriptionLabel
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_lineView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.0]];
}

#pragma mark - Functions

#pragma mark - Actions

- (void)rightSwitchAction:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(testTableViewSwitchCell:onState:)]) {
        [self.delegate testTableViewSwitchCell:self onState:sender.isOn];
    }
}
@end
