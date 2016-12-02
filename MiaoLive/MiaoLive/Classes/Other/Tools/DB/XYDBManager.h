//
//  XYDBManager.h
//  MiaoLive
//
//  Created by mofeini on 16/11/30.
//  Copyright © 2016年 com.test.MiaoLive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@class XYLiveItem;
@interface XYDBManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

+ (instancetype)shareManager;
/// 打开数据库的方法
- (void)openDataBase:(NSString *)dbName;

/// 清除本地数据库中缓存的数据
- (void)clearLivesDataBase;

/// 判断db是否超时
-(BOOL)databaseTimeOut;

/// 获取的是数据库缓存的数据条数
-(NSInteger)databaseCount;

/// 查找数据库中的数据,并回调结果
-(void)queryDatabaseCompletion:(void(^)(NSArray *resultArray))completionHandler;
/// 根据range查找数据库中的数据,并回调结果
-(void)queryDatabaseWithRange:(NSRange)range completion:(void(^)(NSArray *resultArray))completionHandler;

/// 插入模型中的数据，并记录缓存时间, idStr是为了防止数据重复
-(void)insertDatabaseWithModel:(XYLiveItem *)liveItem ID:(NSString *)idStr;

/// 判断idStr是否存在，防止插入重复数据
- (BOOL)isExistWithID:(NSString *)idStr;

@end
