//
//  XYCoverView.m
//  LiveDemo
//
//  Created by mofeini on 16/12/7.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYCoverView.h"

@interface XYCoverView ()

@end

@implementation XYCoverView




@end


@implementation XYCoverView (gestureRecognizer)

+ (void)coverViewWithSuperView:(UIView *)superView block:(void(^)(XYCoverView *view))block {
    
    if (superView) {
        XYCoverView *view = [[self alloc] init];
        [superView addSubview:view];
        view.frame = superView.bounds;
        
        /// 给自己添加手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:view action:@selector(panGestureOnSelf:)];
        [view addGestureRecognizer:panGesture];
        
        /// 给父控件添加点按手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(tapGestureOnSuperView:)];
        [superView addGestureRecognizer:tapGesture];
        UIPanGestureRecognizer *panGesture1 = [[UIPanGestureRecognizer alloc] initWithTarget:view action:@selector(panGestureOnSuperView:)];
        [superView addGestureRecognizer:panGesture1];
        
        if (block) {
            block(view);
        }
        
    }
    
}



#pragma mark - Event

/// 手指在父控件的点按手势
- (void)tapGestureOnSuperView:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame = self.superview.frame;
    }];
    
}


/// 手指在当前控件上滑动
- (void)panGestureOnSelf:(UIPanGestureRecognizer *)pan
{
    
    // 取出偏移量
    CGPoint offset = [pan translationInView:self];
    // 计算当前coverView的frame
    self.frame = [self frameWithOffsetX:offset.x];
    // 复位
    [pan setTranslation:CGPointZero inView:self];
    
    if (self.frame.origin.x > 0) { // 向右
        
    } else if (self.frame.origin.x < 0) { // 向左
        CGRect frame = self.frame;
        frame.origin.x = 0;
        self.frame = frame;
        
    }
    
    CGFloat target = 0;
    // 当手指松开时，做自动定位
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 手指离开屏幕
        if (self.frame.origin.x > CGRectGetWidth(self.superview.bounds) * 0.3) {
            target = CGRectGetWidth(self.frame);
        } else if (CGRectGetMaxX(self.frame) < CGRectGetWidth(self.superview.bounds) * 0.3) {
            target = -CGRectGetWidth(self.superview.frame);;
        }
        
        CGFloat offsetX = target - self.frame.origin.x;
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = [self frameWithOffsetX:offsetX];
        }];
    }
    
}


/// 手指在当前控件的父控件上滑动
- (void)panGestureOnSuperView:(UIPanGestureRecognizer *)pan {
    
    // 取出手指在view上的偏移量
    CGPoint offset = [pan translationInView:pan.view];
    
    // 由于coverView上面也有了pan手势，根据事件传递，coverView在显示时会直接响应pan手势，而不会传递给父控件self.view，除非coverView不可以接受事件，所有当self.view可以响应pan事件时，coverView肯定不在显示着
    
    if (offset.x < 0) {
        CGFloat target = 0;
        CGFloat offsetX = target - self.frame.origin.x;
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = [self frameWithOffsetX:offsetX];
        }];
        
    }
}


/// 根据x偏移量，水平移动当前控件
- (CGRect)frameWithOffsetX:(CGFloat)offsetX {
    
    CGRect frame = self.frame;
    frame.origin.x += offsetX;
    
    frame.size.height = self.superview.bounds.size.height;
    return frame;
}

@end
