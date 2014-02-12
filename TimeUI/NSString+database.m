//
//  NSString+database.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "NSString+database.h"


@implementation NSString (database)
+ (NSString*) updateSql:(NSString *)tableName setFields:(NSArray *)setFields whereArray:(NSArray *)whereFields
{
    NSMutableString* sql = [NSMutableString stringWithFormat:@"update %@ set ", tableName];
    int count = [setFields count];
    for (int i = 0 ; i< count; ++i) {
        [sql appendFormat:@" %@=?", [setFields objectAtIndex:i]];
        if (i < count -1 ) {
            [sql appendString:@","];
        }
    }
    
    return [sql appendingWhereFileds:whereFields decorate:nil];
}
- (NSString*) appendingWhereFileds:(NSArray*)whereFields decorate:(NSString*)decorate
{
    NSMutableString* sql = [self mutableCopy];
    if ([whereFields count]) {
        [sql appendString:@" where "];
    }
    NSInteger count = [whereFields count];
    for (int i = 0; i < count ; ++i) {
        [sql appendFormat:@"%@=? ",[whereFields objectAtIndex:i]];
        if (i != count -1) {
            [sql appendString:@" and "];
        }
    }
    if (decorate) {
        [sql appendFormat:@" %@",decorate];
    }
    return sql;
}
- (NSString*) appendingInBracketsString:(NSString*)str repeatCount:(int)count
{
    NSMutableString* sql = [self mutableCopy];
    [sql appendString:@"("];
    for (int i = 0; i < count; ++i) {
        [sql appendString:str];
        if (i < count -1) {
            [sql appendString:@","];
        }
    }
    [sql appendString:@")"];
    return sql;
}

- (NSString*) appendingInBracketsStrings:(NSArray*)strings
{
    NSMutableString* sql = [self mutableCopy];
    [sql appendString:@"("];
    int count = [strings count];
    for (int i = 0; i < count; ++i) {
        [sql appendString:strings[i]];
        if (i < count -1) {
            [sql appendString:@","];
        }
    }
    [sql appendString:@")"];
    return sql;
}

+ (NSString*) insertSql:(NSString*) tableName columns:(NSArray*)array
{
    NSString* sql = [self stringWithFormat:@"insert into %@  ", tableName];
    sql = [sql appendingInBracketsStrings:array];
    sql = [sql stringByAppendingString:@"  values"];
    sql = [sql appendingInBracketsString:@"?" repeatCount:[array count]];
    return sql;
}
+ (NSString*) selecteSql:(NSArray*)fields tableName:(NSString *)tableName whereArray:(NSArray *)whereFields decorate:(NSString *)decorate
{
    NSMutableString* fieldsStr = [NSMutableString stringWithString:@" "];
    if (fields.count) {
        for (int i = 0 ; i< fields.count; i++) {
            [fieldsStr appendString:fields[i]];
            if (i != fields.count - 1) {
                [fieldsStr appendString:@","];
            }
        }
    } else {
        [fieldsStr appendString:@" *"];
    }
    [fieldsStr appendString:@"  "];
    
    NSString* sql = [NSString stringWithFormat:@"select %@ from %@ ", fieldsStr, tableName];
    return [sql appendingWhereFileds:whereFields decorate:decorate];
}
+ (NSString*) selecteSql:(NSString*)tableName whereArray:(NSArray*)whereFields decorate:(NSString*)decorate
{
//    NSString* sql = [NSString stringWithFormat:@"select * from %@ ", tableName];
//    return [sql appendingWhereFileds:whereFields decorate:decorate];
    return [NSString selecteSql:@[] tableName:tableName whereArray:whereFields decorate:decorate];
}
+ (NSString*) deleteSql:(NSString*)tableName whereArray:(NSArray*)whereFields decorate:(NSString*)decorate
{
    NSMutableString* sql =[NSMutableString stringWithFormat: @"delete from %@ ",tableName];
    return [sql appendingWhereFileds:whereFields decorate:decorate];
}

@end