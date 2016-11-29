//
//  XYLiveBottomToolView.m
//  MiaoLive
//
//  Created by mofeini on 16/11/26.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYLiveBottomToolView.h"

@interface XYLiveBottomToolView ()
@property (nonatomic, strong) NSArray *images;
@end

@implementation XYLiveBottomToolView

- (NSArray *)images {
    // 当前视图所有需要显示的图片， 其中有一个为@""是为占位使用的
    return @[@"talk_public_40x40", @"talk_private_40x40", @"", @"talk_sendgift_40x40", @"talk_task", @"talk_rank_40x40", @"talk_share_40x40", @"talk_close_40x40"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    CGFloat btnWH = xyScreenW / self.images.count;
    
    CGFloat btnX = 0;
    for (NSInteger i = 0; i < self.images.count; ++i) {
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:self.images[i]] forState:UIControlStateNormal];
        [self addSubview:button];
        btnX = btnWH * i;
        button.frame = CGRectMake(btnX, 0, btnWH, btnWH);
        button.tag = i;
        if (i != 2) {
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
- (void)btnClick:(UIButton *)btn {

    if (self.liveToolClickBlock) {
        self.liveToolClickBlock(btn.tag);
    }
}
@end
