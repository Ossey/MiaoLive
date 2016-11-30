//
//  XYLiveItem.h
//  MiaoLive
//
//  Created by mofeini on 16/11/21.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface XYLiveItem : NSObject

/** 所在城市 */
@property (nonatomic, copy) NSString *gps;
/** 直播流地址 */
@property (nonatomic, copy) NSString *flv;
/** 用户ID (针对用户注册的渠道) */
@property (nonatomic, copy) NSString *userId;
/** 主播昵称 */
@property (nonatomic, copy) NSString *myname;
/** 直播星际 */
@property (nonatomic, assign) NSInteger starlevel;
/** 主播头像URL， 实际是小图 */
@property (nonatomic, copy) NSString *smallpic;
/** 主播图URL ， 实际位大图 */
@property (nonatomic, copy) NSString *bigpic;
/** 主播个性签名 */
@property (nonatomic, copy) NSString *signatures;
/** 喵喵号 */
@property (nonatomic, copy) NSString *useridx;
/** 直播所在的服务器 */
@property (nonatomic, assign) NSInteger serverid;
/** 直播所在的房间号码 */
@property (nonatomic, assign) NSInteger roomid;
/** 最热直播排行 */
@property (nonatomic, assign) NSInteger pos;
/** 观看直播的用户数量 */
@property (nonatomic, assign) NSInteger allnum;
/** 家族名称 */
@property (nonatomic, copy) NSString *familyName;
/** 是否签约 */
@property (nonatomic, assign) BOOL isSign;
/** 级别 */
@property (nonatomic, assign) NSInteger grade;

/****************** 非服务器返回的数据 *******************************/
/** starImage */
@property (nonatomic, strong) UIImage *starImage;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)LiveItemWithDict:(NSDictionary *)dict;

@end
NS_ASSUME_NONNULL_END
