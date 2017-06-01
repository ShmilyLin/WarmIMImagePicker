//
//  WarmIMImagePickerCollectionViewLayout.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/11.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMImagePickerCollectionViewLayout.h"

@interface WarmIMImagePickerCollectionViewLayout()

@property (nonatomic, strong) NSMutableArray *attributesArray; // 布局对象数组
@property (nonatomic, strong) NSMutableArray *allAttributesArray; // 布局对象数组
@property (nonatomic, weak) id<WarmIMImagePickerCollectionViewLayoutDelegate> delegate; // 代理

@property (nonatomic, assign) CGFloat collectionContentHeight;
@property (nonatomic, assign) CGFloat collectionContentWidth;

@property (nonatomic, assign) NSInteger currentItemCountInLine; // 每行的Item的数量
@property (nonatomic, assign) CGFloat currentItemSpacing; // 当前的每个Item之间的距离

@end
@implementation WarmIMImagePickerCollectionViewLayout

// 布局首次被加载时
- (void)prepareLayout {
    [super prepareLayout];

    
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    if (!_allAttributesArray) {
        _allAttributesArray = [NSMutableArray array];
    }
    
    if (!self.delegate) {
        if ([self.collectionView.delegate conformsToProtocol:@protocol(WarmIMImagePickerCollectionViewLayoutDelegate)]) {
            self.delegate = (id<WarmIMImagePickerCollectionViewLayoutDelegate>)self.collectionView.delegate;
        }else {
            return;
        }
    }
    
    // 内容大小
    _collectionContentWidth = self.collectionView.bounds.size.width;
    _collectionContentHeight = 0;
    
    // Section数量
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
//    // 行数
//    NSInteger _tempLineNumber = 0;
//    // 当前行的宽度
//    CGFloat _tempCurrentLineWidth = 0;
//    // 当前行的Cell数量
//    NSInteger _tempCurrentLineCellNum = 0;
//    // 当前行的最大高度
//    CGFloat _tempCurrentLineMaxHeight = 0;
    
    // 最小行间距
    if (!_minimumLineSpacing) {
        _minimumLineSpacing = 0;
    }
    if ([self.delegate respondsToSelector:@selector(minimumLineSpacingForCollectionView:layout:)]) {
        _minimumLineSpacing = [self.delegate minimumLineSpacingForCollectionView:self.collectionView layout:self];
    }
    // 最小Cell间距
    if (!_minimumInteritemSpacing) {
        _minimumInteritemSpacing = 0;
    }
    if ([self.delegate respondsToSelector:@selector(minimumInteritemSpacingForCollectionView:layout:)]) {
        _minimumInteritemSpacing = [self.delegate minimumInteritemSpacingForCollectionView:self.collectionView layout:self];
    }
    // CollectionViewContent的偏移量
    if ([self.delegate respondsToSelector:@selector(insetForCollectionViewContent:layout:)]) {
        _contentInset = [self.delegate insetForCollectionViewContent:self.collectionView layout:self];
    }
    
    // Content的宽度
    CGFloat tempSectionContentWidth = _collectionContentWidth - _contentInset.left - _contentInset.right;
    
    // 获取每个Cell的大小
    if ([self.delegate respondsToSelector:@selector(sizeForCollectionViewItem:layout:)]) {
        _itemSize = [self.delegate sizeForCollectionViewItem:self.collectionView layout:self];
    }
    
    // Item的总数量
    NSInteger tempItemCount = 0;
    
    // 遍历Section
    for (int i = 0; i<sectionCount; i++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        tempItemCount += itemCount;

        // 获取每个Cell的大小
//        for (int j = 0; j<itemCount; j++) {
        
//                if (_tempCurrentLineCellNum > 0) { // 当前行内有其他Cell
//                    if (tempItemSize.width > tempSectionContentWidth) { // Cell自身超出内容宽度
//                        if (_tempLineNumber == 0) {
//                            _collectionContentHeight = _tempCurrentLineMaxHeight + _tempLineSpacing + tempItemSize.width;
//                        }else {
//                            _collectionContentHeight += (_tempCurrentLineMaxHeight + _tempLineSpacing *2 + tempItemSize.width);
//                        }
//                        _tempLineNumber += 2; // 下两行
//                        _tempCurrentLineCellNum = 0; // 行内Cell数量置0
//                        _tempCurrentLineWidth = 0; // 行宽置为0
//                        _tempCurrentLineMaxHeight = 0; // 行高置为0
//                    }else if (_tempCurrentLineWidth + tempItemSize.width + _tempItemSpacing > tempSectionContentWidth) { // 超出内容宽度，但是Cell自身未超出内容宽度
//                        if (_tempLineNumber == 0) {
//                            _collectionContentHeight = _tempCurrentLineMaxHeight;
//                        }else {
//                            _collectionContentHeight += (_tempCurrentLineMaxHeight + _tempLineSpacing);
//                        }
//                        _tempLineNumber++; // 下一行
//                        _tempCurrentLineCellNum = 1; // 行内Cell数量
//                        _tempCurrentLineWidth = tempItemSize.width; // 行宽
//                        _tempCurrentLineMaxHeight = tempItemSize.height; // 行高
//                    }else { // 未超出内容宽度
//                        _tempCurrentLineCellNum++; // 行内Cell数量
//                        _tempCurrentLineWidth += (tempItemSize.width + _tempItemSpacing); // 行宽
//                        _tempCurrentLineMaxHeight = tempItemSize.height; // 行高
//                    }
//                }else { // 当前行内没有其他Cell
//                    if (tempItemSize.width > tempSectionContentWidth) { // 超出内容宽度
//                        if (_tempLineNumber == 0) {
//                            _collectionContentHeight = tempItemSize.height;
//                        }else {
//                            _collectionContentHeight += (tempItemSize.height + _tempLineSpacing);
//                        }
//                        _tempLineNumber++; // 下一行
//                        _tempCurrentLineCellNum = 0; // 行内Cell数量置0
//                        _tempCurrentLineWidth = tempItemSize.width; // 行宽置为0
//                        _tempCurrentLineMaxHeight = tempItemSize.height; // 行高置为0
//                    }else { // 未超出内容宽度
//                        _tempCurrentLineWidth = tempItemSize.width;
//                        _tempCurrentLineCellNum++; // 增加一个Cell
//                        _tempCurrentLineMaxHeight = _tempCurrentLineMaxHeight>tempItemSize.height?_tempCurrentLineMaxHeight:tempItemSize.height; // 设置最大行高
//                    }
//                }
    }
//    if (_tempCurrentLineCellNum > 0) {
//        if (_tempLineNumber == 0) {
//            _collectionContentHeight = _tempCurrentLineMaxHeight;
//        }else {
//            _collectionContentHeight += (_tempCurrentLineMaxHeight + _tempLineSpacing);
//        }
//    }
//    _collectionContentHeight += (_tempContentInsets.top + _tempContentInsets.bottom);
    
    // 当前行的宽度
    CGFloat _tempCurrentLineWidth = 0;
    // 当前行的Cell数量
    NSInteger _tempCurrentLineCellNum = 0;
    do {
        if (_tempCurrentLineCellNum == 0) {
            _tempCurrentLineWidth = _itemSize.width;
        }else {
            _tempCurrentLineWidth += (_itemSize.width + _minimumInteritemSpacing);
        }
        _tempCurrentLineCellNum++;
    }while (_tempCurrentLineWidth <= tempSectionContentWidth+0.000000001);
    
    _currentItemCountInLine = _tempCurrentLineCellNum-1;
    if (_currentItemCountInLine != 1) {
        _currentItemSpacing = (tempSectionContentWidth - _currentItemCountInLine * _itemSize.width)/(_currentItemCountInLine - 1);
    }else {
        _currentItemSpacing = 0;
    }
    
    // 行数
    NSInteger tempLineNum = tempItemCount/_currentItemCountInLine;
    if (tempItemCount%_currentItemCountInLine > 0) { // 有多余
        tempLineNum++;
    }
    
    _collectionContentHeight = _itemSize.height * tempLineNum + _minimumLineSpacing * (tempLineNum - 1) + _contentInset.top + _contentInset.bottom;
    
}

