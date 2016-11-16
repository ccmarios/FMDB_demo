//
//  NSString+File.h
//  FMDB_Demo
//
//  Created by xx on 16/11/10.
//  Copyright © 2016年 d.d. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Format3Str(str1, str2, str3)            [NSString stringWithFormat:@"%@%@%@",str1, str2, str3]

@interface NSString (File)

//获取documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName;

//获取Library下的文件路径
+ (NSString *)getLibraryPath:(NSString *)fileName;

//获取Cache下的文件路径
+ (NSString *)getCachePath:(NSString *)fileName;

@end
