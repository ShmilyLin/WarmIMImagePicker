//
//  WarmIMTestOptionItemModel.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMTestOptionItemModel.h"

@implementation WarmIMTestOptionItemModel

#pragma mark - Init
- (instancetype)initWithTitle:(NSString *)title type:(WarmIMTestOptionItemModelType)type {
    if (self = [super init]) {
        self.title = title;
        self.type = type;
        _descriptionContent = [NSString string];
        _descriptionHeight = 0;
        self.disable = NO;
        self.showDescription = NO;
        self.selectedNumber = 0;
        self.selected = NO;
        self.selectedContent = [NSString string];
        self.pickViewData = [NSArray array];
    }
    return self;
}


#pragma mark - Functions
- (void)setDescriptionContent:(NSString *)description {
    if (_descriptionContent != description) {
        _descriptionContent = description;
        [self calculateDescriptionHeight];
    }
}

- (void)calculateDescriptionHeight {
    _descriptionHeight = [self boundingALLRectWithSize:_descriptionContent Font:[UIFont systemFontOfSize:14] Size:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 0)].height + 65.5;
    if (_type == WarmIMTestOptionItemModelTypePick) {
        _descriptionHeight += 50;
    }
}

- (CGSize)boundingALLRectWithSize:(NSString*)txt Font:(UIFont*)font Size:(CGSize)size {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:txt];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:2.0f];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [txt length])];
    
    CGSize realSize = CGSizeZero;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    CGRect textRect = [txt boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} context:nil];
    realSize = textRect.size;
#else
    realSize = [txt sizeWithFont:font constrainedToSize:size];
#endif
    
    realSize.width = ceilf(realSize.width);
    realSize.height = ceilf(realSize.height);
    return realSize;
}

@end
