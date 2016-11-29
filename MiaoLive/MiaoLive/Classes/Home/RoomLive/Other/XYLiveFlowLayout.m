//
//  XYLiveFlowLayout.m
//  MiaoLive
//
//  Created by mofeini on 16/11/22.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYLiveFlowLayout.h"

@implementation XYLiveFlowLayout

- (void)prepareLayout {

    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.itemSize = self.collectionView.frame.size;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

@end
