//
//  XYMenuView.m
//  XYMenuView
//
//  Created by mofeini on 16/11/15.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYMenuView.h"

@interface XYMenuView ()

@property (nonatomic, weak) UIView *maskView;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) NSLayoutConstraint *selfTopConstr;
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
@end

@implementation XYMenuView
@synthesize separatorColor = _separatorColor;
@synthesize maskAlpha = _maskAlpha;
@synthesize itemBackGroundColor = _itemBackGroundColor;
@synthesize itemTitleColor = _itemTitleColor;
@synthesize itemState = _itemState;

#pragma mark - 对外公开的方法
+ (instancetype)menuViewToSuperView:(UIView *)superView {
    
    XYMenuView *menuView = [[self alloc] init];
    if (superView) {
        [superView addSubview:menuView];
        
        // 默认让创建出来的menView在父控件的最底部
        menuView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:menuView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:menuView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:menuView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
        NSLayoutConstraint *menuViewTopConstr = [NSLayoutConstraint constraintWithItem:menuView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:superView.frame.size.height];
        [superView addConstraint:menuViewTopConstr];
        menuView.selfTopConstr = menuViewTopConstr;
        
        // 强制更新布局，不然会产生问题
        [superView layoutIfNeeded];
        menuView.hidden = YES;
    }
    return menuView;
}

// 隐藏menuView，并在隐藏动画执行完毕后回调block
- (void)dismissMenuView:(void(^)())block {
    
    UIView *superView = self.superview;
    
    if (superView) {
        self.maskView.hidden = YES;
        
        // 更新menuView的约束到父控件view的最底部，并隐藏
//        _selfTopConstr.priority = 800; // 约束优先级
        _selfTopConstr.constant = superView.frame.size.height;
        
        [UIView animateWithDuration:0.2 animations:^{
            [superView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            self.hidden = YES;
            if (block) {
                block();
                
            }
            if (self.hiddenCompletionBlock) {
                self.hiddenCompletionBlock();
            }
            
        }];
    }
}



// 显示menuView,并在显示动画执行完毕回调block
- (void)showMenuView:(void(^)())block {
    UIView *superView = self.superview;
    if (superView) {
        
        self.hidden = NO;
        
        self.selfTopConstr.constant = 0.0;
        [UIView animateWithDuration:0.2 animations:^{
            
            [superView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            self.maskView.hidden = NO;
            if (block) {
                block();
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
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
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
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    _contentView = contentView;
    self.contentView.backgroundColor = self.separatorColor;
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.maskAlpha];
    
    [UIButton xy_button:^(UIButton *btn) {
        [self addItem:btn btnType:XYMenuViewBtnTypeFastExport title:self.itemTitles[0]];
        _fastExportBtn = btn;
    }];
    
    [UIButton xy_button:^(UIButton *btn) {
        [self addItem:btn btnType:XYMenuViewBtnTypeFastExport title:self.itemTitles[1]];
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
    
    UIView *maskView = [[UIView alloc] init];
    [self addSubview:maskView];
    _maskView = maskView;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMaskEvent)]];
    
    UIScrollView *scrollView =  [[UIScrollView alloc] init];
    [self.contentView addSubview:scrollView];
    _scrollView = scrollView;
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.maskView.translatesAutoresizingMaskIntoConstraints = NO;
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
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_contentView, _fastExportBtn, _hdExportBtn, _superclearBtn, _cancelBtn, _maskView, _scrollView);
    CGFloat itemWidth = xyScreenW / self.itemTitles.count;
    
    CGFloat scrollViewHeight = 220;
    
    NSDictionary *metrics = @{@"margin": @1, @"marginC": @5, @"itemHeight": @(self.itemHeight), @"itemWidth": @(itemWidth), @"scrollViewH": @(scrollViewHeight)};
    
    if (self.menuViewStyle == XYMenuViewStyleHorizontal) {
        NSDictionary *metrics = @{@"margin": @1, @"marginC": @5, @"height": @(self.itemHeight)};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_maskView]|" options:kNilOptions metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:kNilOptions metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_maskView][_contentView]|" options:kNilOptions metrics:metrics views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_fastExportBtn]|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_hdExportBtn]|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_superclearBtn]|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cancelBtn]|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_fastExportBtn(height)]-margin-[_hdExportBtn(height)]-margin-[_superclearBtn(height)]-marginC-[_cancelBtn(height)]|" options:kNilOptions metrics:metrics views:views]];
    } else if (self.menuViewStyle == XYMenuViewStyleVertical) {
    
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_maskView]|" options:kNilOptions metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:kNilOptions metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_maskView][_contentView]|" options:kNilOptions metrics:metrics views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_fastExportBtn(itemWidth)][_hdExportBtn(itemWidth)][_superclearBtn(itemWidth)][_cancelBtn(itemWidth)]|" options:kNilOptions metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:kNilOptions metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_fastExportBtn(itemHeight)]-[_scrollView(scrollViewH)]|" options:kNilOptions metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_hdExportBtn(itemHeight)]-[_scrollView]|" options:kNilOptions metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_superclearBtn(itemHeight)]-[_scrollView]|" options:kNilOptions metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cancelBtn(itemHeight)]-[_scrollView]|" options:kNilOptions metrics:metrics views:views]];
        
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
    
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.maskAlpha];
}

- (CGFloat)maskAlpha {
    return _maskAlpha ? _maskAlpha : 0.08;
}



- (CGFloat)itemHeight {

    return _itemHeight ?: 60;
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

@end
