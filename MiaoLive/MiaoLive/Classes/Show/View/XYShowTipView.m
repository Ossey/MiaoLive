//
//  XYShowTipView.m
//  MiaoLive
//
//  Created by mofeini on 16/11/28.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYShowTipView.h"

NSString *const permission_microphone = @"permission_microphone";
NSString *const permission_local = @"permission_local";
NSString *const permission_camera = @"permission_camera";
NSString *const permission_microphoneColor = @"permission_microphoneColor";
NSString *const permission_localColor = @"permission_localColor";
NSString *const permission_cameraColor = @"permission_cameraColor";


@interface XYShowTipView ()

@property (nonatomic, weak) UIView *tipView;
@property (nonatomic, weak) UIImageView *tipImageView;
@property (nonatomic, weak) UILabel *tipLabel;
@property (nonatomic, weak) UIButton *certificationBtn; // 去认证
@property (nonatomic, weak) UIButton *afterBtn; // 以后认证
@property (nonatomic, weak) UIButton *closeBtn;
@property (nonatomic, weak) UIButton *cameraAutBtn; // 摄像头权限
@property (nonatomic, weak) UIButton *microphoneAutBtn; // 麦克风权限设置
@property (nonatomic, weak) UIButton *locationAutBtn; // 地理权限

/** tipView顶部约束 */
@property (nonatomic, weak) NSLayoutConstraint *tipViewTopConst;

@property (nonatomic, copy) NSString *imageNmae;
@property (nonatomic, strong) UIColor *btnColor;
@end
@implementation XYShowTipView

@synthesize style = _style;
NSString *const openStatuKey = @"openStatuKey";
NSString *const checkTypeKey = @"checkTypeKey";
NSString *const msgKey = @"msgKey";
NSString *const LocationValue = @"LocationValue";
NSString *const MicrophoneValue = @"MicrophoneValue";
NSString *const CameraValue = @"CameraValue";
NSString *const CameraAuthorityValue = @"CameraAuthorityValue";