// 布局将要更新
//- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
//    [super prepareForCollectionViewUpdates:updateItems];
//    NSLog(@"prepareForCollectionViewUpdates");
//}

// 将要显示Item
//- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    NSLog(@"initialLayoutAttributesForAppearingItemAtIndexPath");
//    return nil;
//}

// 将要取消显示Item
//- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    NSLog(@"finalLayoutAttributesForDisappearingItemAtIndexPath");
//    return nil;
//}

// 添加SupplementaryView
//- (NSArray<NSIndexPath *> *)indexPathsToInsertForSupplementaryViewOfKind:(NSString *)elementKind {
//    NSLog(@"indexPathsToInsertForSupplementaryViewOfKind");
//    return @[];
//}

// 添加DecorationView
//- (NSArray<NSIndexPath *> *)indexPathsToInsertForDecorationViewOfKind:(NSString *)elementKind {
//    NSLog(@"indexPathsToInsertForDecorationViewOfKind");
//    return @[];
//}

// 完成更新
//- (void)finalizeCollectionViewUpdates {
//    [super finalizeCollectionViewUpdates];
//    NSLog(@"finalizeCollectionViewUpdates");
//}

// 布局的内容大小
- (CGSize)collectionViewContentSize {
//    NSLog(@"collectionViewContentSize：%f", _collectionContentHeight);
    return CGSizeMake(self.collectionView.bounds.size.width, _collectionContentHeight);
}

