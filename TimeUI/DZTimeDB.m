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
#import <NSDate-TKExtensions.h>
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



//
static NSString* const kDZTableMeta = @"DZMETA";
static NSString* const kDZ_T_Meta_C_NAME = @"META_NAME";
static NSString* const kDZ_T_Meta_C_KEY = @"META_KEY";
static NSString* const kDZ_T_Meta_C_VALUE = @"META_VALUE";
//


/**
 *  同步的version存储的key定义
 */

static NSString* const kDZSyncVersion = @"sync_version";
static NSString* const kDZSyncTimeVersion = @"time";
static NSString* const kDZSyncTimeTypeVersion = @"time.type";

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
        return [_dataBase executeUpdate:updateSql withArgumentsInArray:@[[time.dateBegin ISO8601String],
                                                                         [time.dateEnd ISO8601String],
                                                                         time.detail,
                                                                         time.typeGuid,
                                                                         time.guid]];
    } else
    {
        NSString* insertSQL = [NSString insertSql:kDZTableTimeName columns:@[kDZ_T_Time_C_Date_Begin,
                                                                             kDZ_T_Time_C_Date_End,
                                                                             kDZ_T_Time_C_Detail,
                                                                             kDZ_T_Time_C_Type,
                                                                             kDZ_T_Time_C_Guid]];
        return [_dataBase executeUpdate:insertSQL withArgumentsInArray:@[[time.dateBegin ISO8601String],
                                                                         [time.dateEnd ISO8601String],
                                                                         time.detail,
                                                                         time.typeGuid,
                                                                         time.guid]];
    }
}

- (NSArray*) timeArrayFromFMResult:(FMResultSet*)result
{

    NSMutableArray* times = [NSMutableArray new];
    while ([result next]) {
        DZTime* time = [DZTime new];
        time.dateBegin = [NSDate dateFromISO8601String:[result stringForColumn:kDZ_T_Time_C_Date_Begin]];
        time.dateEnd  = [NSDate dateFromISO8601String:[result stringForColumn:kDZ_T_Time_C_Date_End]];
        time.detail = [result stringForColumn:kDZ_T_Time_C_Detail];
        time.guid = [result stringForColumn:kDZ_T_Time_C_Guid];
        time.typeGuid = [result stringForColumn:kDZ_T_Time_C_Type];
        time.userGuid = self.userGuid;
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

- (NSArray*) timesByType:(DZTimeType *)type
{
    NSString* sql = [NSString selecteSql:kDZTableTimeName whereArray:@[kDZ_T_Time_C_Type] decorate:Nil];
    FMResultSet* reset = [_dataBase executeQuery:sql withArgumentsInArray:@[type.identifiy]];
    return [self timeArrayFromFMResult:reset];
}

- (BOOL) delteTimeType:(DZTimeType *)type
{
    NSString* sql = [NSString deleteSql:kDZTableType whereArray:@[kDZ_T_Type_C_Identifiy] decorate:nil];
    return [_dataBase executeUpdate:sql withArgumentsInArray:@[type.identifiy]];
}

- (NSArray*) timesInOneWeakByType:(DZTimeType *)type
{
    NSDate* now = [NSDate date];
    NSDate* oneWeak = [now TKDateBySubtractingWeeks:1];
    NSString* sql = [NSString selecteSql:kDZTableTimeName whereArray:@[kDZ_T_Time_C_Type] decorate:[NSString stringWithFormat:@" and %@ > ? and %@ < ?", kDZ_T_Time_C_Date_Begin, kDZ_T_Time_C_Date_End]];
    FMResultSet* rest = [_dataBase executeQuery:sql withArgumentsInArray:@[type.identifiy, [oneWeak ISO8601String], [now ISO8601String]]];
    return [self timeArrayFromFMResult:rest];
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

//
- (NSString*) metaValueByName:(NSString*)name key:(NSString*)key
{
    NSString* sql = [NSString selecteSql:kDZTableMeta whereArray:@[kDZ_T_Meta_C_NAME, kDZ_T_Meta_C_KEY] decorate:nil];
    FMResultSet* re = [_dataBase executeQuery:sql withArgumentsInArray:@[name, key]];
    BOOL exist = [re next];
    NSString* value = nil;
    if (exist) {
        value = [re stringForColumn:kDZ_T_Meta_C_VALUE];
    }
    [re close];
    return value;
}

- (BOOL) updateValueByName:(NSString*)name key:(NSString*)key value:(NSString*)value
{
    if ([self metaValueByName:name key:key]) {
        NSString* updateSql = [NSString updateSql:kDZTableMeta setFields:@[kDZ_T_Meta_C_VALUE] whereArray:@[kDZ_T_Meta_C_NAME, kDZ_T_Meta_C_KEY]];
        return [_dataBase executeUpdate:updateSql, value, name, key];
    } else {
        NSString* insertSql = [NSString insertSql:kDZTableMeta columns:@[kDZ_T_Meta_C_VALUE,kDZ_T_Meta_C_NAME,kDZ_T_Meta_C_KEY]];
         return [_dataBase executeUpdate:insertSql, value, name, key];
    }
}

- (BOOL) setSyncVersion:(NSString*)key version:(int64_t)version
{
    return [self updateValueByName:kDZSyncVersion key:key value:[@(version) stringValue]];
}

- (int64_t) getSyncVersion:(NSString*)key
{
    NSString* value = [self metaValueByName:kDZSyncVersion key:key];
    if (!value) {
        return -1;
    }
    return [value longLongValue];
}

- (BOOL) setTimeVersion:(int64_t)version
{
    return [self setSyncVersion:kDZSyncTimeVersion version:version];
}

- (int64_t) timeVersion
{
    return [self getSyncVersion:kDZSyncTimeVersion];
}

- (BOOL) setTimeTypeVersion:(int64_t)version
{
    return [self setSyncVersion:kDZSyncTimeTypeVersion version:version];
}

- (int64_t) timeTypeVersion
{
    return [self getSyncVersion:kDZSyncTimeTypeVersion];
}

@end
