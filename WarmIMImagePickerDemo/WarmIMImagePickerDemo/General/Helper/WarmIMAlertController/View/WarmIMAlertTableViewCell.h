//
//  WarmIMAlertTableViewCell.h
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarmIMAlertTableViewCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) UILabel *mainLabel;

@end
