//
//  XYDBManager.h
//  MiaoLive
//
//  Created by mofeini on 16/11/30.
//  Copyright © 2016年 com.test.MiaoLive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface XYDBManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

+ (instancetype)shareManager;
// 打开数据库的方法
- (void)openDataBase:(NSString *)dbName;
@end
