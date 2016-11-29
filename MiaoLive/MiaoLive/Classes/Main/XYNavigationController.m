//
//  XYNavigationController.m
//  MiaoLive
//
//  Created by mofeini on 16/11/21.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYNavigationController.h"

@interface XYNavigationController ()

@end

@implementation XYNavigationController

+ (void)initialize
{
    if (self == [XYNavigationController class]) {
        UINavigationBar *bar = [UINavigationBar appearance];
        [bar setBackgroundImage:[UIImage xy_imageWithColor:xyColorWithRGB(249, 112, 164)] forBarMetrics:UIBarMetricsDefault];

    }
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.childViewControllers.count > 0) {
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
