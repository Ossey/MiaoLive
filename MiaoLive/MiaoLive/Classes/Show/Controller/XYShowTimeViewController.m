//
//  XYShowTimeViewController.m
//  MiaoLive
//
//  Created by mofeini on 16/11/16.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYShowTimeViewController.h"


@interface XYShowTimeViewController ()

@property (nonatomic, weak) UIButton *beautifulfaceBtn;
@property (nonatomic, weak) UIButton *closeBtn;
@property (nonatomic, weak) UIButton *cameraChangeBtn;
@property (nonatomic, weak) UIButton *startShowBtn;

@end

@implementation XYShowTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    [UIButton xy_button:^(UIButton *btn) {
        [btn setTitle:@"智能美颜已开启" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_beautifulface_19x19"] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        self.beautifulfaceBtn = btn;
        [btn setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.5]];
        btn.layer.cornerRadius = 20;
        [btn.layer setMasksToBounds:YES];
    } buttonClickCallBack:^(UIButton *btn) {
        // 智能美颜开启
    }];
    
    [UIButton xy_button:^(UIButton *btn) {
        [btn setImage:[UIImage imageNamed:@"camera_change_40x40"] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        self.cameraChangeBtn = btn;
        [btn setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.5]];
        btn.layer.cornerRadius = 20;
        [btn.layer setMasksToBounds:YES];
    } buttonClickCallBack:^(UIButton *btn) {
        // 切换摄像头
    }];
    
    [UIButton xy_button:^(UIButton *btn) {
        [btn setImage:[UIImage imageNamed:@"talk_close_40x40"] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        self.closeBtn = btn;
        [btn setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.5]];
        btn.layer.cornerRadius = 20;
        [btn.layer setMasksToBounds:YES];
    } buttonClickCallBack:^(UIButton *btn) {
        // 关闭直播
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [UIButton xy_button:^(UIButton *btn) {
        [btn setTitle:@"开始直播" forState:UIControlStateNormal];
        [btn setTintColor:[UIColor whiteColor]];
        [btn setBackgroundColor:xyAppTinColor];
        [btn setBackgroundImage:[UIImage xy_imageWithColor:xyColorWithRGB(200, 0, 0)] forState:UIControlStateHighlighted];
        [self.view addSubview:btn];
        self.startShowBtn = btn;
        btn.layer.cornerRadius = 20;
        [btn.layer setMasksToBounds:YES];
    } buttonClickCallBack:^(UIButton *btn) {
        // 开始直播
    }];
    
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    CGFloat margin = 10;
    [self.beautifulfaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(margin);
        make.top.mas_equalTo(self.view).mas_offset(margin + 20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(180);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(-margin);
        make.top.mas_equalTo(self.beautifulfaceBtn);
        make.width.height.mas_equalTo(40);
    }];
    [self.cameraChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.closeBtn.mas_left).mas_offset(-margin);
        make.top.mas_equalTo(self.beautifulfaceBtn);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.startShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view).mas_offset(-60);
        make.bottom.mas_equalTo(self.view).mas_offset(-150);
        make.height.mas_equalTo(40);
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
