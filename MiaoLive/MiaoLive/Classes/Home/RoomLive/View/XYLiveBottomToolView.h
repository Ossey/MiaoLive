//
//  XYLiveBottomToolView.h
//  MiaoLive
//
//  Created by mofeini on 16/11/26.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, LiveToolType) {
    LiveToolTypePublicTalk = 0,  // 公共聊天
    LiveToolTypePrivateTalk = 1, // 好友私聊
//    LiveToolTypePlaceHolder = 2, // 占位的，暂时无用，请不要使用
    LiveToolTypeSendGift = 3,    // 送礼物
    LiveToolTypeDailytasks = 4,  // 日常任务
    LiveToolTypeContributionList = 5, // 房间贡献榜
    LiveToolTypeShare = 6,       // 分享当前直播间
    LiveToolTypeClose = 7        // 关闭直播间
};

@interface XYLiveBottomToolView : UIView

/**
 * @explain 点击直播底部工具栏按钮事件回调
 *
 * type  外界应根据按钮的类型做不同的事件
 */
@property (nonatomic, copy) void (^liveToolClickBlock)(LiveToolType type);

@end
