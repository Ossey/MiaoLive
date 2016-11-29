//
//  XYNewLiveFlowLayout.m
//  MiaoLive
//
//  Created by mofeini on 16/11/28.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYNewLiveFlowLayout.h"

@implementation XYNewLiveFlowLayout

- (void)prepareLayout {
    
    [super prepareLayout];
    
    CGFloat coum = 3; // 共3列
    CGFloat padding = 1;
    CGFloat wh = (xyScreenW - coum * padding) / coum;
    self.itemSize = CGSizeMake(wh, wh);
    self.minimumLineSpacing = padding;
    self.minimumInteritemSpacing = padding;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
}

@end
