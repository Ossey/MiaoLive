//
//  XYProfileBaseController.m
//  自定义导航条
//
//  Created by mofeini on 16/9/25.
//  Copyright © 2016年 sey. All rights reserved.
//

#import "XYProfileBaseController.h"

@interface XYProfileBaseController ()

/** 导航条topBackgroundView */
@property (nonatomic, strong) UIImageView *topBackgroundView;
/** 导航条阴影线 */
@property (nonatomic, strong) UIImageView *shadowLineView;
/** 导航条左侧按钮 */
@property (nonatomic, weak) UIButton *leftButton;
/** 导航条titleView */
@property (nonatomic, weak) UIButton *xy_titleView;
/** 导航条左侧返回按钮的文字，这个属性在当前控制器下有效 */
@property (nonatomic, copy) NSString *xy_backBarTitle;
/** 导航条左侧返回按钮的图片 */
@property (nonatomic, strong) UIImage *xy_backBarImage;
/** 导航条左侧返回按钮的状态 */
@property (nonatomic, assign) UIControlState xy_backBarState;

@property (nonatomic, weak) NSLayoutConstraint *topBackgroundViewHConst;
@end

@implementation XYProfileBaseController
@synthesize rightButton = _rightButton;
@synthesize xy_titleView = _xy_titleView;
@synthesize xy_title = _xy_title;
@synthesize xy_backBarTitle = _xy_backBarTitle;
@synthesize xy_backBarImage = _xy_backBarImage;

//@synthesize xy_globalBarTitle = _xy_globalBarTitle;

#pragma mark - set和get方法
- (UIFont *)xy_buttonFont {

    return _xy_buttonFont ?: [UIFont systemFontOfSize:16];
}
- (UIColor *)xy_tintColor {

    return _xy_tintColor ?: [UIColor blackColor];
}

- (void)setXy_title:(NSString *)xy_title {

    _xy_title = xy_title;
    // 注意: 这里不要使用self.xy_customTitleView, 因为这样会调用set方法,而我在set方法中又做侧判断，会导致移除失败
    if (_xy_customTitleView) {
        [_xy_customTitleView removeFromSuperview];
        _xy_customTitleView = nil;
    }

}

- (NSString *)xy_title {
    
    return _xy_title ?: nil;
    
}

- (BOOL)isHiddenLeftButton {

    return _hiddenLeftButton ?: NO;
}


- (void)setXy_customTitleView:(UIView *)xy_customTitleView {

    _xy_customTitleView = xy_customTitleView;
    // 注意: 这里不要使用self.xy_titleView, 因为这样会调用set方法,而我在set方法中又做侧判断，会导致移除失败
    if (_xy_title || _xy_titleView) {
        // 为了避免自定义的titleView与xy_titleView产生冲突
        _xy_title = nil;
        [_xy_titleView removeFromSuperview];
        _xy_titleView = nil;
    }
    if (!xy_customTitleView.superview && ![xy_customTitleView.superview isEqual:self.topBackgroundView]) {
        if ([xy_customTitleView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)xy_customTitleView;
            label.textAlignment = NSTextAlignmentCenter;
        }
        [self.topBackgroundView addSubview:xy_customTitleView];
        xy_customTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    }

    
}

- (UIButton *)xy_titleView {
    if (_xy_titleView == nil) {
        // 右侧按钮
        UIButton *titleView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.topBackgroundView addSubview:titleView];
        [titleView setTitle:self.xy_title forState:UIControlStateNormal];
        [titleView setTitleColor:self.xy_tintColor forState:UIControlStateNormal];
        _xy_titleView = titleView;
        titleView.translatesAutoresizingMaskIntoConstraints = NO;
        return _xy_titleView;
    } else {
        [_xy_titleView setTitleColor:self.xy_tintColor forState:UIControlStateNormal];
        return _xy_titleView;
    }
}


