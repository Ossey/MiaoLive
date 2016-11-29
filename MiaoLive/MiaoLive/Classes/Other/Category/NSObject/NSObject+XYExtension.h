//
//  NSObject+XYExtension.h
//  MiaoLive
//
//  Created by mofeini on 16/11/29.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XYExtension)
// 判断是否开启定位服务
- (BOOL)checkupLocationServiceEnabled:(NSMutableArray *)info;
// 判断是否开启摄像头权限
- (BOOL)checkupCameraServiceEnabled:(NSMutableArray *)info;
// 判断设备是否有摄像头
- (BOOL)checkupCameraIsSourceTypeAvailable:(NSMutableArray *)info;
// 判断是否开启麦克风权限
- (BOOL)checkupMicrophoneServiceEnabled:(NSMutableArray *)info;
@end
