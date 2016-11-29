//
//  UIView+Frame.m
//  
//
//  Created by mofeini on 16/9/6.
//  Copyright © 2016年 sey. All rights reserved.
//

#import "UIView+XYExtension.h"

@implementation UIView (XYExtension)

- (void)setXy_width:(CGFloat)xy_width {

    CGRect rect = self.frame;
    
    rect.size.width = xy_width;
    
    self.frame = rect;
}

- (CGFloat)xy_width {

    return self.frame.size.width;
}

- (void)setXy_height:(CGFloat)xy_height {

    CGRect rect = self.frame;
    
    rect.size.height = xy_height;
    
    self.frame = rect;
}

- (CGFloat)xy_height {

    return self.frame.size.height;
}

- (void)setXy_x:(CGFloat)xy_x {

    CGRect rect = self.frame;
    
    rect.origin.x = xy_x;
    
    self.frame = rect;
}

- (CGFloat)xy_x {

    return self.frame.origin.x;
}

- (void)setXy_y:(CGFloat)xy_y {

    CGRect rect = self.frame;
    
    rect.origin.y = xy_y;
    
    self.frame = rect;
}

- (CGFloat)xy_y {

    return self.frame.origin.y;
}

- (void)setXy_centerX:(CGFloat)xy_centerX {

    CGPoint point = self.center;
    
    point.x = xy_centerX;
    
    self.center = point;
}

- (CGFloat)xy_centerX {

    return self.center.x;
}

- (void)setXy_centerY:(CGFloat)xy_centerY {

    CGPoint point = self.center;
    
    point.y = xy_centerY;
    
    self.center = point;
}

- (CGFloat)xy_centerY {
    
    return self.center.y;
}

// 快速从xib加载第一个
+ (instancetype)xy_viewFromXib {

    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
@end
