
#import <UIKit/UIKit.h>


CGFloat const XYNavigationAndTabAnimationTime = 0.5;
/** 点击直播室公开聊天按钮的通知 */
NSNotificationName const XYLiveClickPublicTaskNotification = @"XYLiveClickPublicTaskNotification";
/** 点击直播室底部房间贡献榜按钮通知 */
NSNotificationName const XYLiveClickContributionListNotification = @"XYLiveClickContributionListNotification";
/** 点击关注界面去看最热直播按钮的通知(当没有关注还有时会显示此按钮) */
NSNotificationName const XYlookHotLiveNotification = @"XYlookHotLiveNotification";
/** 更改显示主播列表的模式的通知 */
NSString *const XYChangeShowLiveTypeNotification = @"XYChangeShowLiveTypeNotification";
/** 本地化数据时 当前时间的key */
NSString *const liveCacheTimeKey = @"liveCacheTimeKey";
/** Home界面所有的子控制器的view即将显示在屏幕上时通知 */
NSNotificationName const XYHomeSubViewsWillShowNotification = @"XYHomeSubViewsWillShowNotification";