- (void)setXy_titleView:(UIButton *)xy_titleView {
    
    _xy_titleView = xy_titleView;
    [xy_titleView removeFromSuperview];
    if (!xy_titleView.superview && ![xy_titleView.superview isEqual:self.topBackgroundView]) {
        [self.topBackgroundView addSubview:xy_titleView];
        xy_titleView.userInteractionEnabled = NO;
        xy_titleView.translatesAutoresizingMaskIntoConstraints = NO;
    }
}

- (UIButton *)rightButton {
    if (_rightButton) {
        
        [_rightButton setTitleColor:self.xy_tintColor forState:UIControlStateNormal];
        _rightButton.titleLabel.font = self.xy_buttonFont;
    }
    return _rightButton;
}

- (void)setRightButton:(UIButton *)rightButton {

    _rightButton = rightButton;
    [rightButton removeFromSuperview];
    if (!rightButton.superview && ![rightButton.superview isEqual:self.topBackgroundView]) {
       [self.topBackgroundView addSubview:rightButton];
        rightButton.translatesAutoresizingMaskIntoConstraints = NO;
    }

}


//- (NSString *)xy_globalBarTitle {
//    
//    return _xy_globalBarTitle ?: @"返回";
//}

- (UIControlState )xy_backBarState {

    return _xy_backBarState ?: UIControlStateNormal;
}

- (void)setXy_backBarImage:(UIImage *)xy_backBarImage {

    _xy_backBarImage = xy_backBarImage;
    [self.leftButton setImage:xy_backBarImage forState:self.xy_backBarState];
}

- (void)setXy_backBarTitle:(NSString *)xy_backBarTitle {

    xy_backBarTitle = xy_backBarTitle;
    
    [self.leftButton setTitle:xy_backBarTitle forState:self.xy_backBarState];
}

- (NSString *)xy_backBarTitle {

    return _xy_backBarTitle ?: @"返回";
}
- (UIImage *)xy_backBarImage {

    return _xy_backBarImage ?: nil;
}

- (UIButton *)leftButton {
    if (_leftButton == nil) {
        // 左侧返回按钮
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setTitle:self.xy_backBarTitle forState:UIControlStateNormal];
        [leftButton setImage:self.xy_backBarImage forState:UIControlStateNormal];
        leftButton.titleLabel.font = self.xy_buttonFont;
        [leftButton setTitleColor:self.xy_tintColor forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.topBackgroundView addSubview:leftButton];
        _leftButton = leftButton;
        leftButton.hidden = self.isHiddenLeftButton;
        leftButton.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return _leftButton;
}


- (UIImageView *)topBackgroundView {

    if (_topBackgroundView == nil) {
        UIImageView *topBackgroundView = [[UIImageView alloc] init];
        topBackgroundView.userInteractionEnabled = YES;
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:topBackgroundView];
        
        _topBackgroundView = topBackgroundView;
    }
    return _topBackgroundView;
}

- (UIImageView *)shadowLineView {

    if (_shadowLineView == nil) {
        UIImageView *shadowLineView = [[UIImageView alloc] init];
        shadowLineView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.topBackgroundView addSubview:shadowLineView];
        _shadowLineView = shadowLineView;
    }
    return _shadowLineView;
}

- (void)xy_setBackBarTitle:(nullable NSString *)title titleColor:(UIColor *)color image:(nullable UIImage *)image forState:(UIControlState)state {
    _xy_backBarTitle = title;
    _xy_backBarImage = image;
    _xy_backBarState = state;
    [self.leftButton setTitle:title forState:state];
    [self.leftButton setImage:image forState:state];
    [self.leftButton setTitleColor:color forState:state];
}


#pragma mark - 控制器view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 自定义导航条
    [self setupCustomBar];
}
- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    // 设置约束
    [self makeConstr];
    
}


