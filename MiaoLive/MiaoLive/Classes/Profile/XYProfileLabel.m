//
//  XYProfileLabel.m
//  MiaoLive
//
//  Created by mofeini on 16/11/30.
//  Copyright © 2016年 com.test.MiaoLive. All rights reserved.
//

#import "XYProfileLabel.h"

@implementation XYProfileLabel

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
}

@end
