//
//  WarmIMTestTableViewDefaultCell.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMTestTableViewDefaultCell.h"

@implementation WarmIMTestTableViewDefaultCell

#pragma mark - Init
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark - UI
- (void)setupSubViews {
    
    [self setupSubViewConstraints];
}

- (void)setupSubViewConstraints {
    
}
@end
