//
//  NSObject+XYExtension.m
//  MiaoLive
//
//  Created by mofeini on 16/11/29.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "NSObject+XYExtension.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XYShowTipView.h"

@implementation NSObject (XYExtension)

// 判断是否开启麦克风权限
- (BOOL)checkupMicrophoneServiceEnabled:(NSMutableArray *)info {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        __block BOOL flag;
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted){
            if (granted) {
                [info addObject:@{openStatuKey: @"1", checkTypeKey: MicrophoneValue, msgKey: @"可以使用麦克风"}];
                flag = YES;
            } else {
                
                [info addObject:@{openStatuKey: @"0", checkTypeKey: MicrophoneValue, msgKey: @"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"}];
                
                flag = NO;
            }
        }];
        return flag;
    } else {
        return NO;
    }
}

// 判断设备是否有摄像头
- (BOOL)checkupCameraIsSourceTypeAvailable:(NSMutableArray *)info {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [info addObject:@{openStatuKey: @"0", checkTypeKey: CameraAuthorityValue, msgKey: @"您的设备没有摄像头或者相关的驱动, 不能进行直播"}];
        
        return NO;
    } else {
        [info addObject:@{openStatuKey: @"1", checkTypeKey: CameraAuthorityValue, msgKey: @"摄像头可以正常使用"}];
        
        return YES;
    }
    
}

// 判断是否开启摄像头权限
- (BOOL)checkupCameraServiceEnabled:(NSMutableArray *)info {
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
        
        [info addObject:@{openStatuKey: @"0", checkTypeKey: CameraValue, msgKey: @"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头"}];
        return NO;
    } else {
        [info addObject:@{openStatuKey: @"1", checkTypeKey: CameraValue, msgKey: @"已启用摄像头"}];
        
        return YES;
    }
}

// 判断是否开启定位服务
- (BOOL)checkupLocationServiceEnabled:(NSMutableArray *)info {
    
    // 开启定位权限
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status)
    {
        [info addObject:@{openStatuKey: @"0", checkTypeKey: LocationValue, msgKey: @"app需要访问您的地理。\n请启用定位-设置/隐私/定位"}];
        return NO;
        
    } else {
        [info addObject:@{openStatuKey: @"1", checkTypeKey: LocationValue, msgKey: @"可以定位"}];
        return YES;
    }
    
}


@end
