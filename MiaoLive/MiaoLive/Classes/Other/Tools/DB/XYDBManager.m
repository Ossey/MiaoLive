//
//  XYDBManager.m
//  MiaoLive
//
//  Created by mofeini on 16/11/30.
//  Copyright © 2016年 com.test.MiaoLive. All rights reserved.
//

#import "XYDBManager.h"
#import "XYLiveItem.h"

@implementation XYDBManager
static XYDBManager *_instance;

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XYDBManager alloc] init];
    });
    return _instance;
}

// 打开数据库的方法
- (void)openDataBase:(NSString *)dbName {
    
    // 获取数据库存储的路径
    NSString *dbFullPath = [xyDocumentPath stringByAppendingPathComponent:dbName];
    NSLog(@"dbFullPath==%@", dbFullPath);
    
    // 创建数据库
    self.dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbFullPath];
    
    // 创建表
    [self createdTable];
}

// 创建表
- (void)createdTable {
    
//    NSString *createTableSQL = @"create table if not exists t_lives(id integer primary key autoincrement,livesText text not null)";
    NSString *createTableSQL = @"create table if not exists t_lives(id integer primary key autoincrement,gps text,flv text,userId text,myname text,starlevel integer,smallpic text,bigpic text,signatures text,useridx text,serverid integer,roomid integer,pos integer,allnum integer,familyName text,isSign integer,grade integer, idStr text NOT NULL)";
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:createTableSQL withArgumentsInArray:nil]) {
            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
    }];
    
    
}


/// 清除本地数据库中的数据
- (void)clearLivesDataBase {
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if ([db open]) {
            
            // 先查询表中行数的总个数
            NSUInteger count = [db intForQuery:@"select count(*) from t_lives"];
            //        NSLog(@"%ld",count);
            
            // 当缓存的数据大于40条时就删除前面的20数据
            if (count > 100) {
                NSString *delegateSql = @"DELETE FROM t_lives WHERE id < 50 ";
                
                if ([db executeUpdate:delegateSql withArgumentsInArray:nil]) {
                    NSLog(@"已删除本地缓存中最早的40条数据");
                } else {
                    NSLog(@"删除本地数据失败");
                    
                }
                
                
            }
            [db close];
        }
        
        
    }];
    
    
}

/// 判断db是否超时
-(BOOL)databaseTimeOut
{
    // 从偏好设置中取出上次缓存数据的时间
    // 当为空也就是说第一次下载APP，没加载过数据，那么，让它返回YES
    NSDate *oldDate = [[NSUserDefaults standardUserDefaults] objectForKey:liveCacheTimeKey];
    if (oldDate == nil) {
        return YES;
    }
    
    // 获取当前时间，与上次缓存数据时的时间比较
    // 伪超时，直接进入刷新，或者将上次刷新时间与这次刷新时间进行比较，当超过超时时间时， 进入刷新状态
    NSDate *nowDate = [NSDate date];
    NSTimeInterval aTimer = [nowDate timeIntervalSinceDate:oldDate];
    int hour = (int)(aTimer/3600);
    if (hour < 3) {
        return NO;
    }
    return YES;
}

/// 插入模型中的数据，并记录缓存时间
-(void)insertDatabaseWithModel:(XYLiveItem *)liveItem ID:(NSString *)idStr
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
       
        if ([db open]) {
            
            NSString *insertSql = @"insert into t_lives(gps,flv,userId,myname,starlevel,smallpic,bigpic,signatures,useridx,serverid,roomid,pos,allnum,familyName,isSign,grade,idStr)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            
            NSArray *array = @[liveItem.gps, liveItem.flv, liveItem.userId, liveItem.myname, @(liveItem.starlevel), liveItem.smallpic, liveItem.bigpic, liveItem.signatures, liveItem.useridx, @(liveItem.serverid), @(liveItem.roomid), @(liveItem.pos), @(liveItem.allnum), liveItem.familyName, @(liveItem.isSign), @(liveItem.grade), idStr];
            [db executeUpdate:insertSql withArgumentsInArray:array];
        }
        [db close];
    }];
 
    // 将上次刷新时间存在本地当中
    //这个时间存储写在请求完成之后，让它只执行一次，而不是插入一次数据，执行记录一次时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:liveCacheTimeKey];
}


