//
//  XYHomeMenuView.m
//  MiaoLive
//
//  Created by mofeini on 16/11/30.
//  Copyright © 2016年 com.test.MiaoLive. All rights reserved.
//

#import "XYHomeMenuView.h"

@interface XYHomeMenuView ()
@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIButton *fastExportBtn;
@property (nonatomic, weak) UIButton *hdExportBtn;
@property (nonatomic, weak) NSLayoutConstraint *contentViewTopConst;
@end

@implementation XYHomeMenuView
#pragma mark - 对外公开的方法
+ (instancetype)menuViewToSuperView:(UIView *)superView {
    
    XYHomeMenuView *menuView = [[self alloc] initWithFrame:CGRectZero];
    
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

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self reloadSubView];
    }
    return self;
}


// 隐藏menuView，并在隐藏动画执行完毕后回调block
- (void)dismissMenuView:(void(^)())block {
    
    UIView *superView = self.superview;
    
    if (superView) {
        
        self.contentViewTopConst.constant = 0;
        
        [UIView animateWithDuration:1.0 animations:^{
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
//                        [self removeFromSuperview];
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
        // 先强制更新下
        [superView layoutIfNeeded];
        
        self.contentViewTopConst.constant = CGRectGetHeight(self.contentView.frame);
    
        [UIView animateWithDuration:1.0 animations:^{
            
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            
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

- (void)reloadSubView {
    
//    if (self.subviews) {
//        for (UIView *view in self.subviews) {
//            [view removeFromSuperview];
//            
//        }
//    }
    UIView *coverView = [[UIView alloc] init];
    [self addSubview:coverView];
    _coverView = coverView;
    _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMaskEvent)]];
    
    UIView *contentView = [[UIView alloc] init];
    [self.coverView addSubview:contentView];
    _contentView = contentView;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    [UIButton xy_button:^(UIButton *btn) {
        [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"hot_bigView"] forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [btn setTitle:@"大图" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = XYHomeMenuViewBtnTypeBig;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _fastExportBtn = btn;
    }];
    
    [UIButton xy_button:^(UIButton *btn) {
        [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [btn setTitle:@"小图" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"hot_SmallView"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = XYHomeMenuViewBtnTypeSmall;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _hdExportBtn = btn;
    }];
    
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
    self.fastExportBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.hdExportBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 强制更新布局，不然会产生问题
    [self layoutIfNeeded];
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self makeSubviewConstr];
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

- (void)makeSubviewConstr {
    NSDictionary *views = NSDictionaryOfVariableBindings(_contentView, _fastExportBtn, _hdExportBtn, _coverView);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_coverView]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_coverView]|" options:kNilOptions metrics:nil views:views]];
    [self.coverView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:kNilOptions metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:0.0 constant:50]];
    
    self.contentViewTopConst = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.coverView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    // 设置约束优先级低，不然更新约束时会报约束冲突
    self.contentViewTopConst.priority = UILayoutPriorityDefaultLow;
    [self.coverView addConstraint:self.contentViewTopConst];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_fastExportBtn]|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_hdExportBtn]|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_fastExportBtn][_hdExportBtn]|" options:kNilOptions metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.fastExportBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.hdExportBtn attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.fastExportBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.hdExportBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    
}


@end
