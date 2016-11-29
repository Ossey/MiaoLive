//
//  UIDevice+XYExtension.h
//
//
//  Created by mofeini on 16/9/5.
//  Copyright © 2016年 sey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (XYExtension)
+ (NSString*)deviceVersion;

/** 模拟器 */
UIKIT_EXTERN NSString *const XYDeviceIPhoneSimulator;
@end