#pragma mark - 对外公开的方法
// 销毁，并在消失动画执行完毕后回调block
- (void)dismiss:(void(^)())block {
    
    UIView *superView = self.superview;
    
    if (superView) {
        
        // 更新约束到父控件view的最底部，并隐藏
        _tipViewTopConst.constant = superView.frame.size.height;
      
        [UIView animateWithDuration:0.6 animations:^{
            [superView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
//            self.hidden = YES;
            [self removeFromSuperview];
            if (block) {
                block();
            }
            if (self.dismissCompletionBlock) {
                self.dismissCompletionBlock();
            }
            
        }];
    }
}

// 显示,并在显示动画执行完毕回调block
- (void)show:(void(^)())block {
    UIView *superView = self.superview;
    if (superView) {
        
//        self.hidden = NO;
        
        CGFloat margin = (CGRectGetHeight(self.frame) - CGRectGetHeight(self.tipView.frame)) * 0.5;
        margin = CGRectGetHeight(self.frame) - margin;
        self.tipViewTopConst.constant = -margin;
        
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:6.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
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

- (void)show {
    [self show:nil];
}
- (void)dismiss {
    [self dismiss:nil];
}


+ (instancetype)showToSuperView:(UIView *)superView {
    
    return  [self showToSuperView:superView tipViewStyle:0];
}

+ (instancetype)showToSuperView:(UIView *)superView tipViewStyle:(XYTipViewStyle)style {
    XYShowTipView *showTipView = [[self alloc] initWithTipViewStyle:style];
    if (superView) {
        [superView addSubview:showTipView];
        
        // 默认让创建出来的menView在父控件的最底部
        showTipView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:showTipView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:showTipView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:showTipView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
        NSLayoutConstraint *selfTopConstr = [NSLayoutConstraint constraintWithItem:showTipView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [superView addConstraint:selfTopConstr];
        
        // 强制更新布局，不然会产生问题
        [superView layoutIfNeeded];
        
        // 让tipView从底部向上移动
        [showTipView show];
    }
    return showTipView;
}


#pragma mark - Private Mothod
- (void)showAuthorizationSetting:(void(^)())block {

     [XYShowTipView showToSuperView:[UIApplication sharedApplication].keyWindow tipViewStyle:1];
    
}


- (instancetype)initWithTipViewStyle:(XYTipViewStyle)style {
    if (self = [super initWithFrame:CGRectZero]) {
        
        // 必须要先拿到style，再setupUI才准确
        self.style = style;
        
        [self reloadSubviews];
    }
    return self;
}

#pragma mark - 添加子控件
- (void)reloadSubviews {
    
    if (self.subviews.count) {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
    }
    
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSelf)]];
    // 添加子控件
    UIView *tipView = [[UIView alloc] init];
    tipView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tipView];
    self.tipView = tipView;
    self.tipView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    [self.tipView addSubview:tipLabel];
    self.tipLabel = tipLabel;
    self.tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (self.style == XYTipBtnTypeGoCertification) {

        
        tipLabel.text = @"响应喵星的号召，请完成实名认证，开始一场坦荡荡的直播吧！";
        UIImageView *tipImageView = [[UIImageView alloc] init];
        [self.tipView addSubview:tipImageView];
        tipImageView.image = [UIImage imageNamed:@"notRealName_cat"];
        self.tipImageView = tipImageView;
        
        UIButton *certificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [certificationBtn setTitle:@"去认证" forState:UIControlStateNormal];
        [certificationBtn setImage:[UIImage imageNamed:@"livingPopup_image_catHand"] forState:UIControlStateNormal];
        certificationBtn.backgroundColor = xyAppTinColor;
        [certificationBtn setImage:[UIImage imageNamed:@"livingPopup_image_catHand"] forState:UIControlStateNormal];
        certificationBtn.layer.cornerRadius = 15;
        [certificationBtn.layer setMasksToBounds:YES];
        certificationBtn.tag = XYTipBtnTypeGoCertification;
        [self.tipView addSubview:certificationBtn];
        self.certificationBtn = certificationBtn;
        [certificationBtn addTarget:self action:@selector(certificationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *afterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [afterBtn setTitle:@"日后再说😜" forState:UIControlStateNormal];
        [afterBtn setTitleColor:xyAppTinColor forState:UIControlStateNormal];
        afterBtn.layer.cornerRadius = 15;
        afterBtn.layer.borderWidth = 1.0f;
        afterBtn.layer.borderColor = xyAppTinColor.CGColor;
        [afterBtn.layer setMasksToBounds:YES];
        afterBtn.tag = XYTipBtnTypeAfter;
        [self.tipView addSubview:afterBtn];
        self.afterBtn = afterBtn;
        [afterBtn addTarget:self action:@selector(certificationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.tipImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.certificationBtn.translatesAutoresizingMaskIntoConstraints = NO;
        self.afterBtn.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self makeConstraint1];
        
    } else if (self.style == XYTipBtnTypeAfter) {
        // 读取偏好设置中的图片名称
        NSString *camera = [[NSUserDefaults standardUserDefaults] valueForKey:permission_camera];
        NSString *local = [[NSUserDefaults standardUserDefaults] valueForKey:permission_local];
        NSString *microphone = [[NSUserDefaults standardUserDefaults] valueForKey:permission_microphone];
        if (camera == nil) {
            camera = self.imageNmae;
        }
        if (local == nil) {
            local = self.imageNmae;
        }
        if (microphone == nil) {
            microphone = self.imageNmae;
        }
        
        NSString *cameraColorStr = [[NSUserDefaults standardUserDefaults] valueForKey:permission_cameraColor];
        NSString *localColorStr = [[NSUserDefaults standardUserDefaults] valueForKey:permission_localColor];
        NSString *microphoneColorStr = [[NSUserDefaults standardUserDefaults] valueForKey:permission_microphoneColor];
        
        UIColor *cameraColor = cameraColorStr == nil ? self.btnColor : [UIColor blackColor];
        UIColor *localColor = localColorStr == nil ? self.btnColor : [UIColor blackColor];
        UIColor *microphoneColor = microphoneColorStr == nil ? self.btnColor : [UIColor blackColor];
        
        
        tipLabel.text = @"直播前请先开启以下权限";
        
        UIButton *cameraAutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cameraAutBtn setTitle:@"摄像头权限设置" forState:UIControlStateNormal];
        [cameraAutBtn setImage:[UIImage imageNamed:camera] forState:UIControlStateNormal];
        [cameraAutBtn setTitleColor:cameraColor forState:UIControlStateNormal];
        cameraAutBtn.layer.cornerRadius = 15;
        cameraAutBtn.layer.borderWidth = 1.0f;
        cameraAutBtn.layer.borderColor = cameraColor.CGColor;
        [cameraAutBtn.layer setMasksToBounds:YES];
        cameraAutBtn.tag = XYTipBtnTypeCameraAutSetting;
        [self.tipView addSubview:cameraAutBtn];
        self.cameraAutBtn = cameraAutBtn;
        [cameraAutBtn addTarget:self action:@selector(certificationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *microphoneAutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [microphoneAutBtn setTitle:@"麦克风权限设置" forState:UIControlStateNormal];
        [microphoneAutBtn setTitleColor:microphoneColor forState:UIControlStateNormal];
        [microphoneAutBtn setImage:[UIImage imageNamed:microphone] forState:UIControlStateNormal];
        microphoneAutBtn.layer.cornerRadius = 15;
        microphoneAutBtn.layer.borderWidth = 1.0f;
        microphoneAutBtn.layer.borderColor = microphoneColor.CGColor;
        [microphoneAutBtn.layer setMasksToBounds:YES];
        [self.tipView addSubview:microphoneAutBtn];
        self.microphoneAutBtn = microphoneAutBtn;
        microphoneAutBtn.tag = XYTipBtnTypeMicrophoneAutSetting;
        [microphoneAutBtn addTarget:self action:@selector(certificationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *locationAutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [locationAutBtn setTitle:@"地理权限设置" forState:UIControlStateNormal];
        [locationAutBtn setTitleColor:localColor forState:UIControlStateNormal];
        [locationAutBtn setImage:[UIImage imageNamed:local] forState:UIControlStateNormal];
        locationAutBtn.layer.cornerRadius = 15;
        locationAutBtn.layer.borderWidth = 1.0f;
        locationAutBtn.layer.borderColor = localColor.CGColor;
        [locationAutBtn.layer setMasksToBounds:YES];
        [self.tipView addSubview:locationAutBtn];
        self.locationAutBtn = locationAutBtn;
        locationAutBtn.tag = XYTipBtnTypeLocationAutSetting;
        [locationAutBtn addTarget:self action:@selector(certificationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"user_close_15x15"] forState:UIControlStateNormal];
        closeBtn.tag = XYTipBtnTypeClose;
        [self.tipView addSubview:closeBtn];
        self.closeBtn = closeBtn;
        [closeBtn addTarget:self action:@selector(certificationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.cameraAutBtn.translatesAutoresizingMaskIntoConstraints = NO;
        self.microphoneAutBtn.translatesAutoresizingMaskIntoConstraints = NO;
        self.locationAutBtn.translatesAutoresizingMaskIntoConstraints = NO;
        self.closeBtn.translatesAutoresizingMaskIntoConstraints = NO;

        [self makeConstraint2];
    }
    
    [self.superview layoutIfNeeded];
    
}

#pragma mark - Events
- (void)certificationBtnClick:(UIButton *)btn {
    
    // 当外部需要拦截showAuthorizationSetting:时，此方法不要在内部实现
    //    if (btn.tag == XYTipBtnTypeAfter) {
    //        [self dismiss:^{
    //
    //            [self showAuthorizationSetting:nil];
    //
    //        }];
    //    }
    
    if (btn.tag == XYTipBtnTypeClose) {
        [self dismiss];
    }
    NSLog(@"tipBtnClickBlock==%@", self.tipBtnClickBlock);
    NSLog(@"%p", self);
    // 执行闭包
    if (self.tipBtnClickBlock) {
        NSArray *info = self.tipBtnClickBlock(btn.tag);
       [self btnCallBack:btn infoArray:info];
        
        return; // 若执行了block后，就不再执行代理了，因为作用相同，没必要
    }
    
    // 执行代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(showTipView:didClickButton:)]) {
        NSArray *info = [self.delegate showTipView:self didClickButton:btn.tag];
        [self btnCallBack:btn infoArray:info];
    }


}

- (void)btnCallBack:(UIButton *)btn infoArray:(NSArray *)info {

    if (info.count == 0) {
        // 当info为没有内容时，就不解析, 移除沙盒中保存的图片名称
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:permission_camera];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:permission_local];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:permission_microphone];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:permission_cameraColor];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:permission_localColor];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:permission_microphoneColor];
        return;
    }
    
    for (id obj in info) {
        
        //            NSLog(@"%@", info);
        
        // 由于disMiss后当前类对象已经被delloc，所以无法设置其属性值，可以将要设置的属性值保存到沙盒中，用的时候再取出来
        if ([obj[checkTypeKey] isEqualToString:CameraValue] && [obj[openStatuKey] isEqualToString:@"0"]) {
            //                NSLog(@"没有开启摄像头");
            [[NSUserDefaults standardUserDefaults] setObject:@"permission_camera" forKey:permission_camera];
            [[NSUserDefaults standardUserDefaults] setObject:@"blackColor" forKey:permission_cameraColor];
            
        } else if ([obj[checkTypeKey] isEqualToString:CameraValue] && [obj[openStatuKey] isEqualToString:@"1"]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:permission_camera];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:permission_cameraColor];
        }
        
        if ([obj[checkTypeKey] isEqualToString:MicrophoneValue] && [obj[openStatuKey] isEqualToString:@"0"]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"permission_microphone" forKey:permission_microphone];
            [[NSUserDefaults standardUserDefaults] setObject:@"blackColor" forKey:permission_microphoneColor];
            //                NSLog(@"没有开启麦克风");
        } else if ([obj[checkTypeKey] isEqualToString:MicrophoneValue] && [obj[openStatuKey] isEqualToString:@"1"]) {
            //                NSLog(@"开启麦克风");
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:permission_microphone];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:permission_microphoneColor];
        }
        if ([obj[checkTypeKey] isEqualToString:LocationValue] && [obj[openStatuKey] isEqualToString:@"0"]) {
            //                NSLog(@"没有开启定位");
            [[NSUserDefaults standardUserDefaults] setObject:@"permission_local" forKey:permission_local];
            [[NSUserDefaults standardUserDefaults] setObject:@"blackColor" forKey:permission_localColor];
        } else if ([obj[checkTypeKey] isEqualToString:LocationValue] && [obj[openStatuKey] isEqualToString:@"1"]) {
            //                NSLog(@"开启定位");
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:permission_local];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:permission_localColor];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

