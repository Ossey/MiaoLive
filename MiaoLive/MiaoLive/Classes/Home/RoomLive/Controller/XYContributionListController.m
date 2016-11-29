//
//  XYContributionListController.m
//  MiaoLive
//
//  Created by mofeini on 16/11/27.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYContributionListController.h"

@interface XYContributionListController ()

@end

@implementation XYContributionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topBackgroundView.image = [UIImage xy_imageWithColor:xyAppTinColor];
    self.xy_title = @"房间贡献榜";
    [self xy_setBackBarTitle:nil titleColor:nil image:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    
    self.xy_tintColor = [UIColor whiteColor];
}

// 重写父类的自定义导航条左侧返回按钮的点击事件方法
- (void)xy_leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
