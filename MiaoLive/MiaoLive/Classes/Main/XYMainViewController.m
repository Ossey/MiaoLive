//
//  XYMainViewController.m
//  MiaoLive
//
//  Created by mofeini on 16/11/16.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYMainViewController.h"
#import "XYHomeViewController.h"
#import "XYShowTimeViewController.h"
#import "XYProfileViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XYProfileNavigationController.h"
#import "XYNavigationController.h"
#import "XYProfileNavigationController.h"
#import "XYShowTipView.h"
#import <CoreLocation/CoreLocation.h>
#import "XYEditProfileController.h"

@interface XYMainViewController () <UITabBarControllerDelegate>
/** 是否实名认证过,当此属性为YES时(已实名认证)，此时就不再弹出tipView弹框了，直接进入show */
@property (nonatomic, assign, getter=isCertification) BOOL certification;
@end

@implementation XYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    [self setup];

}

- (void)setup {

    // 主页
    [self addChildViewController:[XYHomeViewController new] imageNamed:@"toolbar_home"];
    // 此控制器是占位用的
    [self addChildViewController:[UIViewController new] imageNamed:@"toolbar_live"];

    // 我
    XYProfileViewController *profileVc = [XYProfileViewController new];
    XYProfileNavigationController *profileNav = [[XYProfileNavigationController alloc] initWithRootViewController:profileVc];
    profileVc.tabBarItem.image = [UIImage imageNamed:@"toolbar_me"];
    profileVc.tabBarItem.selectedImage = [UIImage imageNamed:@"toolbar_me_sel"];
    profileVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [self addChildViewController:profileNav];
    
}

#pragma mark - 添加子控制器的方法
- (void)addChildViewController:(UIViewController *)childController imageNamed:(NSString *)imageName {

    XYNavigationController *nav = [[XYNavigationController alloc] initWithRootViewController:childController];
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sel", imageName]];
    
    // 设置tabBar上每个item的图片居中,顶部和底部必须一样大
    childController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [self addChildViewController:nav];
}


#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    // 定义一个数组来保存没有开启权限的
    __block NSMutableArray *info = [NSMutableArray array];
    
    // 通过以下判断是否加载showVc
    // 当点击tabBar上showTime按钮时，根据以下条件判断是否运行打开
    if ([tabBarController.childViewControllers indexOfObject:viewController] == tabBarController.childViewControllers.count - 2) {
        // 判断是不是模拟器
        if ([[UIDevice deviceVersion] isEqualToString:XYDeviceIPhoneSimulator]) {
            // 如果是模拟器
            [self showInfo:@"请用真机进行测试, 此模块不支持模拟器测试"];
            return NO;
        }
        
        // 判断是否有摄像头
        if (![self checkupCameraIsSourceTypeAvailable:info]) {
            [self showInfo:@"您的设备没有摄像头或者相关的驱动, 不能进行直播"];
            return NO;
        }
       
        if (!self.isCertification) {
            __weak XYShowTipView *tipView = [XYShowTipView showToSuperView:self.view];
            [tipView setTipBtnClickBlock:^NSArray * (XYTipBtnType type) {
                if (type == XYTipBtnTypeAfter) {
                    // 点击日后再说按钮
                    
                    [tipView dismiss:^{
                        
                        // 检测相机、定位、麦克风是否都开启了，如果都开启了，就不切换弹框了
                        if ([self checkupCameraServiceEnabled:info] && [self checkupLocationServiceEnabled:info] && [self checkupMicrophoneServiceEnabled:info]) {
                            
                            // 当权限都开后，就跳转到自己的直播室
                            XYShowTimeViewController *showTimeVc = [[XYShowTimeViewController alloc] init];
                            XYProfileNavigationController *nav = [[XYProfileNavigationController alloc] initWithRootViewController:showTimeVc];
                            [self presentViewController:nav animated:YES completion:nil];
                            return;
                        }
                        // 切换弹框: 注意:tipView调用dismiss后会被从父控件中移除，并销毁，此时需要弹出新的弹框，需要在创建一个
                        [self showTipView:info];
                    }];
                    
                    // 检测是否有相机、定位、麦克风权限，并把相关信息传给内部进行处理
                    [self checkupCameraServiceEnabled:info];
                    [self checkupLocationServiceEnabled:info];
                    [self checkupMicrophoneServiceEnabled:info];

                } else if (type == XYTipBtnTypeGoCertification) {
                    // 点击去认证的按钮
                    XYEditProfileController *editProfileVc =  [[XYEditProfileController alloc] init];
                    editProfileVc.hiddenLeftButton = NO;
                    XYProfileNavigationController *nav = [[XYProfileNavigationController alloc] initWithRootViewController:editProfileVc];
                    [self presentViewController:nav animated:YES completion:^{
                        [self xy_showMessage:@"实用认证需要先绑定手机号哦"];
                    }];
                }
                return info;
               
            }];
            
            return NO;
        }
        
        XYShowTimeViewController *showTimeVc = [[XYShowTimeViewController alloc] init];
        XYProfileNavigationController *nav = [[XYProfileNavigationController alloc] initWithRootViewController:showTimeVc];
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

- (void)showTipView:(NSMutableArray *)info {

    XYShowTipView *tipView1 = [XYShowTipView showToSuperView:self.view tipViewStyle:1];
    [tipView1 setTipBtnClickBlock:^NSArray<NSDictionary *> * _Nonnull(XYTipBtnType type) {
        // 判断是否有摄像头权限
        if (![self checkupCameraServiceEnabled:info] && type == XYTipBtnTypeCameraAutSetting) {
            //  跳转到设置界面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        // 判断定位服务
        if (![self checkupLocationServiceEnabled:info] && type == XYTipBtnTypeLocationAutSetting) {
            //  跳转到设置界面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        // 开启麦克风权限
        if (![self checkupMicrophoneServiceEnabled:info] && type == XYTipBtnTypeMicrophoneAutSetting){
            //  跳转到设置界面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        return info;
    }];
}

@end
