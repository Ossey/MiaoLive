//
//  XYDBManager.m
//  MiaoLive
//
//  Created by mofeini on 16/11/30.
//  Copyright © 2016年 com.test.MiaoLive. All rights reserved.
//

#import "XYDBManager.h"


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
    
    NSString *createTableSQL = @"create table if not exists t_lives(id integer primary key autoincrement,livesText text not null)";
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:createTableSQL withArgumentsInArray:nil]) {
            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
    }];
    
    
}

@end
