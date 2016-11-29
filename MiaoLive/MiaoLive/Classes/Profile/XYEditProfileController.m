//
//  XYEditProfileController.m
//  MiaoLive
//
//  Created by mofeini on 16/11/18.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  个人资料管理、编辑界面

#import "XYEditProfileController.h"

@interface XYEditProfileController ()

@end

@implementation XYEditProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topBackgroundView.image = [UIImage xy_imageWithColor:xyAppTinColor];

    [self xy_setBackBarTitle:nil titleColor:nil image:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    
    self.xy_title = @"编辑资料";
    self.xy_tintColor = [UIColor whiteColor];
    
    [UIButton xy_button:^(UIButton *btn) {
        [btn setTitle:@"下一季" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = xyColorWithRGB(249, 112, 164);
        [self.view addSubview:btn];
        [btn sizeToFit];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.centerY.mas_equalTo(self.view);
        }];
        
    } buttonClickCallBack:^(UIButton *btn) {
        XYEditProfileController *editVc = [[XYEditProfileController alloc] init];
        [self.navigationController pushViewController:editVc animated:YES];
    }];

    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    
    NSLog(@"%s", __FUNCTION__);
}

@end
