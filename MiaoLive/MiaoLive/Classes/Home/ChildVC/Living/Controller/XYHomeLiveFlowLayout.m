//
//  XYHomeLiveFlowLayout.m
//  MiaoLive
//
//  Created by mofeini on 16/11/30.
//  Copyright © 2016年 com.test.MiaoLive. All rights reserved.
//

#import "XYHomeLiveFlowLayout.h"

@implementation XYHomeLiveFlowLayout
@synthesize columnNumber = _columnNumber;


- (void)prepareLayout {
    
    [super prepareLayout];
    
    CGFloat padding = self.columnNumber == 2 ? 1: 0;
    CGFloat wh = self.columnNumber == 2 ? (xyScreenW - self.columnNumber * padding) / self.columnNumber : xyScreenW;
    self.itemSize = CGSizeMake(wh, wh);
    self.minimumLineSpacing = padding;
    self.minimumInteritemSpacing = padding;
//    self.headerReferenceSize = CGSizeMake(xyScreenW, 100); // 设置collectionView头部视图的尺寸
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
    
}


- (void)setColumnNumber:(NSInteger)columnNumber {
    
    _columnNumber = columnNumber;
    
    [self.collectionView reloadData];
}

- (NSInteger)columnNumber {
    
    return _columnNumber ?: 1;
}

@end
