//
//  XYOnlineFriendViewController.m
//  MiaoLive
//
//  Created by mofeini on 16/11/18.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  这个界面显示关注主播(开播状态下才显示)

#import "XYOnlineFriendViewController.h"

@interface XYOnlineFriendViewController ()
/** 查看最热直播 */
@property (nonatomic, weak) UIButton *lookHotLiveBtn;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *tipLabel;
@end
/**
 当有关注的主播开播时显示开播的主播，没有就显示
 网络请求为post，因参数不够，无法获取到服务器数据  http://live.9158.com/Fans/GetMyOnlineFriendsList
 */
@implementation XYOnlineFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"no_follow_250x247"];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"你关注的主播还没有开播";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:tipLabel];
    self.tipLabel = tipLabel;
    
     [UIButton xy_button:^(UIButton *btn) {
         [btn setTitle:@"去看当前热门直播" forState:UIControlStateNormal];
         btn.layer.borderWidth = 1;
         btn.layer.cornerRadius = 25;
         btn.layer.borderColor = xyAppTinColor.CGColor;
         [btn.layer setMasksToBounds:YES];
         [btn setTitleColor:xyAppTinColor forState:UIControlStateNormal];
         [btn setBackgroundImage:[UIImage xy_imageWithColor:[UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:0.6]] forState:UIControlStateHighlighted];
         [self.view addSubview:btn];
         self.lookHotLiveBtn = btn;
    } buttonClickCallBack:^(UIButton *btn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XYlookHotLiveNotification object:nil];
    }];
    
    // 子控件布局
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(247);
        make.width.mas_equalTo(250);
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).mas_offset(-88);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.imageView);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(10);
    }];
    
    [self.lookHotLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.left.right.mas_equalTo(self.imageView);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).mas_offset(44);
    }];

}



@end
