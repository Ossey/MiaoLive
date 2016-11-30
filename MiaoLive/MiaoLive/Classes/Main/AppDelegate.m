//
//  AppDelegate.m
//  MiaoLive
//
//  Created by mofeini on 16/11/16.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "AppDelegate.h"
#import "XYLoginViewController.h"
#import "Reachability.h"
#import "XYNetworkTool.h"
#import "XYDBManager.h"

@interface AppDelegate () {

    Reachability *_reachability;
    XYNetworkState _previousState; // 上一次网络状态
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [XYLoginViewController new];
    
    [self.window makeKeyAndVisible];
    
    [self checkNetworkstate];
    
    // 打开数据库
    [[XYDBManager shareManager] openDataBase:@"lives.sqlite"];
    
    return YES;
}

// 实时监测网络状态
- (void)checkNetworkstate {

    // 监听网络状态发生改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange) name:kReachabilityChangedNotification object:nil];
    _reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [_reachability startNotifier];
}

- (void)networkChange {

    NSString *tip = nil;
    
    // 获取当前网络状态
    XYNetworkState currentState = [XYNetworkTool currnetNetworkState];
    if (currentState == _previousState) return;
    
    _previousState = currentState;
    
    switch (currentState) {
        case XYNetworkStateNone:
            tip = @"当前无网络, 请检查您的网络";
            break;
        case XYNetworkState2G:
            tip = @"切换到了2G网络, 请注意流量";
            break;
        case XYNetworkState3G:
            tip = @"切换到了3G网络, 请注意流量";
            break;
        case XYNetworkState4G:
            tip = @"切换到了4G网络, 请注意流量";
            break;
        case XYNetworkStateWIFI:
            tip = nil;
            break;
            
        default:
            break;
    }
     NSLog(@"网络状态码----%ld", currentState);
    if (tip.length) {
//        [[[UIAlertView alloc] initWithTitle:@"喵播" message:tip delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil] show];
        [self xy_showMessage:tip];
    }
}


@end
