//
//  XYHomeTitleView.m
//  MiaoLive
//
//  Created by mofeini on 16/11/21.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYHomeTitleView.h"


@interface XYHomeTitleView ()
/** 下划线 */
@property (nonatomic, weak) UIView *underLineView;
/** 上次选择的按钮 */
@property (nonatomic, weak) UIButton *previousSelectedBtn;
/** 热门按钮 */
@property (nonatomic, weak) UIButton *hotBtn;
/** 最新按钮 */
@property (nonatomic, weak) UIButton *newbtn;
/** 关注按钮 */
@property (nonatomic, weak) UIButton *careBtn;

@end
@implementation XYHomeTitleView
- (UIView *)underLineView {
    if (_underLineView == nil) {
        UIView *underLineView = [[UIView alloc] init];
        underLineView.backgroundColor = [UIColor whiteColor];
        underLineView.frame = CGRectMake(15, self.xy_height - 4, xyHomeTitleButtonWidth + xyHomeDefaultMargin, 2);
        [self addSubview:underLineView];
        _underLineView = underLineView;
    }
    return _underLineView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {

    UIButton *hotBtn = [self creatBtn:@"最热" tag:XYHomeTitleViewItemTypeHot];
    UIButton *newBtn = [self creatBtn:@"最新" tag:XYHomeTitleViewItemTypeNew];
    UIButton *careBtn = [self creatBtn:@"关注" tag:XYHomeTitleViewItemTypeCare];
    [self addSubview:hotBtn];
    [self addSubview:newBtn];
    [self addSubview:careBtn];
    self.hotBtn = hotBtn;
    self.newbtn = newBtn;
    self.careBtn = careBtn;
    
    [newBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(xyHomeTitleButtonWidth);
    }];
    
    [hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(xyHomeDefaultMargin * 2));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(xyHomeTitleButtonWidth);
    }];
    
    [careBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-xyHomeDefaultMargin * 2));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(xyHomeTitleButtonWidth);
    }];

    // 强制更新一次
    [self layoutIfNeeded];
    
    // 设置默认选中的按钮为hot
    [self btnClick:hotBtn];
}

- (UIButton *)creatBtn:(NSString *)title tag:(XYHomeTitleViewItemType)tag {

    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6]  forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)setType:(XYHomeTitleViewItemType)selectedType {

    _selectedType = selectedType;
    self.previousSelectedBtn.selected = NO;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag == selectedType) {
            self.previousSelectedBtn = (UIButton *)view;
            ((UIButton *)view).selected = YES;
        }
    }
}

- (void)btnClick:(UIButton *)btn {

    self.previousSelectedBtn.selected = NO;
    btn.selected = YES;
    self.previousSelectedBtn = btn;
    if (self.window) { // 为了防止第一次打开界面时会有动画效果
        [UIView animateWithDuration:0.5 animations:^{
            self.underLineView.xy_x = btn.xy_x - xyHomeDefaultMargin * 0.5;
        }];
    } else {
        self.underLineView.xy_x = btn.xy_x - xyHomeDefaultMargin * 0.5;
    }
    
    
    if (self.homeTitleViewTypeBlock) {
        self.homeTitleViewTypeBlock(btn.tag);
    }
}

- (void)titleViewClickWithType:(XYHomeTitleViewItemType)type {

    switch (type) {
        case XYHomeTitleViewItemTypeHot:
            [self btnClick:self.hotBtn];
            break;
            case XYHomeTitleViewItemTypeNew:
            [self btnClick:self.newbtn];
            break;
        default:
            [self btnClick:self.careBtn];
            break;
    }
}
@end
