//
//  XYMenuView.m
//  XYMenuView
//
//  Created by mofeini on 16/11/15.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYMenuView.h"

@interface XYMenuView ()

@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIScrollView *scrollView;
/** 快速导出 **/
@property (nonatomic, weak) UIButton *fastExportBtn;
/** 高清导出 **/
@property (nonatomic, weak) UIButton *hdExportBtn;
/** 超清导出 **/
@property (nonatomic, weak) UIButton *superclearBtn;
/** 取消 **/
@property (nonatomic, weak) UIButton *cancelBtn;
/** 按钮的标题数组 **/
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, assign) UIControlState itemState;
@property (nonatomic, assign) CGFloat scrollViewHeight;
/** 动画执行的方向 */
@property (nonatomic, assign) XYMenuViewAnimationOrientation orientation;
/** contentView的底部或顶部约束，具体根据 orientation 属性 确定是顶部还是底部*/
@property (nonatomic, weak) NSLayoutConstraint *contentViewBotOrTop;


@end

@implementation XYMenuView
@synthesize separatorColor = _separatorColor;
@synthesize maskAlpha = _maskAlpha;
@synthesize itemBackGroundColor = _itemBackGroundColor;
@synthesize itemTitleColor = _itemTitleColor;
@synthesize itemState = _itemState;
@synthesize scrollViewHeight = _scrollViewHeight;
@synthesize orientation = _orientation;

#pragma mark - 对外公开的方法
+ (instancetype)menuViewToSuperView:(UIView *)superView {
    return [self menuViewToSuperView:superView scrollViewHeight:0 animationOrientation:0 menViewStyle:0];
}
+ (instancetype)menuViewToSuperView:(UIView *)superView scrollViewHeight:(CGFloat)height animationOrientation:(XYMenuViewAnimationOrientation)orientation menViewStyle:(XYMenuViewStyle)style {
    
    XYMenuView *menuView = [[self alloc] initWithScrollViewHeight:height menuViewStyle:style];
    menuView.orientation = orientation;
    
    if (CGRectGetHeight(superView.frame) < xyScreenH * 0.5 || CGRectGetHeight(superView.frame) <  xyScreenH * 0.5) {
        superView = xyApp.keyWindow;
    }
    
    if (superView) {
        [superView addSubview:menuView];
        
        // 默认让创建出来的menView在父控件的最底部
        menuView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:menuView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:menuView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        
        // 当有tabBar在显示时，让view的高度减去tabBar的高度，避免tabBar在上面挡住底部
        CGFloat margin;
        if (xyApp.keyWindow.rootViewController.tabBarController.tabBar.hidden == NO) {
            margin = -xyTabBarH;
        } else {
            margin = 0;
        }
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:menuView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:margin]];
        
        NSLayoutConstraint *menuViewTopConstr = [NSLayoutConstraint constraintWithItem:menuView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [superView addConstraint:menuViewTopConstr];
        
        // 强制更新布局，不然会产生问题
        [superView layoutIfNeeded];
        
//        [menuView showMenuView];
    }
    return menuView;
}

