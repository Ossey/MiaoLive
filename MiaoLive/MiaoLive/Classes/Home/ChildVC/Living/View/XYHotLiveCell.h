//
//  XYHotLiveCell.h
//  MiaoLive
//
//  Created by mofeini on 16/11/21.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYLiveItem;
@interface XYHotLiveCell : UICollectionViewCell

/** 直播模型 */
@property (nonatomic, strong) XYLiveItem *liveItem;
@end
