//
//  XYSettingViewController.m
//  MiaoLive
//
//  Created by mofeini on 16/11/18.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYSettingViewController.h"
#import "XYLoginViewController.h"
#import "UIViewController+XYHUD.h"

@interface XYSettingViewController ()

@end

@implementation XYSettingViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.topBackgroundView.image = [UIImage xy_imageWithColor:xyAppTinColor];
    
    [self xy_setBackBarTitle:nil titleColor:nil image:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    
    self.xy_title = @"设置";
    self.xy_tintColor = [UIColor whiteColor];
    
//    __weak typeof(self) weakSelf = self;
    [UIButton xy_button:^(UIButton *btn) {
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = xyColorWithRGB(249, 112, 164);
        [self.view addSubview:btn];
        [btn sizeToFit];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.centerY.mas_equalTo(self.view);
        }];
        
    } buttonClickCallBack:^(UIButton *btn) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            xyApp.keyWindow.rootViewController = [XYLoginViewController new];
        });
    }];

    
}


- (void)dealloc {

    NSLog(@"%s", __FUNCTION__);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

@end
