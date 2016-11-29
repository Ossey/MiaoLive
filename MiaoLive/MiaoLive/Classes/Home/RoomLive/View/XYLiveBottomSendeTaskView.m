//
//  XYLiveBottomSendeTaskView.m
//  MiaoLive
//
//  Created by mofeini on 16/11/26.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  发送聊天信息的视图

#import "XYLiveBottomSendeTaskView.h"

@interface XYLiveBottomSendeTaskView ()
@property (nonatomic, weak) UIButton *barrageBtn;
@property (nonatomic, weak) UITextField *tf;
@property (nonatomic, weak) UIButton *sendTaskBtn;
@property (nonatomic, weak) UIView *separatorView;
@end

@implementation XYLiveBottomSendeTaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *barrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [barrageBtn setTitle:@"弹幕" forState:UIControlStateNormal];
        [barrageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        barrageBtn.backgroundColor = [UIColor magentaColor];
        [self addSubview:barrageBtn];
        self.barrageBtn = barrageBtn;
        
        UITextField *tf = [[UITextField alloc] init];
        tf.placeholder = @"发送弹幕100喵币/条";
        tf.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:tf];
        self.tf = tf;
        
        UIButton *sendTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendTaskBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendTaskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendTaskBtn.backgroundColor = [UIColor magentaColor];
        [self addSubview:sendTaskBtn];
        self.sendTaskBtn = sendTaskBtn;
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = xyColorWithRGB(200, 200, 200);
        [self addSubview:separatorView];
        
    }
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    CGFloat padding = 10;
    [self.barrageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(padding);
        make.top.mas_equalTo(self).mas_offset(padding);
        make.bottom.mas_equalTo(self).mas_offset(-padding);
        make.width.mas_equalTo(60);
    }];
    
    [self.sendTaskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-padding);
        make.top.bottom.width.mas_equalTo(self.barrageBtn);
    }];
    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.barrageBtn.mas_right).mas_offset(padding);
        make.top.bottom.mas_equalTo(self.barrageBtn);
        make.right.mas_equalTo(self.sendTaskBtn.mas_left).mas_offset(-padding);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1.0f);
    }];
}
@end
