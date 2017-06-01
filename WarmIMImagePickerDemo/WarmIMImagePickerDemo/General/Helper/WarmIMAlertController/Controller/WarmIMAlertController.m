//
//  WarmIMAlertController.m
//  WarmIMImagePickerDemo
//
//  Created by LinJia on 2017/5/20.
//  Copyright © 2017年 shmily. All rights reserved.
//

#import "WarmIMAlertController.h"

#import "WarmIMAlertTableViewCell.h"

@interface WarmIMAlertController () <UITableViewDelegate, UITableViewDataSource> {
    CGFloat _topViewHeight;
    CGFloat _subtitleHeight;
    CGFloat _actionTableViewHeight;
}

@property (nonatomic, strong) UIView *backgroundView; // 背景
@property (nonatomic, strong) UIView *topView; // 顶部视图

@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UILabel *subtitleLabel; // 子标题

@property (nonatomic, strong) UITableView *actionTableView; // 底部action视图

@property (nonatomic, strong) NSMutableArray *normalActionArray;
@property (nonatomic, strong) NSMutableArray *cancelActionArray;

@property (nonatomic, strong) NSLayoutConstraint *topViewLayoutConstraintTop; // 距离顶部的距离

@end

@implementation WarmIMAlertController

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        self.titleColor = [UIColor blackColor];
        self.messageColor = [UIColor lightGrayColor];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    if (self = [super init]) {
        _alertTitle = title;
        _message = subtitle;
        self.titleColor = [UIColor blackColor];
        self.messageColor = [UIColor lightGrayColor];
        self.normalActionArray = [NSMutableArray array];
        self.cancelActionArray = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message {
    WarmIMAlertController *alertController = [[self alloc]initWithTitle:title subtitle:message];
    alertController.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    alertController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    alertController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return alertController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self calculateAllSize];
    [self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.25 animations:^{
        _backgroundView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - _topViewHeight - _actionTableViewHeight, [UIScreen mainScreen].bounds.size.width, _topViewHeight + _actionTableViewHeight);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touch
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_allowTouchCancel && _cancelActionArray.count > 0) {
        WarmIMAlertAction *tempCancelAction = _cancelActionArray[0];
        if (tempCancelAction.actionHandler) {
            tempCancelAction.actionHandler(tempCancelAction);
        }
        [self dismiss];
    }
    
}

#pragma mark - UI
- (void)setupSubViews {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, _topViewHeight + _actionTableViewHeight)];
        [self.view addSubview:_backgroundView];
        if (!_topView) {
            _topView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, _topViewHeight)];
            //        _topView.translatesAutoresizingMaskIntoConstraints = NO;
            _topView.backgroundColor = _topViewBackgroundColor?_topViewBackgroundColor:[UIColor whiteColor];
            [_backgroundView addSubview:_topView];
            
            if (!_titleLabel) {
                _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, 20)];
                _titleLabel.textColor = _titleColor;
                _titleLabel.text = _alertTitle;
                _titleLabel.textAlignment = NSTextAlignmentCenter;
                [_topView addSubview:_titleLabel];
            }
            if (!_subtitleLabel) {
                _subtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, [UIScreen mainScreen].bounds.size.width - 40, _subtitleHeight)];
                _subtitleLabel.text = _message;
                _subtitleLabel.font = [UIFont systemFontOfSize:14];
                _subtitleLabel.numberOfLines = 0;
                _subtitleLabel.textColor = _messageColor;
                if (_subtitleHeight < 20) {
                    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
                }
                [_topView addSubview:_subtitleLabel];
            }
        }
        if (!_actionTableView) {
            _actionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height + _topViewHeight + _actionTableViewHeight, [UIScreen mainScreen].bounds.size.width, _actionTableViewHeight) style:UITableViewStyleGrouped];
            _actionTableView.translatesAutoresizingMaskIntoConstraints = NO;
            _actionTableView.bounces = NO;
            _actionTableView.backgroundColor = [UIColor clearColor];
            _actionTableView.showsVerticalScrollIndicator = NO;
            _actionTableView.showsHorizontalScrollIndicator = NO;
            _actionTableView.delegate = self;
            _actionTableView.dataSource = self;
            [_backgroundView addSubview:_actionTableView];
        }
    }
}


