//
//  DBHandler.m
//  FMDB_demo
//
//  Created by xx on 16/11/16.
//  Copyright © 2016年 d.d. All rights reserved.
//

#import "DBHandler.h"
#import <FMDB.h>

@implementation DBHandler{
    FMDatabase *_dataBase;
}

static DBHandler *instance = nil;

+ (DBHandler *)sharedInstance{
    @synchronized(self){
        if (instance == nil) {
            instance = [[[self class]alloc]init];
        }
    }
    return instance;
}

- (void)createDB{
    
    NSString *filePath = [NSString getLibraryPath:@"sampleDB_1.0.0.db"];
    NSLog(@"%@",filePath);
    _dataBase = [FMDatabase databaseWithPath:filePath];
    
    if([_dataBase open]){
        [self createDBTableDB:_dataBase];
        NSLog(@"数据库创建打开成功");
    }else{
        NSLog(@"数据库创建打开失败");
    }
}

- (void)createDBTableDB:(FMDatabase *)DB{
    [DB executeUpdate:@"CREATE TABLE IF NOT EXISTS sampleTable(name TEXT,age NEXT)"];
    [DB close];
}

// 获取数据
- (NSArray *)gethistoryInfoList{
    [_dataBase open];
    FMResultSet *resRoute = [_dataBase executeQuery:@"select * from sampleTable"];
    NSArray *routeArray = [self selectFromResultSet:resRoute];
    [_dataBase close];
    return routeArray;
}

// 插入数据
- (void)historyInsertDic:(NSDictionary *)dic{
    NSArray *array = [NSArray array];

    if ([self isOpenDatabese:_dataBase]) {
        FMResultSet *result =  [_dataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM sampleTable WHERE %@ LIMIT 1",[self getDBWhereStrWithDic:dic]]];
        
        array =  [self getArrWithFMResultSet:result keyTypes:@{@"name":@"TEXT",
                                                             @"age":@"TEXT"}];
    }
    
    
    //如果数据已存在，则更新数据
    if (array.count) {
        
        if ([self isOpenDatabese:_dataBase]) {
            NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE sampleTable SET %@ WHERE %@", [self getDBSetStrWithDic:dic], [self getDBWhereStrWithDic:dic]]];
            [_dataBase executeUpdate:sql];
        }
        
        
        
    }else{ //否则插入数据
        
        if ([self isOpenDatabese:_dataBase]) {
            NSArray *keys = [dic allKeys];
            NSArray *values = [dic allValues];
            NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"INSERT INTO sampleTable ("]];
            NSInteger count = 0;
            for (NSString *key in keys) {
                [sql appendString:key];
                count ++;
                if (count < [keys count]) {
                    [sql appendString:@", "];
                }
            }
            [sql appendString:@") VALUES ("];
            for (int i = 0; i < [values count]; i++) {
                [sql appendString:@"?"];
                if (i < [values count] - 1) {
                    [sql appendString:@","];
                }
            }
            [sql appendString:@")"];
            [_dataBase executeUpdate:sql withArgumentsInArray:values];
        }
    }
    [_dataBase close];
}

- (void)deleteInfoWithName:(NSString *)name{
    [_dataBase open];
    [_dataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM sampleTable WHERE name = '%@'",name]];
    [_dataBase close];
}

// 清除数据
- (void)historyInfoRemoveList{
    if ([self isOpenDatabese:_dataBase]) {
        [_dataBase executeUpdate:@"DELETE FROM sampleTable"];
    }
    [_dataBase close];
}

- (NSMutableArray *)selectFromResultSet:(FMResultSet *)res {
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    while ([res next]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:[res stringForColumn:@"name"] forKey:@"name"];
        [dic setObject:[res stringForColumn:@"age"] forKey:@"age"];
        [dataArray addObject:dic];
    }
    return dataArray;
}

