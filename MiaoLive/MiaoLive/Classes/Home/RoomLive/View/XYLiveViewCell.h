//
//  XYLiveViewCell.h
//  MiaoLive
//
//  Created by mofeini on 16/11/22.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYLiveItem;
@interface XYLiveViewCell : UICollectionViewCell

/** 直播模型 */
@property (nonatomic, strong) XYLiveItem *liveItem;
/** 相关直播或主播 */
@property (nonatomic, strong) XYLiveItem *relateLiveItem;
/** 父控制器 */
@property (nonatomic, weak) UIViewController *parentVc;
/** 点击关联主播的回调 */
@property (nonatomic, copy) void (^clickRelateLiveBlock)();
@end