- (void)tapOnSelf {
    
    [self dismiss:nil];
}



#pragma mark - set\get
- (void)setStyle:(XYTipViewStyle)style {
    _style = style;
    
    [self reloadSubviews];
    [self show];
    
    
}
- (XYTipViewStyle)style {
    
    return _style ?: 0;
}

- (NSString *)imageNmae {
    
    return _imageNmae?: @"permission_ok";
}

- (UIColor *)btnColor {
    return _btnColor?: xyAppTinColor;
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
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

#pragma mark - 子控件约束相关
- (void)makeConstraint1 {
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tipView, _tipImageView,_tipLabel, _certificationBtn, _afterBtn);
    NSDictionary *metrics = @{@"tipViewMarginH": @60, @"tipLabelMarginH": @20, @"tipLabelMarginV": @15, @"btnH": @40};
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tipView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-tipViewMarginH-[_tipView]-tipViewMarginH-|" options:kNilOptions metrics:metrics views:views]];
    //    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tipView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.tipView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]]; // tipView的高度约束不设置了，让其跟随子控件决定高度
    // 让tipView默认在最底部, 为了做动画
    NSLayoutConstraint *tipViewTopConst = [NSLayoutConstraint constraintWithItem:self.tipView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:tipViewTopConst];
    self.tipViewTopConst = tipViewTopConst;
    
    [self.tipView addConstraint:[NSLayoutConstraint constraintWithItem:self.tipImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.tipView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.tipView addConstraint:[NSLayoutConstraint constraintWithItem:self.tipImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:0.0 constant:220]];
    [self.tipView addConstraint:[NSLayoutConstraint constraintWithItem:self.tipImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:0.0 constant:130]];
    [self.tipView addConstraint:[NSLayoutConstraint constraintWithItem:self.tipImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.tipView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-60]];
    
    [self.tipView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-tipLabelMarginH-[_tipLabel]-tipLabelMarginH-|" options:kNilOptions metrics:metrics views:views]];
    [self.tipView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tipImageView][_tipLabel(70)]-tipLabelMarginV-[_certificationBtn(btnH)]-tipLabelMarginV-[_afterBtn(btnH)]-tipLabelMarginV-|" options:kNilOptions metrics:metrics views:views]];
    [self.tipView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-tipLabelMarginV-[_certificationBtn]-tipLabelMarginV-|" options:kNilOptions metrics:metrics views:views]];
    [self.tipView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-tipLabelMarginV-[_afterBtn]-tipLabelMarginV-|" options:kNilOptions metrics:metrics views:views]];
}

- (void)makeConstraint2 {
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tipView, _closeBtn, _tipLabel, _cameraAutBtn, _microphoneAutBtn, _locationAutBtn);
    NSDictionary *metrics = @{@"tipViewMarginH": @30, @"tipLabelMarginH": @30, @"tipLabelMarginV": @10, @"btnH": @45, @"tipTitleH": @25};
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tipView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-tipViewMarginH-[_tipView]-tipViewMarginH-|" options:kNilOptions metrics:metrics views:views]];
    //        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tipView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.tipView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    NSLayoutConstraint *tipViewTopConst = [NSLayoutConstraint constraintWithItem:self.tipView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:tipViewTopConst];
    self.tipViewTopConst = tipViewTopConst;
    
    [self.tipView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-tipLabelMarginH-[_tipLabel(tipTitleH)]-tipLabelMarginH-[_cameraAutBtn(btnH)]-tipLabelMarginH-[_microphoneAutBtn(btnH)]-tipLabelMarginH-[_locationAutBtn(btnH)]-tipLabelMarginH-|" options:kNilOptions metrics:metrics views:views]];
    [self.tipView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-tipLabelMarginH-[_tipLabel]-tipLabelMarginH-|" options:kNilOptions metrics:metrics views:views]];
    [self.tipView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-tipLabelMarginH-[_cameraAutBtn]-tipLabelMarginH-|" options:kNilOptions metrics:metrics views:views]];
    [self.tipView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-tipLabelMarginH-[_microphoneAutBtn]-tipLabelMarginH-|" options:kNilOptions metrics:metrics views:views]];
    [self.tipView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-tipLabelMarginH-[_locationAutBtn]-tipLabelMarginH-|" options:kNilOptions metrics:metrics views:views]];
    [self.tipView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_closeBtn(15)]-tipLabelMarginV-|" options:kNilOptions metrics:metrics views:views]];
    [self.tipView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-tipLabelMarginV-[_closeBtn(15)]" options:kNilOptions metrics:metrics views:views]];
}

@end
