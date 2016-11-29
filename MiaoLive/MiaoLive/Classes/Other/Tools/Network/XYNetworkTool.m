//
//  XYNetworkTool.m
//  MiaoLive
//
//  Created by mofeini on 16/11/21.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYNetworkTool.h"

@implementation XYNetworkTool
static XYNetworkTool *_instance;

+ (instancetype)shareNetWork {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [XYNetworkTool manager];
        
        // 设置超时时间
        _instance.requestSerializer.timeoutInterval = 5.0f;
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    });
    return _instance;
}

+ (XYNetworkState)currnetNetworkState {

    NSArray *subviews = [[[xyApp valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    
    XYNetworkState state = XYNetworkStateNone;
    for (id childView in subviews) {
        if ([childView isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            // 获取状态码
            NSInteger networkType =  [[childView valueForKey:@"dataNetworkType"] integerValue];
            switch (networkType) {
                case 0:
                    state = XYNetworkStateNone;
                    break;
                case 1:
                    state = XYNetworkState2G;
                    break;
                case 2:
                    state = XYNetworkState3G;
                    break;
                case 3:
                    state = XYNetworkState4G;
                    break;
                case 5:
                    state = XYNetworkStateWIFI;
                    break;
                default:
                    break;
            }
        }
    }
    
    return state;
}
@end
