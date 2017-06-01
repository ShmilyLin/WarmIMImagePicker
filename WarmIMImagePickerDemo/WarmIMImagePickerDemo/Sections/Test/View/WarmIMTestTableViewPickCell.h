//
//  WarmIMTestTableViewPickCell.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WarmIMTestTableViewPickCell;

@protocol WarmIMTestTableViewPickCellDelegate <NSObject>

@optional
-(void)testTableViewPickCell:(WarmIMTestTableViewPickCell *)cell didSelectedRow:(NSInteger)row;

@end

@interface WarmIMTestTableViewPickCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, weak) id<WarmIMTestTableViewPickCellDelegate> delegate;

@property (nonatomic, strong) UILabel *topTitleLabel;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UIPickerView *pickView;

@property (nonatomic, strong) NSArray *pickViewData;

@end
