//
//  WarmIMImagePickerAlbumTableViewCell.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/4/30.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMImagePickerAlbumTableViewCell.h"

@implementation WarmIMImagePickerAlbumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews {
    
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 1, 58, 58)];
        _logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _logoImageView.clipsToBounds = YES;
    }
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 100, 60)];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.numberOfLines = 0;
    }
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 0, 100, 60)];
        _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _countLabel.numberOfLines = 0;
        _countLabel.textColor = [UIColor lightGrayColor];
    }
    if (!_rightArrowImageView) {
        _rightArrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _rightArrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_rightArrowImageView setImage:[UIImage imageNamed:@"WarmIM_right_arrow_black"]];
    }
    
    [self.contentView addSubview:_logoImageView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_countLabel];
    [self.contentView addSubview:_rightArrowImageView];
    
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    
    // _logoImageView
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:1.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-1.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_logoImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_logoImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    
    // _rightArrowImageView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightArrowImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightArrowImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightArrowImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightArrowImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:10.0]];
    
    // _nameLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_logoImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:10.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_logoImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width - 80 - 30 - 5 - 100]];
    
    // _countLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_nameLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:5.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_nameLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_countLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0]];
}

@end
