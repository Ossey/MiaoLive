//
//  XYLiveUserItem.h
//  MiaoLive
//
//  Created by mofeini on 16/11/28.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYLiveUserItem : NSObject

/** 主播昵称 */
@property (nonatomic, copy) NSString *nickname;
/** 主播相片URL字符串 */
@property (nonatomic, copy) NSString *photo;
/** 性别：0代表女，1代表男 */
@property (nonatomic, copy) NSString *sex;
/** 主播等级 */
@property (nonatomic, assign) NSInteger starlevel;
/** 是否是最新主播，服务器真实返回的为new，但与系统关键字有冲突 */
@property (nonatomic, assign) NSInteger New;
/** 房间ID */
@property (nonatomic, assign) NSInteger roomid;
/** 主播ID */
@property (nonatomic, copy) NSString *useridx;
/** 直播流地址 */
@property (nonatomic, copy) NSString *flv;
/** 服务器ID */
@property (nonatomic, assign) NSInteger serverid;
/** 主播所在位置(城市) */
@property (nonatomic, copy) NSString *position;
/** 观看人数，此时显示的都是0 */
@property (nonatomic, assign) NSInteger allnum;

/******************* 非服务器返回的数据 ************************/
@property (nonatomic, strong) UIImage *starImage; 
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)LiveUserItemWithDict:(NSDictionary *)dict;
@end
