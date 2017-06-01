//
//  WarmIMTestTableViewMoreCell.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMTestTableViewMoreCell.h"

@implementation WarmIMTestTableViewMoreCell

#pragma mark - Init
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}


#pragma mark - UI
- (void)setupSubViews {
    if (!_rightArrow) {
        _rightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _rightArrow.translatesAutoresizingMaskIntoConstraints = NO;
        [_rightArrow setImage:[UIImage imageNamed:@"WarmIM_right_arrow_black"]];
        [self.contentView addSubview:_rightArrow];
    }
    if (!_rightContent) {
        _rightContent = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _rightContent.translatesAutoresizingMaskIntoConstraints = NO;
        _rightContent.textColor = [UIColor lightGrayColor];
        _rightContent.textAlignment = NSTextAlignmentRight;
        UITapGestureRecognizer *tempTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightContentClicked:)];
        [_rightContent addGestureRecognizer:tempTapGesture];
        _rightContent.userInteractionEnabled = YES;
        [self.contentView addSubview:_rightContent];
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
    // _rightArrow
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightArrow attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:15.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightArrow attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightArrow attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightArrow attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20.0]];
    
    // _rightContent
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightContent attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightContent attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_rightArrow attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-5.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightContent attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_rightContent attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width/2 - 40]];
    
    // _topTitleLabel
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_topTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_topTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_topTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_topTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width/2 - 10]];
    
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

#pragma mark - Action
- (void)rightContentClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(testTableViewMoreCellRightContentClicked:)]) {
        [self.delegate testTableViewMoreCellRightContentClicked:self];
    }
}


@end
