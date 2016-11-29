//
//  XYThirdPartyLoginView.m
//  MiaoLive
//
//  Created by mofeini on 16/11/16.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYThirdPartyLoginView.h"

@interface XYThirdPartyLoginView ()

/** 微信登录 */
@property (nonatomic, weak) UIButton *weChatLoginBtn;
/** 新浪登录 */
@property (nonatomic, weak) UIButton *weiboLoginBtn;
/** QQ登录 */
@property (nonatomic, weak) UIButton *qqLoginBtn;

@end
@implementation XYThirdPartyLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    self.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    [UIButton xy_button:^(UIButton *btn) {
        [btn setImage:[UIImage imageNamed:@"login_Weixin"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"login_Weixin_select"] forState:UIControlStateNormal];
        [btn setTitle:@"微信登录" forState:UIControlStateNormal];
        btn.tag = XYThirdLoginTypeWeChat;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 10;
        btn.layer.borderColor = [UIColor greenColor].CGColor;
        [btn.layer setMasksToBounds:YES];
        self.weChatLoginBtn = btn;
        [self addSubview:btn];
    } buttonClickCallBack:^(UIButton *btn) {
        [weakSelf clickBtn:btn];
    }];
    
    [UIButton xy_button:^(UIButton *btn) {
        [btn setImage:[UIImage imageNamed:@"login_QQ"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"login_QQ_select"] forState:UIControlStateNormal];
        [btn setTitle:@"Q Q登录" forState:UIControlStateNormal];
        btn.tag = XYThirdLoginTypeQQ;;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 10;
        btn.layer.borderColor = [UIColor magentaColor].CGColor;
        [btn.layer setMasksToBounds:YES];
        self.qqLoginBtn = btn;
        [self addSubview:btn];
    } buttonClickCallBack:^(UIButton *btn) {
        [weakSelf clickBtn:btn];
    }];
    
    [UIButton xy_button:^(UIButton *btn) {
        [btn setImage:[UIImage imageNamed:@"login_Weibo"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"login_Weibo-select"] forState:UIControlStateNormal];
        [btn setTitle:@"微博登录" forState:UIControlStateNormal];
        btn.tag = XYThirdLoginTypeWeibo;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 10;
        btn.layer.borderColor = [UIColor redColor].CGColor;
        self.weiboLoginBtn = btn;
        [self addSubview:btn];
    } buttonClickCallBack:^(UIButton *btn) {
        [weakSelf clickBtn:btn];
    }];

}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    [self.weChatLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.qqLoginBtn.mas_top).mas_offset(-30);
        make.width.mas_equalTo(220);
    }];
    [self.qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.height.width.mas_equalTo(self.weChatLoginBtn);
    }];
    
    [self.weiboLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.height.width.mas_equalTo(self.weChatLoginBtn);
        make.top.mas_equalTo(self.qqLoginBtn.mas_bottom).mas_offset(30);
    }];
}

- (void)clickBtn:(UIButton *)btn {

    if (self.clickThirdLoginTypeBlock) {
        self.clickThirdLoginTypeBlock(btn.tag, btn);
    }
}

@end
