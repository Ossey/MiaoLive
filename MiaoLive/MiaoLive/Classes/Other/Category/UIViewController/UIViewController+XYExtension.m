//
//  UIViewController+XYExtension.m
//  MiaoLive
//
//  Created by mofeini on 16/11/21.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "UIViewController+XYExtension.h"
#import "UIImageView+XYExtension.h"
#import <objc/runtime.h>

static char const *gifViewKey = "gifViewKey";

@implementation UIViewController (XYExtension)

- (void)setGifView:(UIImageView *)gifView {

    objc_setAssociatedObject(self, &gifViewKey, gifView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)gifView {

    return objc_getAssociatedObject(self, &gifViewKey);
}

- (BOOL)isEmptyArray:(NSArray *)array {

    /**
     isKindOfClass来确定一个对象是否是一个类的成员，或者是派生自该类的成员
     isMemberOfClass只能确定一个对象是否是当前类的成员
     */
    if ([array isKindOfClass:[NSArray class]] && array.count) {
        return NO;
    } else {
        return YES;
    }
}

- (void)showGifLoding:(NSArray *)images inView:(UIView *)view {

    if (!images.count) {
        images = @[[UIImage imageNamed:@"hold1_60x72"], [UIImage imageNamed:@"hold2_60x72"], [UIImage imageNamed:@"hold3_60x72"]];
    }
    
    UIImageView *gifView = [[UIImageView alloc] init];
    if (!view) {
        view = self.view;
    }
    [view addSubview:gifView];
    [gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.equalTo(@60);
        make.height.equalTo(@70);
    }];
    
    self.gifView = gifView;
    
    [gifView playGifAnim:images];
}

// 取消GIF加载动画
- (void)hideGufLoding
{
    [self.gifView stopGifAnim];
    self.gifView = nil;
}

#pragma mark - TabBar相关
- (BOOL)tabBarIsHidden {
    if (self.tabBarController.tabBar.xy_y == xyScreenH - xyTabBarH) {
        return YES;
    }else {
        return NO;
    }
}

- (void)tabBarHidden {
    if (self.tabBarController.tabBar) {
        
        
        if (self.tabBarController.tabBar.xy_y != xyScreenH - xyTabBarH) {
            return;
        }
        
        [UIView animateWithDuration:XYNavigationAndTabAnimationTime animations:^{
            self.tabBarController.tabBar.xy_y = xyScreenH;
        }];
    }
}
- (void)tabBarShow {
    if (self.tabBarController.tabBar) {
        
        if (self.tabBarController.tabBar.xy_y != xyScreenH) {
            return;
        }
        
        [UIView animateWithDuration:XYNavigationAndTabAnimationTime animations:^{
            self.tabBarController.tabBar.xy_y = xyScreenH - xyTabBarH;
        }];
    }
}


@end