- (void)setupCustomBar {
    
    // 导航条背景
    self.topBackgroundView.image = [self xy_imageWithColor:[UIColor colorWithWhite:200 alpha:0.8]];
    
    // 导航阴影线
    self.shadowLineView.image = [self xy_imageWithColor:[UIColor colorWithWhite:100 alpha:0.8]];
    
    // 左侧按钮视图
    [self.leftButton addTarget:self action:@selector(xy_leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}


// 点击左侧返回按钮的事件
- (void)xy_leftButtonClick {
    
    // 判断两种情况: push 和 present
    if (self.presentedViewController || self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
        [self.navigationController popViewControllerAnimated:YES];

}



#pragma mark - Private Method
// 通过颜色生成图片
- (UIImage *)xy_imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 1.0);
    CGContextRef contexRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contexRef, [color CGColor]);
    CGContextFillRect(contexRef, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// 判断当前控制器是否正在显示
- (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}



- (void)makeConstr {
    NSDictionary *views = NSDictionaryOfVariableBindings(_topBackgroundView, _shadowLineView);
    NSDictionary *metrics = @{@"leftButtonMaxW": @150, @"leftButtonLeftM": @10, @"leftBtnH": @44, @"rightBtnH": @44, @"rightBtnRightM": @10};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topBackgroundView]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topBackgroundView]" options:kNilOptions metrics:metrics views:views]];
    // 根据屏幕是否旋转更新topBackgroundView的高度约束
    if (CGRectGetWidth([UIScreen mainScreen].bounds) > CGRectGetHeight([UIScreen mainScreen].bounds)) {
        [self.view removeConstraint:self.topBackgroundViewHConst];
        NSLayoutConstraint *topBackgroundViewHConst = [NSLayoutConstraint constraintWithItem:self.topBackgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:kNilOptions attribute:kNilOptions multiplier:0.0 constant:44];
        [self.view addConstraint:topBackgroundViewHConst];
        self.topBackgroundViewHConst = topBackgroundViewHConst;
    } else {
        [self.view removeConstraint:self.topBackgroundViewHConst];
        NSLayoutConstraint *topBackgroundViewHConst = [NSLayoutConstraint constraintWithItem:self.topBackgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:kNilOptions attribute:kNilOptions multiplier:0.0 constant:64];
        [self.view addConstraint:topBackgroundViewHConst];
        self.topBackgroundViewHConst = topBackgroundViewHConst;
        
    }
    
    [self.topBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_shadowLineView]|" options:kNilOptions metrics:metrics views:views]];
    [self.topBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_shadowLineView(0.5)]|" options:kNilOptions metrics:metrics views:views]];
    
    if (self.leftButton && self.leftButton.superview) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_leftButton);
        [self.topBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftButtonLeftM-[_leftButton(<=leftButtonMaxW)]" options:kNilOptions metrics:metrics views:views]];
        [self.topBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_leftButton(leftBtnH)]|" options:kNilOptions metrics:metrics views:views]];
    }
    
    if (self.rightButton && self.rightButton.superview) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_rightButton);
        [self.topBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_rightButton(<=leftButtonMaxW)]-rightBtnRightM-|" options:kNilOptions metrics:metrics views:views]];
        [self.topBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rightButton(rightBtnH)]|" options:kNilOptions metrics:metrics views:views]];
    }
    
    if (self.xy_titleView && self.xy_titleView.superview) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_xy_titleView);
        [self.topBackgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.xy_titleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.topBackgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [self.topBackgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.xy_titleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:kNilOptions attribute:kNilOptions multiplier:0.0 constant:150]];
        [self.topBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_xy_titleView(rightBtnH)]|" options:kNilOptions metrics:metrics views:views]];
    }
    
    if (self.xy_customTitleView && self.xy_customTitleView.superview) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_xy_customTitleView);
        [self.topBackgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.xy_customTitleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.topBackgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [self.topBackgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.xy_customTitleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:kNilOptions attribute:kNilOptions multiplier:0.0 constant:150]];
        [self.topBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_xy_customTitleView(rightBtnH)]|" options:kNilOptions metrics:metrics views:views]];
        
    }
}

- (void)dealloc {
    
    NSLog(@"%s", __FUNCTION__);
}

@end