// 获取指定范围内的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGFloat tempY = self.collectionView.contentOffset.y + 34 - (rect.size.height - (self.collectionView.bounds.size.height - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom))/2;
    NSMutableArray * attributes = [[NSMutableArray alloc]init];
    NSInteger sectionCount = [self.collectionView numberOfSections]; // 所有Section的数量
    NSInteger tempLineNum; // 需要的布局的行数
    NSInteger tempItemNumNeeded; // 需要的Cell的数量
    if (tempY >= 0) {
        CGFloat tempContentHeight = 0; // 累加前面的内容的高度
        NSInteger tempCurrentLineNum = 0; // y坐标所在的行
        do {
            if (tempCurrentLineNum == 0) { // 第一行
                tempContentHeight = _itemSize.height;
            }else {
                tempContentHeight += (_itemSize.height + _minimumLineSpacing);
            }
            tempCurrentLineNum++; // 行数累加
        }while (tempContentHeight < tempY);
        tempCurrentLineNum--; // 再减去1行
        
        tempLineNum = (rect.size.height + _minimumLineSpacing)/(_itemSize.height + _minimumLineSpacing); // 需要的布局的行数
        if ((long)(rect.size.height + _minimumLineSpacing)%(long)(_itemSize.height + _minimumLineSpacing)>0) {
            tempLineNum+=2;
        }
        tempItemNumNeeded = tempLineNum * _currentItemCountInLine; // 需要的Cell的数量
        
        NSInteger tempItemCount = tempCurrentLineNum * _currentItemCountInLine; // 需要的前面的内容的Cell的数量
        NSInteger tempItemCountNeeded = 0; // 累加需要的Cell的数量
        NSInteger tempItemNum = 0; // 累加前面的Cell的数量
        
        for (long i=0;i<sectionCount;i++) { // 遍历Section
            NSInteger tempCurrentSectionItemNum = [self.collectionView numberOfItemsInSection:i]; // 获得当前的Section中的Cell的数量
            if (tempItemCountNeeded > 0) { // 正在累加需要的Cell的数量
                if (tempItemCountNeeded + tempCurrentSectionItemNum > tempItemNumNeeded) {
                    for (long j=0;j<tempItemNumNeeded - tempItemCountNeeded;j++) {
                        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]]];
                    }
                    break;
                }else {
                    tempItemCountNeeded += tempCurrentSectionItemNum;
                    for (long j=0;j<tempCurrentSectionItemNum;j++) {
                        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]]];
                    }
                }
            }else if (tempItemNum + tempCurrentSectionItemNum > tempItemCount) { // 如果合计大于需要的前面的内容的Cell的数量
                if (tempItemNum + tempCurrentSectionItemNum >= tempItemCount + tempItemNumNeeded) {
                    for (long j = tempItemCount - tempItemNum;j<tempItemCount - tempItemNum + tempItemNumNeeded;j++) {
                        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]]];
                    }
                    break;
                }else {
                    tempItemCountNeeded += (tempItemNum + tempCurrentSectionItemNum - tempItemCount);
                    for (long j = tempItemCount - tempItemNum;j<tempCurrentSectionItemNum;j++) {
                        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]]];
                    }
                }
            }else { // 如果合计小于需要的前面的内容的Cell的数量
                tempItemNum += tempCurrentSectionItemNum; // 累加Cell的数量
            }
        }
    }else {
        tempLineNum = (rect.size.height + tempY + _minimumLineSpacing)/(_itemSize.height + _minimumLineSpacing);
        if ((long)(rect.size.height + tempY + _minimumLineSpacing)%(long)(_itemSize.height + _minimumLineSpacing)>0) {
            tempLineNum++;
        }
        tempItemNumNeeded = tempLineNum * _currentItemCountInLine; // 需要的Cell的数量
        NSInteger tempItemCount = 0;
        for (int i=0;i<sectionCount;i++) { // 遍历Section
            NSInteger tempCurrentSectionItemNum = [self.collectionView numberOfItemsInSection:i]; // 获得当前的Section中的Cell的数量
            if (tempItemCount + tempCurrentSectionItemNum > tempItemNumNeeded) {
                for (long j = 0;j<tempItemNumNeeded - tempItemCount;j++) {
                    [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]]];
                }
            }else {
                tempItemCount += tempCurrentSectionItemNum;
                for (long j = 0;j<tempCurrentSectionItemNum;j++) {
                    [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]]];
                }
            }
        }
        
    }

    
    
