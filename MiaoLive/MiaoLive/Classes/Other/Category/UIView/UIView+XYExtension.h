//
//  UIView+XYExtension.h
//  
//
//  Created by mofeini on 16/9/6.
//  Copyright © 2016年 sey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XYExtension)

@property CGFloat xy_width;

@property CGFloat xy_height;

@property CGFloat xy_x;

@property CGFloat xy_y;

@property CGFloat xy_centerX;

@property CGFloat xy_centerY;

// 快速从xib加载第一个
+ (instancetype)xy_viewFromXib;
@end
