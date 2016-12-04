//
//  XYLiveTopListView.h
//  ViewDEMO
//
//  Created by mofeini on 16/12/3.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYLiveItem;
@interface XYLiveTopListView : UIView

@property (nonatomic, strong) XYLiveItem *liveItem;

/** 正在观看直播的用户列表 */
@property (nonatomic, weak, readonly) UICollectionView *watchLiveUserListView;
/** 当前直播详情view */
@property (nonatomic, weak, readonly) UIView *liveUserDetailsView;
@property (nonatomic, weak, readonly) UIImageView *iconView;
@property (nonatomic, weak, readonly) UIButton *followBtn;
@property (nonatomic, weak, readonly) UILabel *watchNumber;
@property (nonatomic, weak, readonly) UILabel *liveUserNameLabel;

@property (nonatomic, weak, readonly) UIView *giftContentView;
/** 当前主播喵粮控件 */
@property (nonatomic, weak, readonly) UIButton *giftButton;
/** 当前主播宝宝数量控件 */
@property (nonatomic, weak, readonly) UIButton *bobyButton;

/** 当前喵播号 */
@property (nonatomic, weak, readonly) UILabel *useridxLabel;

@property (nonatomic, strong, readonly) UICollectionViewFlowLayout *flowLayout;
@end


@interface XYUserListViewFlowLayout : UICollectionViewFlowLayout

@end

@interface XYWatchUserListView : UICollectionView

@end

@interface XYWatchUserListViewCell : UICollectionViewCell

@end

