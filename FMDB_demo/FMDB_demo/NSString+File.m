//
//  NSString+File.m
//  FMDB_Demo
//
//  Created by xx on 16/11/10.
//  Copyright © 2016年 d.d. All rights reserved.
//

#import "NSString+File.h"

@implementation NSString (File)

+ (NSString *)getDocumentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    return path;
}

+ (NSString *)getLibraryPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    return path;
}

+ (NSString *)getCachePath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    return path;
}


@end