// 重新加载
- (void)reloadView {
    [self calculateAllSize];
    if (_backgroundView) {
        _backgroundView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, _topViewHeight + _actionTableViewHeight);
        if (_topView) {
            _topView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _topViewHeight);
            if (_subtitleLabel) {
                _subtitleLabel.frame = CGRectMake(20, 50, [UIScreen mainScreen].bounds.size.width - 40, _subtitleHeight);
                if (_subtitleHeight < 20) {
                    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
                }else {
                    _subtitleLabel.textAlignment = NSTextAlignmentLeft;
                }
            }
        }
        if (_actionTableView) {
            _actionTableView.frame = CGRectMake(0, _topViewHeight, [UIScreen mainScreen].bounds.size.width, _actionTableViewHeight);
        }
    }
}

#pragma mark - Functions
// 添加Action
- (void)addAction:(WarmIMAlertAction *)action {
    if (action.style == WarmIMAlertActionStyleCancel) {
        [_cancelActionArray addObject:action];
    }else {
        [_normalActionArray addObject:action];
    }
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_actions];
    [tempArray addObject:action];
    _actions = tempArray;
    [self reloadView];
}

// 移除页面
- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        _backgroundView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, _topViewHeight + _actionTableViewHeight);
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 计算所有高度
- (void)calculateAllSize {
    if (_message && ![_message isEqualToString:@""]) {
        _subtitleHeight = [self boundingALLRectWithSize:_message Font:[UIFont systemFontOfSize:14] Size:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, 0)].height;
        _topViewHeight = 20 + 20 + 10 + _subtitleHeight + 20;
    }else {
        _topViewHeight = 60;
    }
    
    
    CGFloat tempTableViewHeight = 0;
    for (int i = 0;i<_normalActionArray.count;i++) {
        WarmIMAlertAction *tempModel = _normalActionArray[i];
        if (tempModel.style == WarmIMAlertActionStyleCustom) {
            tempTableViewHeight += tempModel.height;
        }else {
            tempTableViewHeight += 44;
        }
    }
    if (_cancelActionArray.count > 0) {
        tempTableViewHeight += (_cancelActionArray.count * 44 + 20);
    }
    if (tempTableViewHeight + _topViewHeight + 20 > [UIScreen mainScreen].bounds.size.height) {
        tempTableViewHeight = [UIScreen mainScreen].bounds.size.height - _topViewHeight - 20;
    }
    _actionTableViewHeight = tempTableViewHeight;
}

// 计算文字高度
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cancelActionArray.count > 0) {
        if (indexPath.section == 1) {
            return 44;
        }
    }
    WarmIMAlertAction *tempAction = _normalActionArray[indexPath.row];
    if (tempAction.style == WarmIMAlertActionStyleCustom) {
        return tempAction.height;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (_cancelActionArray.count > 0) {
            return 20;
        }
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cancelActionArray.count > 0) {
        if (indexPath.section == 1) {
            WarmIMAlertAction *tempCancelAction = _cancelActionArray[indexPath.row];
            if (tempCancelAction.actionHandler) {
                tempCancelAction.actionHandler(tempCancelAction);
            }
        }else {
            WarmIMAlertAction *tempNormalAction = _normalActionArray[indexPath.row];
            if (tempNormalAction.actionHandler) {
                tempNormalAction.actionHandler(tempNormalAction);
            }
        }
    }else {
        WarmIMAlertAction *tempNormalAction = _normalActionArray[indexPath.row];
        if (tempNormalAction.actionHandler) {
            tempNormalAction.actionHandler(tempNormalAction);
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismiss];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_cancelActionArray.count > 0) {
        if (section == 1) {
            return _cancelActionArray.count;
        }
    }
    return _normalActionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WarmIMAlertTableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier:@"WarmIMAlertTableViewCell"];
    if (!tempCell) {
        tempCell = [[WarmIMAlertTableViewCell alloc]initWithReuseIdentifier:@"WarmIMAlertTableViewCell"];
    }
    if (_cancelActionArray.count > 0) {
        if (indexPath.section == 1) {
            WarmIMAlertAction *tempCancelAction = _cancelActionArray[indexPath.row];
            tempCell.backgroundColor = tempCancelAction.backgroundColor;
            tempCell.mainLabel.text = tempCancelAction.title;
            tempCell.mainLabel.textColor = tempCancelAction.tintColor;
            tempCell.userInteractionEnabled = tempCancelAction.enabled;
            return tempCell;
        }
    }
    WarmIMAlertAction *tempNormalAction = _normalActionArray[indexPath.row];
    tempCell.backgroundColor = tempNormalAction.backgroundColor;
    tempCell.mainLabel.text = tempNormalAction.title;
    tempCell.mainLabel.textColor = tempNormalAction.tintColor;
    tempCell.userInteractionEnabled = tempNormalAction.enabled;
    return tempCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_cancelActionArray.count > 0) {
        return 2;
    }
    return 1;
}

#pragma mark - UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return NO;
}
@end