//将数据库里面的东西取出来，然后刷新表，之所以传递一个cachePage的属性，是因为一般来说刷新都是分页来的，有的一页20组数据，有的一页15组数据，总不能将所有的缓存数据一次性的全部加载出来，这样导致分页混乱。我的一页是10组数据
- (void)queryDatabaseCompletion:(void (^)(NSArray *))completionHandler
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {

            NSString *querySQL = @"SELECT * FROM t_lives";
            NSLog(@"%@", querySQL);
            FMResultSet *set = [db executeQuery:querySQL withArgumentsInArray:nil];
            NSMutableArray *liveDataArr = [NSMutableArray array];
            while ([set next]) {
                // 创建模型对象
                XYLiveItem *liveItem = [[XYLiveItem alloc] init];
                
                liveItem.gps = [set stringForColumn:@"gps"];
                liveItem.flv = [set stringForColumn:@"flv"];
                liveItem.userId = [set stringForColumn:@"userId"];
                liveItem.myname = [set stringForColumn:@"myname"];
                liveItem.starlevel = [set intForColumn:@"starlevel"];
                liveItem.smallpic = [set stringForColumn:@"smallpic"];
                liveItem.bigpic = [set stringForColumn:@"bigpic"];
                liveItem.signatures = [set stringForColumn:@"signatures"];
                liveItem.useridx = [set stringForColumn:@"useridx"];
                liveItem.serverid = [set intForColumn:@"serverid"];
                liveItem.roomid = [set intForColumn:@"roomid"];
                liveItem.pos = [set intForColumn:@"pos"];
                liveItem.allnum = [set intForColumn:@"allnum"];
                liveItem.familyName = [set stringForColumn:@"familyName"];
                liveItem.isSign = [set intForColumn:@"isSign"];
                liveItem.grade = [set intForColumn:@"grade"];
                
                [liveDataArr addObject:liveItem];
            }
            [set close];
            if (completionHandler) {
                completionHandler(liveDataArr);
            }
        }
        
        [db close];
    }];
    
}

- (void)queryDatabaseWithRange:(NSRange)range completion:(void (^)(NSArray *))completionHandler {
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            
            NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM t_lives LIMIT %lu, %lu",range.location, range.length];
            NSLog(@"%@", querySQL);
            FMResultSet *set = [db executeQuery:querySQL withArgumentsInArray:nil];
            NSMutableArray *liveDataArr = [NSMutableArray array];
            while ([set next]) {
                // 创建模型对象
                XYLiveItem *liveItem = [[XYLiveItem alloc] init];
                
                liveItem.gps = [set stringForColumn:@"gps"];
                liveItem.flv = [set stringForColumn:@"flv"];
                liveItem.userId = [set stringForColumn:@"userId"];
                liveItem.myname = [set stringForColumn:@"myname"];
                liveItem.starlevel = [set intForColumn:@"starlevel"];
                liveItem.smallpic = [set stringForColumn:@"smallpic"];
                liveItem.bigpic = [set stringForColumn:@"bigpic"];
                liveItem.signatures = [set stringForColumn:@"signatures"];
                liveItem.useridx = [set stringForColumn:@"useridx"];
                liveItem.serverid = [set intForColumn:@"serverid"];
                liveItem.roomid = [set intForColumn:@"roomid"];
                liveItem.pos = [set intForColumn:@"pos"];
                liveItem.allnum = [set intForColumn:@"allnum"];
                liveItem.familyName = [set stringForColumn:@"familyName"];
                liveItem.isSign = [set intForColumn:@"isSign"];
                liveItem.grade = [set intForColumn:@"grade"];
                
                [liveDataArr addObject:liveItem];
            }
            [set close];
            if (completionHandler) {
                completionHandler(liveDataArr);
            }
        }
        
        [db close];
    }];
}

/// 获取的是数据库缓存的数据条数
-(NSInteger)databaseCount {
    __block NSInteger count = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
       
        if ([db open]) {
            count = [db intForQuery:@"SELECT count(*) from t_lives"];
        }
        
        [db close];
        
    }];
    
    return count;
    
}

/// 判断idStr是否存在
- (BOOL)isExistWithID:(NSString *)idStr {

    __block BOOL isExist = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            
            
            FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM t_lives where idStr = ?", idStr];
            while ([resultSet next]) {
                if ([resultSet stringForColumn:@"idStr"]) {
//                    NSLog(@"%@", idStr);
                    isExist = NO;
                } else {
                    isExist = YES;
                }
            }
            [db close];
        }
    }];
    return isExist;
}

@end
