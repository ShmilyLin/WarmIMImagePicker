//
//  WarmIMTestTableViewPickCell.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMTestTableViewPickCell.h"

@interface WarmIMTestTableViewPickCell() <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation WarmIMTestTableViewPickCell
#pragma mark - Init
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        _pickViewData = @[];
        [self setupSubViews];
    }
    return self;
}

#pragma mark - UI
- (void)setupSubViews {
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
    if (!_pickView) {
        _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 10, 80, 60)];
        _pickView.translatesAutoresizingMaskIntoConstraints = NO;
        _pickView.delegate = self;
        _pickView.dataSource = self;
        [self.contentView addSubview:_pickView];
    }
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pickView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pickView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pickView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pickView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80.0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_topTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_topTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_pickView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_topTitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_topTitleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_pickView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-10.0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_pickView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150.0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_lineView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.0]];
}

#pragma mark - UIPickerViewDelegate

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    
//}
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
//    
//}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _pickViewData[row];
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    
//}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([self.delegate respondsToSelector:@selector(testTableViewPickCell:didSelectedRow:)]) {
        [self.delegate testTableViewPickCell:self didSelectedRow:row];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickViewData.count;
}

@end
