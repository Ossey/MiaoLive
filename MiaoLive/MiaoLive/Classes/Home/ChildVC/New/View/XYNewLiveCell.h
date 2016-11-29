//
//  XYNewLiveCell.h
//  MiaoLive
//
//  Created by mofeini on 16/11/28.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYLiveUserItem;
@interface XYNewLiveCell : UICollectionViewCell

/** 主播用户模型 */
@property (nonatomic, strong) XYLiveUserItem *userItem;
@end
