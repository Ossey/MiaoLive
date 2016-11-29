//
//  XYRoomLiveController.h
//  MiaoLive
//
//  Created by mofeini on 16/11/22.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  直播控制器

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface XYRoomLiveController : UICollectionViewController
{
    __strong NSArray *_liveItems;     // 直播的数据模型
    NSInteger _currentIndex; // 当前点击的直播的索引
}

/**
 * @explain 创建当前控制器
 *
 * @param   liveItems     直播的数据模型
 * @param   currentIndex  当前点击的直播的索引
 * @return  初始化XYLiveViewController对象
 */
- (instancetype)initWithLives:(NSArray *)liveItems currentIndex:(NSInteger)currentIndex;
@end
NS_ASSUME_NONNULL_END
