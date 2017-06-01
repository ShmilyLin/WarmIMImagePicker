//
//  WarmIMTestTableViewSwitchCell.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WarmIMTestTableViewSwitchCell;

@protocol WarmIMTestTableViewSwitchCellDelegate <NSObject>

@optional
-(void)testTableViewSwitchCell:(WarmIMTestTableViewSwitchCell *)cell onState:(BOOL)isOn;
@end

@interface WarmIMTestTableViewSwitchCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, weak) id<WarmIMTestTableViewSwitchCellDelegate> delegate;

@property (nonatomic, strong) UILabel *topTitleLabel;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UISwitch *rightSwitch;

@end
