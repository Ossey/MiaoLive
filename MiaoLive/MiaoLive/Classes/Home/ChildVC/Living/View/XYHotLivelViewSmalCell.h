//
//  XYHotLivelViewSmalCell.h
//  MiaoLive
//
//  Created by mofeini on 16/11/30.
//  Copyright © 2016年 com.test.MiaoLive. All rights reserved.
//  小图模式下的cell

#import <UIKit/UIKit.h>

@class XYLiveItem;

@interface XYHotLivelViewSmalCell : UICollectionViewCell

/** 直播模型 */
@property (nonatomic, strong) XYLiveItem *liveItem;
@end
