//
//  XYNetworkTool.h
//  MiaoLive
//
//  Created by mofeini on 16/11/21.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  网络请求单例类

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, XYNetworkState) {

    XYNetworkStateNone = 0,
    XYNetworkState2G,
    XYNetworkState3G,
    XYNetworkState4G,
    XYNetworkStateWIFI
};

@interface XYNetworkTool : AFHTTPSessionManager

+ (instancetype)shareNetWork;

/**
 * @explain 判断当前网络状态
 *
 * @return  当前网络状态
 */
+ (XYNetworkState)currnetNetworkState;
@end
