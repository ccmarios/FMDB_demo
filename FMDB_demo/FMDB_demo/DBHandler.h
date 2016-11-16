//
//  DBHandler.h
//  FMDB_demo
//
//  Created by xx on 16/11/16.
//  Copyright © 2016年 d.d. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHandler : NSObject

/**
 *  初始化数据库
 *
 *  @return DBHandler
 */
+ (DBHandler *)sharedInstance;

/**
 *  创建数据库 or 同时创建了数据库表
 */
- (void)createDB;



// 数据插入
- (void)historyInsertDic:(NSDictionary *)dic;

// 移除数据库表内容
- (void)historyInfoRemoveList;

// 获取数据
- (NSArray *)gethistoryInfoList;

// 移除单条数据
- (void)deleteInfoWithName:(NSString *)name;

@end
