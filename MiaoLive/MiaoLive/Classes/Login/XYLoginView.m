//
//  XYLoginView.m
//  MiaoLive
//
//  Created by mofeini on 16/11/16.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYLoginView.h"
#import "XYThirdPartyLoginView.h"

@interface XYLoginView ()

/** login_logo */
@property (nonatomic, weak) UIImageView *logoView;
/** 第三方登录通道 */
@property (nonatomic, weak) XYThirdPartyLoginView *thirdPartyLoginView;
/** 9158登录 */
@property (nonatomic, weak) UIButton *jywbLoginBtn;
/** 辰龙登录 */
@property (nonatomic, weak) UIButton *chenlongLoginBtn;
/** 分隔符 */
@property (nonatomic, weak) UIView *separatorView;

@end

@implementation XYLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
    [self addSubview:logoView];
    self.logoView = logoView;
    __weak typeof(self) weakSelf = self;
    XYThirdPartyLoginView *thirdPartyLoginView = [[XYThirdPartyLoginView alloc] init];
    [self addSubview:thirdPartyLoginView];
    self.thirdPartyLoginView = thirdPartyLoginView;
    [thirdPartyLoginView setClickThirdLoginTypeBlock:^(XYThirdLoginType type, UIButton *btn) {
        [weakSelf clickBtn:btn];
        //            switch (type) {
        //                case 1:
        //                    btn.tag = XYLoginTypeWeChat;
        //                    [weakSelf clickBtn:btn];
        //                    break;
        //                case 2:
        //                    btn.tag = XYLoginTypeQQ;
        //                    [weakSelf clickBtn:btn];
        //                    break;
        //                default:
        //                    btn.tag = XYLoginTypeWeibo;
        //                    [weakSelf clickBtn:btn];
        //                    break;
        //            }
    }];
    
    
    [UIButton xy_button:^(UIButton *btn) {
        [btn setTitle:@"9158登录" forState:UIControlStateNormal];
        self.jywbLoginBtn = btn;
        btn.tag = XYLoginType9158;
        [self addSubview:btn];
    } buttonClickCallBack:^(UIButton *btn) {
        [weakSelf clickBtn:btn];
    }];
    
    [UIButton xy_button:^(UIButton *btn) {
        [btn setTitle:@"辰龙登录" forState:UIControlStateNormal];
        self.chenlongLoginBtn = btn;
        btn.tag = XYLoginTypeChenlong;
        [self addSubview:btn];
    } buttonClickCallBack:^(UIButton *btn) {
        [weakSelf clickBtn:btn];
    }];
    
    UIView *separatorView = [[UIView alloc] init];
    [self addSubview:separatorView];
    self.separatorView = separatorView;
    separatorView.backgroundColor = xyColorWithRGB(230, 230, 230);
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    [self.thirdPartyLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.mas_equalTo(self);
        make.height.mas_equalTo(220);
    }];
    
    // 当是横屏时隐藏logoView
    if (xyScreenW > xyScreenH) {
        self.logoView.hidden = YES;
    } else {
        self.logoView.hidden = NO;
        [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.thirdPartyLoginView.mas_top).mas_offset(-20);
            make.centerX.mas_equalTo(self.thirdPartyLoginView);
            make.width.height.mas_equalTo(120);
        }];
    }
    
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(1);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.thirdPartyLoginView.mas_bottom).mas_offset(20);
    }];
    
    [self.jywbLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.separatorView.mas_left).mas_offset(-20);
        make.centerY.mas_equalTo(self.separatorView);
    }];
    
    [self.chenlongLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.separatorView.mas_right).mas_offset(20);
        make.centerY.mas_equalTo(self.separatorView);
    }];
    
}

- (void)clickBtn:(UIButton *)btn {
    
    if (self.clickLoginTypeBlock) {
        self.clickLoginTypeBlock(btn.tag);
    }
}
@end