// 隐藏menuView，并在隐藏动画执行完毕后回调block
- (void)dismissMenuView:(void(^)())block {
    
    UIView *superView = self.superview;
    
    if (superView) {
//        self.coverView.hidden = YES;
        
        // 更新menuView的约束到父控件view的最底部，并隐藏
//        _selfTopConstr.priority = 800; // 约束优先级
        self.contentViewBotOrTop.constant = 0;
        
        [UIView animateWithDuration:0.2 animations:^{
            [superView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            self.hidden = YES;
            if (block) {
                block();
                
            }
            if (self.dismissCompletionBlock) {
                self.dismissCompletionBlock();
            }
            
        }];
    }
}



// 显示menuView,并在显示动画执行完毕回调block
- (void)showMenuView:(void(^)())block {
    UIView *superView = self.superview;
    if (superView) {
        
        self.hidden = NO;
        
//        self.selfTopConstr.constant = 0.0;
        if (self.orientation == 0) {
            NSLog(@"height==%f", self.contentView.frame.size.height);
            self.contentViewBotOrTop.constant = -CGRectGetHeight(self.contentView.frame);
        } else {
            self.contentViewBotOrTop.constant = CGRectGetHeight(self.contentView.frame);
        }
        [UIView animateWithDuration:0.2 animations:^{
            
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            self.coverView.hidden = NO;
            if (block) {
                block();
            }
            
            if (self.showCompletionBlock) {
                self.showCompletionBlock();
            }
        }];
    }
    
}



// 隐藏menuView
- (void)dismissMenuView {
    
    [self dismissMenuView:nil];
}

// 显示Action
- (void)showMenuView {
    [self showMenuView:nil];    
}

#pragma mark - 初始化方法
- (instancetype)initWithScrollViewHeight:(CGFloat)height menuViewStyle:(XYMenuViewStyle)style {
    if (self = [super initWithFrame:CGRectZero]) {
        self.scrollViewHeight = height;
        
        self.menuViewStyle = style;
        [self reloadSubView];
    }
    return self;
}

- (void)reloadSubView {
    
    if (self.subviews) {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
            
        }
    }
    UIView *coverView = [[UIView alloc] init];
    [self addSubview:coverView];
    _coverView = coverView;
    _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.maskAlpha];
    [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMaskEvent)]];
    
    UIView *contentView = [[UIView alloc] init];
    [self.coverView addSubview:contentView];
    _contentView = contentView;
    self.contentView.backgroundColor = self.separatorColor;
    
    
    [UIButton xy_button:^(UIButton *btn) {
        [self addItem:btn btnType:XYMenuViewBtnTypeFastExport title:self.itemTitles[0]];
        _fastExportBtn = btn;
    }];
    
    [UIButton xy_button:^(UIButton *btn) {
        [self addItem:btn btnType:XYMenuViewBtnTypeHDExport title:self.itemTitles[1]];
        _hdExportBtn = btn;
    }];
    
    
    [UIButton xy_button:^(UIButton *btn) {
        [self addItem:btn btnType:XYMenuViewBtnTypeSuperClear title:self.itemTitles[2]];
        _superclearBtn = btn;
    }];
    
    
    [UIButton xy_button:^(UIButton *btn) {
        [self addItem:btn btnType:XYMenuViewBtnTypeCancel title:self.itemTitles[3]];
        _cancelBtn = btn;
    }];
    
    
    __weak typeof(self) weakSelf = self;
    [self.cancelBtn xy_buttonClickBlock:^(UIButton *btn) {
        [weakSelf dismissMenuView];
    }];
    
    
    UIScrollView *scrollView =  [[UIScrollView alloc] init];
    [self.contentView addSubview:scrollView];
    _scrollView = scrollView;
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
    self.fastExportBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.hdExportBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.superclearBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 强制更新布局，不然会产生问题
    [self layoutIfNeeded];
}

- (void)addItem:(UIButton *)btn btnType:(XYMenuViewBtnType)type title:(NSString *)title {
    [btn setTitleColor:self.itemTitleColor forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = self.itemBackGroundColor;
    btn.tag = type;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_contentView, _fastExportBtn, _hdExportBtn, _superclearBtn, _cancelBtn, _coverView, _scrollView);
    CGFloat itemWidth = xyScreenW / self.itemTitles.count;
    
    NSDictionary *metrics = @{@"margin": @1, @"marginC": @5, @"itemHeight": @(self.itemHeight), @"itemWidth": @(itemWidth), @"scrollViewH": @(self.scrollViewHeight)};
    
    if (self.menuViewStyle == XYMenuViewStyleHorizontal) {
        NSDictionary *metrics = @{@"margin": @1, @"marginC": @5, @"height": @(self.itemHeight)};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_coverView]|" options:kNilOptions metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_coverView]|" options:kNilOptions metrics:nil views:views]];
        [self.coverView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:kNilOptions metrics:nil views:views]];

        if (self.orientation == 0) {

            self.contentViewBotOrTop = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.coverView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        } else {

            self.contentViewBotOrTop = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.coverView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        }
        [self.coverView addConstraint:self.contentViewBotOrTop];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_fastExportBtn]|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_hdExportBtn]|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_superclearBtn]|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cancelBtn]|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_fastExportBtn(height)]-margin-[_hdExportBtn(height)]-margin-[_superclearBtn(height)]-marginC-[_cancelBtn(height)]|" options:kNilOptions metrics:metrics views:views]];
    } else if (self.menuViewStyle == XYMenuViewStyleVertical) {
    
        NSLog(@"%f", self.scrollViewHeight);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_coverView]|" options:kNilOptions metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_coverView]|" options:kNilOptions metrics:nil views:views]];
        [self.coverView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:kNilOptions metrics:nil views:views]];
        
        if (self.orientation == 0) {
            
            self.contentViewBotOrTop = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.coverView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        } else {
            
            self.contentViewBotOrTop = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.coverView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        }
        [self.coverView addConstraint:self.contentViewBotOrTop];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_fastExportBtn(itemWidth)][_hdExportBtn(itemWidth)][_superclearBtn(itemWidth)][_cancelBtn(itemWidth)]|" options:kNilOptions metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:kNilOptions metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_fastExportBtn(itemHeight)]-[_scrollView(scrollViewH)]|" options:kNilOptions metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_hdExportBtn(itemHeight)]-[_scrollView]|" options:kNilOptions metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_superclearBtn(itemHeight)]-[_scrollView]|" options:kNilOptions metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cancelBtn(itemHeight)]-[_scrollView]|" options:kNilOptions metrics:metrics views:views]];
        
    }
    
    
}


