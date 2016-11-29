//
//  XYHomeADCell.h
//  MiaoLive
//
//  Created by mofeini on 16/11/22.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XRCarouselView.h>

@class XYTopADItem;
@interface XYHotADCell : UICollectionReusableView <XRCarouselViewDelegate>

/** 广告模型数组 */
@property (nonatomic, strong) NSArray *adItems;

/**
 * @explain 点击图片的block回调
 * 回调点击图片对应的banner模型
 */
@property (nonatomic, copy) void(^imageClickBlock)(XYTopADItem *adItem);
@end
