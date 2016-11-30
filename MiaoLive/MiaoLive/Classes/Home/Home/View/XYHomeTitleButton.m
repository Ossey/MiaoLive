//
//  XYHomeTitleButton.m
//  MiaoLive
//
//  Created by mofeini on 16/11/30.
//  Copyright © 2016年 com.test.MiaoLive. All rights reserved.
//

#import "XYHomeTitleButton.h"

@implementation XYHomeTitleButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitle:@"广场" forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"title"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"title_selected"] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
 
    if (self.imageView.xy_x < self.titleLabel.xy_x) {
        // 调整子控件的frame
        self.titleLabel.xy_x = self.imageView.xy_x;
        self.imageView.xy_x = CGRectGetMaxX(self.titleLabel.frame);
        
    }
    
}
// 重写setTitle方法，添加尺寸自适应方法
- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    
    [super setImage:image forState:state];
    
    [self sizeToFit];
}

// 重写setTitle方法，添加尺寸自适应方法
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    
    [super setTitle:title forState:state];
    
    [self sizeToFit];
}
@end