- (void)dealloc {

    NSLog(@"%s", __func__);
}

#pragma mark - Actions
- (void)tapOnMaskEvent {
    
    [self dismissMenuView];
}

- (void)btnClick:(UIButton *)btn {
    if (self.menuViewClickBlock) {
        self.menuViewClickBlock(btn.tag);
    }
}


#pragma mark - set 、 get
- (BOOL)isItemState {
    return _itemState ?: UIControlStateNormal;
}


- (UIColor *)itemTitleColor {
    return _itemTitleColor ?: [UIColor blackColor];
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor {
    _itemTitleColor = itemTitleColor;
    [self.fastExportBtn setTitleColor:itemTitleColor forState:self.itemState];
    [self.hdExportBtn setTitleColor:itemTitleColor forState:self.itemState];
    [self.superclearBtn setTitleColor:itemTitleColor forState:self.itemState];
    [self.cancelBtn setTitleColor:itemTitleColor forState:self.itemState];
}
- (UIColor *)itemBackGroundColor {
    return _itemBackGroundColor ?: self.separatorColor;
}

- (void)setItemBackGroundColor:(UIColor *)itemBackGroundColor {
    _itemBackGroundColor = itemBackGroundColor;
    
    self.fastExportBtn.backgroundColor = itemBackGroundColor;
    self.hdExportBtn.backgroundColor = itemBackGroundColor;
    self.superclearBtn.backgroundColor = itemBackGroundColor;
    self.cancelBtn.backgroundColor = itemBackGroundColor;
}
- (void)setItemBackGroundColor:(UIColor * _Nonnull)itemBackGroundColor titleColor:(UIColor *)titleColor forState:(UIControlState)state {
    
    [self setItemBackGroundColor:itemBackGroundColor];
    [self setItemTitleColor:titleColor];
    self.itemState = state;
}

- (NSArray *)itemTitles {
    return _itemTitles ?: @[@"好友", @"未关注", @"系统", @"取消"];
}


- (void)setMenuViewStyle:(XYMenuViewStyle)menuViewStyle {
    _menuViewStyle = menuViewStyle;
    [self reloadSubView];
}

- (void)setMaskAlpha:(CGFloat)maskAlpha {
    _maskAlpha = maskAlpha;
    
    self.coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.maskAlpha];
}

- (CGFloat)maskAlpha {
    return _maskAlpha ? _maskAlpha : 0.08;
}



- (CGFloat)itemHeight {

    return _itemHeight ?: 40;
}

- (UIColor *)separatorColor {

    return _separatorColor ?: [UIColor colorWithWhite:240/255.0 alpha:1.0];
}


- (void)setSeparatorColor:(UIColor *)separatorColor {
    
    _separatorColor = separatorColor;
    self.contentView.backgroundColor = separatorColor;
    
    if (!self.itemBackGroundColor) {
        self.fastExportBtn.backgroundColor = separatorColor;
        self.hdExportBtn.backgroundColor = separatorColor;
        self.superclearBtn.backgroundColor = separatorColor;
        self.cancelBtn.backgroundColor = separatorColor;
    }
}

//- (void)setScrollViewHeight:(CGFloat)scrollViewHeight {
//    _scrollViewHeight = scrollViewHeight;
//    
//    [self.superview layoutIfNeeded];
//}

- (CGFloat)scrollViewHeight {
    
    if (!_scrollViewHeight) {
        return 220;
    }
    
    if (_scrollViewHeight < self.itemHeight) {
        return self.itemHeight;
    }
    return _scrollViewHeight;
}

- (XYMenuViewAnimationOrientation)orientation {
    return _orientation ?: XYMenuViewAnimationOrientationFromBottom;
}

#pragma mark - 不要使用这些系统方法进行初始化，会抛异常
- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(NO, @"请使用类方法创建'showToSuperView'");
    @throw nil;
}

- (instancetype)init {
    NSAssert(NO, @"请使用类方法创建'showToSuperView'");
    @throw nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(NO, @"请使用类方法创建'showToSuperView'");
    @throw nil;
}

@end
