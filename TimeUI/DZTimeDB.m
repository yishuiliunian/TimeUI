//
//  DZTimeDB.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTimeDB.h"
#import "NSString+database.h"
#import "NSDate+SSToolkitAdditions.h"
#import "DZTime.h"
#import "DZTimeType.h"

static NSString* const kDZTableTimeName = @"DZTIME";
static NSString* const kDZ_T_Time_C_Date_Begin = @"DATE_BEGIN";
static NSString* const kDZ_T_Time_C_Date_End = @"DATE_END";
static NSString* const kDZ_T_Time_C_Detail = @"DETAIL";
static NSString* const kDZ_T_Time_C_Type = @"TYPE";
static NSString* const kDZ_T_Time_C_Guid = @"GUID";


static NSString* const kDZTableType = @"DZTYPE";
static NSString* const kDZ_T_Type_C_Identifiy = @"IDENTIFIY";
static NSString* const kDZ_T_Type_C_Nmae = @"NAME";
static NSString* const kDZ_T_Type_C_Detail = @"DETAIL";

@implementation DZTimeDB

- (BOOL) isExistAtTable:(NSString*)tName primayKey:(NSString*)key value:(id)value
{
    NSString* sql = [NSString selecteSql:tName whereArray:@[key] decorate:Nil];
    FMResultSet* re = [_dataBase executeQuery:sql withArgumentsInArray:@[value]];
    BOOL exist = [re next];
    [re close];
    return exist;
}

- (BOOL) isTimeExist:(DZTime*)time
{
    return [self isExistAtTable:kDZTableTimeName primayKey:kDZ_T_Time_C_Guid value:time.guid];
}

- (BOOL) updateTime:(DZTime *)time
{
    if ([self isTimeExist:time]) {
        NSString* updateSql = [NSString updateSql:kDZTableTimeName setFields:@[kDZ_T_Time_C_Date_Begin,
                                                                               kDZ_T_Time_C_Date_End,
                                                                               kDZ_T_Time_C_Detail,
                                                                               kDZ_T_Time_C_Type] whereArray:@[kDZ_T_Time_C_Guid]];
        return [_dataBase executeUpdate:updateSql withArgumentsInArray:@[[time.begin ISO8601String],
                                                                         [time.end ISO8601String],
                                                                         time.detail,
                                                                         time.typeId,
                                                                         time.guid]];
    } else
    {
        NSString* insertSQL = [NSString insertSql:kDZTableTimeName columns:@[kDZ_T_Time_C_Date_Begin,
                                                                             kDZ_T_Time_C_Date_End,
                                                                             kDZ_T_Time_C_Detail,
                                                                             kDZ_T_Time_C_Type,
                                                                             kDZ_T_Time_C_Guid]];
        return [_dataBase executeUpdate:insertSQL withArgumentsInArray:@[[time.begin ISO8601String],
                                                                         [time.end ISO8601String],
                                                                         time.detail,
                                                                         time.typeId,
                                                                         time.guid]];
    }
}

- (NSArray*) timeArrayFromFMResult:(FMResultSet*)result
{

    NSMutableArray* times = [NSMutableArray new];
    while ([result next]) {
        DZTime* time = [DZTime new];
        time.begin = [NSDate dateFromISO8601String:[result stringForColumn:kDZ_T_Time_C_Date_Begin]];
        time.end  = [NSDate dateFromISO8601String:[result stringForColumn:kDZ_T_Time_C_Date_End]];
        time.detail = [result stringForColumn:kDZ_T_Time_C_Detail];
        time.guid = [result stringForColumn:kDZ_T_Time_C_Guid];
        time.typeId = [result stringForColumn:kDZ_T_Time_C_Type];
        [times addObject:time];
    }
    [result close];
    return times;
}

- (NSArray*) timeArrayFromSQL:(NSString*)sql
{
    return [self timeArrayFromFMResult:[_dataBase executeQuery:sql]];
}

- (NSArray*) allTimes
{
    NSString* sql = [NSString selecteSql:kDZTableTimeName whereArray:nil decorate:Nil];
    return [self timeArrayFromSQL:sql];
}

- (DZTime*) timeByGuid:(NSString*)guid
{
    NSString* sql = [NSString selecteSql:kDZTableTimeName whereArray:@[kDZ_T_Time_C_Guid] decorate:Nil];
    FMResultSet* re = [_dataBase executeQuery:sql withArgumentsInArray:@[guid]];
    return [self timeArrayFromFMResult:re].lastObject;
}


- (BOOL) isExistType:(DZTimeType*)type
{
    return [self isExistAtTable:kDZTableType primayKey:kDZ_T_Type_C_Identifiy value:type.identifiy];
}

- (BOOL) updateTimeType:(DZTimeType*)type
{
    if ([self isExistType:type]) {
        NSString* updateSql = [NSString updateSql:kDZTableType setFields:@[kDZ_T_Type_C_Detail,
                                                                           kDZ_T_Type_C_Nmae] whereArray:@[kDZ_T_Type_C_Identifiy]];
        return [_dataBase executeUpdate:updateSql withArgumentsInArray:@[type.detail, type.name, type.identifiy]];
    } else {
        NSString* insertSql = [NSString insertSql:kDZTableType columns:@[kDZ_T_Type_C_Detail,
                                                                         kDZ_T_Type_C_Nmae,
                                                                         kDZ_T_Type_C_Identifiy]];
        return [_dataBase executeUpdate:insertSql withArgumentsInArray:@[type.detail, type.name, type.identifiy]];
    }
}

- (NSArray*) timeTypeArrayFromFMResult:(FMResultSet*)result
{
    
    NSMutableArray* types = [NSMutableArray new];
    while ([result next]) {
        DZTimeType* type = [DZTimeType new];
        type.identifiy = [result stringForColumn:kDZ_T_Type_C_Identifiy];
        type.name = [result stringForColumn:kDZ_T_Type_C_Nmae];
        type.detail = [result stringForColumn:kDZ_T_Type_C_Detail];
        [types addObject:type];
    }
    [result close];
    return types;
}

- (NSArray*) timeTypeArrayFromSQL:(NSString*)sql
{
    return [self timeTypeArrayFromFMResult:[_dataBase executeQuery:sql]];
}

- (DZTimeType*) tiemTypeByIdentifiy:(NSString*)identifiy
{
    NSString* sql = [NSString selecteSql:kDZTableType whereArray:@[kDZ_T_Type_C_Identifiy] decorate:Nil];
    FMResultSet* re = [_dataBase executeQuery:sql withArgumentsInArray:@[identifiy]];
    return [self timeTypeArrayFromFMResult:re].lastObject;
}

- (NSArray*) allTimeTypes
{
    NSString* sql = [NSString selecteSql:kDZTableType whereArray:Nil decorate:nil];
    return [self timeTypeArrayFromSQL:sql];
}

@end
