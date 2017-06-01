//
//  WarmIMTestTableViewMoreCell.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WarmIMTestTableViewMoreCell;
@protocol WarmIMTestTableViewMoreCellDelegate <NSObject>

@optional
- (void)testTableViewMoreCellRightContentClicked:(WarmIMTestTableViewMoreCell *)cell;

@end

@interface WarmIMTestTableViewMoreCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, weak) id<WarmIMTestTableViewMoreCellDelegate> delegate;

@property (nonatomic, strong) UILabel *topTitleLabel;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UIImageView *rightArrow;

@property (nonatomic, strong) UILabel *rightContent;

@end