//    NSInteger sectionCount = [self.collectionView numberOfSections];
//    for (int i = 0; i<sectionCount; i++) {
//        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
//        for (int j=0;j<itemCount;j++) {
//            [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]]];
//        }
//    }
    return attributes;
}

// 获取指定项的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
     UICollectionViewLayoutAttributes * atti = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger tempSectionCount = 0;
    for (int i = 0; i<indexPath.section; i++) {
        tempSectionCount += [self.collectionView numberOfItemsInSection:i];
    }
    NSInteger tempCurrentItemCount = tempSectionCount + indexPath.row + 1;
    
    NSInteger tempLineNum = tempCurrentItemCount/_currentItemCountInLine;
    
    NSInteger tempCurrentItemSubIndex = tempCurrentItemCount%_currentItemCountInLine;
    if (tempCurrentItemSubIndex == 0) {
        tempCurrentItemSubIndex = _currentItemCountInLine;
    }else {
        tempLineNum++;
    }
    
    atti.frame = CGRectMake(_contentInset.left + (_currentItemSpacing + _itemSize.width) * (tempCurrentItemSubIndex - 1), _itemSize.height * (tempLineNum - 1) + _minimumLineSpacing * (tempLineNum - 2) + _contentInset.top*2, _itemSize.width, _itemSize.height);
    
    return atti;
}

//
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