- (NSString *)getDBWhereStrWithDic:(NSDictionary *)dic{
    NSString *str = @"";
    for (NSInteger i = 0 ; i < [[dic allKeys]count]; i++) {
        if (i == 0) {
            if ([[[dic allValues] objectAtIndex:i] isKindOfClass:[NSString class]]) {
                str = Format3Str([[dic allKeys] objectAtIndex:i], @"=", Format3Str(@"'", [[dic allValues] objectAtIndex:i], @"'"));
            }else{
                str = Format3Str([[dic allKeys] objectAtIndex:i], @"=", Format3Str(@"'", [[dic allValues] objectAtIndex:i], @"'"));
            }
        }else{
            if ([[[dic allValues] objectAtIndex:i] isKindOfClass:[NSString class]]) {
                NSString *tempstr = Format3Str([[dic allKeys] objectAtIndex:i], @"=", Format3Str(@"'", [[dic allValues] objectAtIndex:i], @"'"));
                str = Format3Str(str, @" and ", tempstr);
            }else{
                NSString *tempstr = Format3Str([[dic allKeys] objectAtIndex:i], @"=",[[dic allValues] objectAtIndex:i]);
                str = Format3Str(str, @" and ", tempstr);
            }
        }
    }
    return str;
}

- (NSString *)getDBSetStrWithDic:(NSDictionary *)dic{
    NSString *str = @"";
    for (NSInteger i = 0 ; i < [[dic allKeys]count]; i++) {
        if (i == 0) {
            if ([[[dic allValues] objectAtIndex:i] isKindOfClass:[NSString class]]) {
                str = Format3Str([[dic allKeys] objectAtIndex:i], @"=", Format3Str(@"'", [[dic allValues] objectAtIndex:i], @"'"));
            }else{
                str = Format3Str([[dic allKeys] objectAtIndex:i], @"=", Format3Str(@"'", [[dic allValues] objectAtIndex:i], @"'"));
            }
        }else{
            if ([[[dic allValues] objectAtIndex:i] isKindOfClass:[NSString class]]) {
                NSString *tempstr = Format3Str([[dic allKeys] objectAtIndex:i], @"=", Format3Str(@"'", [[dic allValues] objectAtIndex:i], @"'"));
                str = Format3Str(str, @",", tempstr);
            }else{
                NSString *tempstr = Format3Str([[dic allKeys] objectAtIndex:i], @"=",[[dic allValues] objectAtIndex:i]);
                str = Format3Str(str, @",", tempstr);
            }
        }
    }
    return str;
}

-(NSArray *)getArrWithFMResultSet:(FMResultSet *)result keyTypes:(NSDictionary *)keyTypes
{
    NSMutableArray *tempArr = [NSMutableArray array];
    while ([result next]) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < keyTypes.count; i++) {
            NSString *key = [keyTypes allKeys][i];
            NSString *value = [keyTypes valueForKey:key];
            if ([value isEqualToString:@"TEXT"]) {
                //                字符串
                [tempDic setValue:[result objectForColumnName:key] forKey:key];
            }else if([value isEqualToString:@"BLOB"]){
                //                二进制对象
                [tempDic setValue:[NSJSONSerialization JSONObjectWithData:[result dataForColumn:key] options:NSJSONReadingAllowFragments error:nil] forKey:key];
            }else if ([value isEqualToString:@"INTEGER"]){
                //                带符号整数类型
                [tempDic setValue:[NSNumber numberWithInt:[result intForColumn:key]]forKey:key];
            }else if ([value isEqualToString:@"BOOLEAN"]){
                //                BOOL型
                [tempDic setValue:[NSNumber numberWithBool:[result boolForColumn:key]] forKey:key];
            }else if ([value isEqualToString:@"DATE"]){
                //                date
                [tempDic setValue:[result dateForColumn:key] forKey:key];
            }else if ([value isEqualToString:@""]){
                [tempDic setValue:[result objectForColumnName:key] forKey:key];
            }else{
                
            }
        }
        [tempArr addObject:tempDic];
    }
    return tempArr;
}

-(BOOL)isOpenDatabese:(FMDatabase *)db{
    if (![db open]) {
        [db open];
    }
    return YES;
}

@end
