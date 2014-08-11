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
#import "DZAnalysisManager.h"
static NSString* const kDZTableTimeName = @"DZTIME";
static NSString* const kDZ_T_Time_C_Date_Begin = @"DATE_BEGIN";
static NSString* const kDZ_T_Time_C_Date_End = @"DATE_END";
static NSString* const kDZ_T_Time_C_Detail = @"DETAIL";
static NSString* const kDZ_T_Time_C_Type = @"TYPE";
static NSString* const kDZ_T_Time_C_Guid = @"GUID";
static NSString* const kDZ_T_Time_C_DeviceGUID = @"DEVICE_GUID";
static NSString* const kDZ_T_Time_C_Local_Changed = @"LOCAL_CHANGED";

static NSString* const kDZTableType = @"DZTYPE";
static NSString* const kDZ_T_Type_C_GUID = @"GUID";
static NSString* const kDZ_T_Type_C_Nmae = @"NAME";
static NSString* const kDZ_T_Type_C_Detail = @"DETAIL";
static NSString* const kDZ_T_Type_C_CreateDate = @"CREATE_DATE";
static NSString* const kDZ_T_Type_C_LocalChanged = @"LOCAL_CHANGED";
static NSString* const kDZ_T_Type_C_Other_Infos = @"OTHER_INFOS";
static NSString* const kDZ_T_Type_C_FINISHED = @"FINISHED";


DEFINE_NSStringValue(TableDeletedObject, DZDELETED);
DEFINE_NSStringValue(_T_DELETED_C_GUID, GUID);
DEFINE_NSStringValue(_T_DELETED_C_TYPE, TYPE);
DEFINE_NSStringValue(_T_DELETED_C_DATE, DELETEDDATE);

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
static NSString* const KDZSyncTimeDeletedVersion = @"time.deleted";

@implementation DZTimeDB
@dynamic lastError;
- (NSError*) lastError
{
    return _dataBase.lastError;
}
#pragma mark - Common Tools
- (BOOL) isExistAtTable:(NSString*)tName primayKey:(NSString*)key value:(id)value
{
    NSString* sql = [NSString selecteSql:tName whereArray:@[key] decorate:Nil];
    FMResultSet* re = [_dataBase executeQuery:sql withArgumentsInArray:@[value]];
    BOOL exist = [re next];
    [re close];
    return exist;
}

#pragma mark - Deleted

- (BOOL) isDeletedRowExistByGuid:(NSString*)guid
{
    return [self isExistAtTable:kDZTableDeletedObject primayKey:kDZ_T_DELETED_C_GUID value:guid];
}

- (BOOL) updateDeletedObject:(DZDeletedObject*)object
{
    BOOL ret;
    if ([self isDeletedRowExistByGuid:object.guid]) {
        NSString* updateSql = [NSString updateSql:kDZTableDeletedObject setFields:@[kDZ_T_DELETED_C_DATE,
                                                                                    kDZ_T_DELETED_C_TYPE] whereArray:@[kDZ_T_DELETED_C_GUID]];
        ret = [_dataBase executeUpdate:updateSql, [object.deletedDate ISO8601String],
               object.type,
               object.guid];
    } else {
        NSString* insertSql = [NSString insertSql:kDZTableDeletedObject columns:@[kDZ_T_DELETED_C_DATE,
                                                                                  kDZ_T_DELETED_C_TYPE,
                                                                                  kDZ_T_DELETED_C_GUID]];
        ret = [_dataBase executeUpdate:insertSql, [object.deletedDate ISO8601String],
               object.type,
               object.guid];
    }
    return ret;
}

- (NSArray*) deletedObjectsFromResult:(FMResultSet*)result
{
    NSMutableArray* deleteds = [NSMutableArray array];
    while ([result next]) {
        DZDeletedObject* object = [DZDeletedObject new];
        object.guid = [result stringForColumn:kDZ_T_DELETED_C_GUID];
        object.type = [result stringForColumn:kDZ_T_DELETED_C_TYPE];
        object.deletedDate = [NSDate dateFromISO8601String:[result stringForColumn:kDZ_T_DELETED_C_DATE]];
        [deleteds addObject:object];
    }
    [result close];
    return deleteds;
}

- (NSArray*) deletedObjectsArrayFromSQL:(NSString*)sql
{
    return [self deletedObjectsFromResult:[_dataBase executeQuery:sql]];
}

- (NSArray*) allDeletedObjcts
{
    NSString* sql = [NSString selecteSql:kDZTableTimeName whereArray:nil decorate:Nil];
    return [self deletedObjectsArrayFromSQL:sql];
}
#pragma mark - Time

- (BOOL) isTimeExist:(DZTime*)time
{
    return [self isExistAtTable:kDZTableTimeName primayKey:kDZ_T_Time_C_Guid value:time.guid];
}

- (BOOL) updateTime:(DZTime *)time
{
    BOOL ret;
    if ([self isTimeExist:time]) {
        NSString* updateSql = [NSString updateSql:kDZTableTimeName setFields:@[kDZ_T_Time_C_Date_Begin,
                                                                               kDZ_T_Time_C_Date_End,
                                                                               kDZ_T_Time_C_Detail,
                                                                               kDZ_T_Time_C_Type,
                                                                               kDZ_T_Time_C_Local_Changed]
                                       whereArray:@[kDZ_T_Time_C_Guid]];
        ret =  [_dataBase executeUpdate:updateSql withArgumentsInArray:@[[time.dateBegin ISO8601String],
                                                                         [time.dateEnd ISO8601String],
                                                                         time.detail,
                                                                         time.typeGuid,
                                                                         @(time.localChanged),
                                                                         time.guid]];
    }
    else
    {
        NSString* insertSQL = [NSString insertSql:kDZTableTimeName columns:@[kDZ_T_Time_C_Date_Begin,
                                                                             kDZ_T_Time_C_Date_End,
                                                                             kDZ_T_Time_C_Detail,
                                                                             kDZ_T_Time_C_Type,
                                                                             kDZ_T_Time_C_Local_Changed,
                                                                             kDZ_T_Time_C_Guid]];
        ret = [_dataBase executeUpdate:insertSQL withArgumentsInArray:@[[time.dateBegin ISO8601String],
                                                                         [time.dateEnd ISO8601String],
                                                                         time.detail,
                                                                         time.typeGuid,
                                                                         @(time.localChanged),
                                                                         time.guid]];
    }
    return  ret;
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
        time.localChanged = [result boolForColumn:kDZ_T_Time_C_Local_Changed];
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

- (NSArray*) allChangedTimes
{
    NSString* sql = [NSString selecteSql:kDZTableTimeName whereArray:@[kDZ_T_Time_C_Local_Changed] decorate:nil];
    return [self timeArrayFromFMResult:[_dataBase executeQuery:sql withArgumentsInArray:@[@(1)]]];
}

- (BOOL) setTime:(DZTime*)time localchanged:(BOOL)localchanged
{
    if (![self isTimeExist:time]) {
        return NO;
    }
    NSString* updateSQL = [NSString updateSql:kDZTableTimeName setFields:@[kDZ_T_Time_C_Local_Changed] whereArray:@[kDZ_T_Time_C_Guid]];
    return [_dataBase executeUpdate:updateSQL withArgumentsInArray:@[@(localchanged), time.guid]];
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
    FMResultSet* reset = [_dataBase executeQuery:sql withArgumentsInArray:@[type.guid]];
    return [self timeArrayFromFMResult:reset];
}
- (BOOL) deleteTime:(DZTime*)time
{
    return [self deleteTimeByGuid:time.guid];
}


- (BOOL) deleteTimeByGuid:(NSString *)guid
{
    NSAssert(guid, @"time guid is null");
    NSString* deletesql = [NSString deleteSql:kDZTableTimeName whereArray:@[kDZ_T_DELETED_C_GUID] decorate:nil];
    return [_dataBase executeUpdate:deletesql,guid];
}
- (BOOL) hiddenTimeType:(DZTimeType *)type
{
    type.isFinished = YES;
    type.localChanged = YES;
    return [self updateTimeType:type];
    //
    NSString* sql = [NSString deleteSql:kDZTableType whereArray:@[kDZ_T_Type_C_GUID] decorate:nil];
    return [_dataBase executeUpdate:sql withArgumentsInArray:@[type.guid]];
}

- (BOOL) deleteTimeType:(DZTimeType *)type
{
    return [self deleteTimeTypeByGuid:type.guid];
}

- (BOOL) deleteTimeTypeByGuid:(NSString *)guid
{
    NSAssert(guid, @"time guid is null");
    NSString* deletesql = [NSString deleteSql:kDZTableType whereArray:@[kDZ_T_Type_C_GUID] decorate:nil];
    return [_dataBase executeUpdate:deletesql, guid];
}

- (NSArray*) timesInOneWeakByType:(DZTimeType *)type
{
    NSDate* now = [NSDate date];
    NSDate* oneWeak = [now TKDateBySubtractingWeeks:1];
    NSString* sql = [NSString selecteSql:kDZTableTimeName whereArray:@[kDZ_T_Time_C_Type] decorate:[NSString stringWithFormat:@" and %@ > ? and %@ < ?", kDZ_T_Time_C_Date_Begin, kDZ_T_Time_C_Date_End]];
    FMResultSet* rest = [_dataBase executeQuery:sql withArgumentsInArray:@[type.guid, [oneWeak ISO8601String], [now ISO8601String]]];
    return [self timeArrayFromFMResult:rest];
}
#pragma mark - Time Type
- (BOOL) isExistType:(DZTimeType*)type
{
    return [self isExistAtTable:kDZTableType primayKey:kDZ_T_Type_C_GUID value:type.guid];
}

- (BOOL) updateTimeType:(DZTimeType*)type
{
    if ([self isExistType:type]) {
        NSString* updateSql = [NSString updateSql:kDZTableType setFields:@[kDZ_T_Type_C_Detail,
                                                                           kDZ_T_Type_C_Nmae,
                                                                           kDZ_T_Type_C_CreateDate,
                                                                           kDZ_T_Type_C_FINISHED,
                                                                           kDZ_T_Type_C_LocalChanged,
                                                                           kDZ_T_Type_C_Other_Infos]
                                       whereArray:@[kDZ_T_Type_C_GUID]];
        return [_dataBase executeUpdate:updateSql withArgumentsInArray:@[type.detail,
                                                                         type.name,
                                                                         [type.createDate ISO8601String]  ,
                                                                         @(type.isFinished),
                                                                         @(type.localChanged),
                                                                         type.otherInfos,
                                                                         type.guid]];
    } else {
        NSString* insertSql = [NSString insertSql:kDZTableType columns:@[kDZ_T_Type_C_Detail,
                                                                         kDZ_T_Type_C_Nmae,
                                                                         kDZ_T_Type_C_CreateDate,
                                                                         kDZ_T_Type_C_FINISHED,
                                                                         kDZ_T_Type_C_LocalChanged,
                                                                         kDZ_T_Type_C_Other_Infos,
                                                                         kDZ_T_Type_C_GUID]];
        return [_dataBase executeUpdate:insertSql withArgumentsInArray:@[type.detail,
                                                                         type.name,
                                                                         [type.createDate ISO8601String]  ,
                                                                         @(type.isFinished),
                                                                         @(type.localChanged),
                                                                         type.otherInfos,
                                                                         type.guid]];
    }
}

- (NSArray*) timeTypeArrayFromFMResult:(FMResultSet*)result
{
    
    NSMutableArray* types = [NSMutableArray new];
    while ([result next]) {
        
        DZTimeType* type = [DZTimeType new];
        type.guid = [result stringForColumn:kDZ_T_Type_C_GUID];
        type.name = [result stringForColumn:kDZ_T_Type_C_Nmae];
        type.detail = [result stringForColumn:kDZ_T_Type_C_Detail];
        type.createDate = [NSDate dateFromISO8601String:[result stringForColumn:kDZ_T_Type_C_CreateDate]];
        type.isFinished = [result boolForColumn:kDZ_T_Type_C_FINISHED];
        type.localChanged = [result boolForColumn:kDZ_T_Type_C_LocalChanged];
        type.otherInfos = [result stringForColumn:kDZ_T_Type_C_Other_Infos];
        type.userGuid = self.userGuid;

        [types addObject:type];
    }
    [result close];
    return types;
}

- (NSArray*) timeTypeArrayFromSQL:(NSString*)sql
{
    return [self timeTypeArrayFromFMResult:[_dataBase executeQuery:sql]];
}
- (DZTimeType*) timeTypByGUID:(NSString*)guid
{
    NSString* sql = [NSString selecteSql:kDZTableType whereArray:@[kDZ_T_Type_C_GUID] decorate:Nil];
    FMResultSet* re = [_dataBase executeQuery:sql withArgumentsInArray:@[guid]];
    NSArray* array = [self timeTypeArrayFromFMResult:re];
    return array.lastObject;
}

- (DZTimeType*) tiemTypeByIdentifiy:(NSString*)identifiy
{
    NSString* sql = [NSString selecteSql:kDZTableType whereArray:@[kDZ_T_Type_C_GUID] decorate:Nil];
    FMResultSet* re = [_dataBase executeQuery:sql withArgumentsInArray:@[identifiy]];
    return [self timeTypeArrayFromFMResult:re].lastObject;
}

- (NSArray*) allTimeTypes
{
    NSString* sql = [NSString selecteSql:kDZTableType whereArray:Nil decorate:nil];
    return [self timeTypeArrayFromSQL:sql];
}

- (NSArray*) allUnFinishedTimeTypes
{
    NSArray* array = [self allTimeTypes];
    NSMutableArray* unFinishedArray = [NSMutableArray new];
    for (DZTimeType* type in array) {
        if (!type.isFinished) {
            [unFinishedArray addObject:type];
        }
    }
    return unFinishedArray;
}
- (NSArray*) allLocalChangedTypes
{
    NSString* sql = [NSString selecteSql:kDZTableType whereArray:@[kDZ_T_Type_C_LocalChanged] decorate:nil];
    return [self timeTypeArrayFromFMResult:[_dataBase executeQuery:sql withArgumentsInArray:@[@(1)]]];
}

- (NSArray*) allDeletedObjects
{
    NSString* sql = [NSString selecteSql:kDZTableDeletedObject whereArray:nil decorate:nil];
    return [self deletedObjectsArrayFromSQL:sql];
}

- (BOOL) setTimeType:(DZTimeType*)type localchanged:(BOOL)changed
{
    NSString* updateSQL = [NSString updateSql:kDZTableType setFields:@[kDZ_T_Type_C_LocalChanged] whereArray:@[kDZ_T_Type_C_GUID]];
    return [_dataBase executeUpdate:updateSQL withArgumentsInArray:@[@(changed), type.guid]];
}
#pragma mark - Meta
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




#pragma mark -

#pragma mark Versions

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

- (NSDictionary*) parseAllTypeCount
{
    NSString* sql = @"select count(type) , type from DZTIME group by type";
    FMResultSet* result = [_dataBase executeQuery:sql];
    NSMutableDictionary* dic = [NSMutableDictionary new];
    while ([result next]) {
        NSString* key = [result stringForColumnIndex:1];
        int count = [result intForColumnIndex:0];
        dic[key] = @(count);
    }
    [result close];
    return dic;
}

- (int) numberOfTimeOfTypeGUID:(NSString*)guid
{
    NSString* sql = [NSString stringWithFormat:@"select count(*) from %@ where %@='%@'",kDZTableTimeName, kDZ_T_Time_C_Type, guid];
    FMResultSet* result = [_dataBase executeQuery:sql];
    int count = 0;
    if ([result next]) {
        count = [result intForColumnIndex:0];
    }
    return count;
}

- (NSTimeInterval) timeCostWithTypeGUID:(NSString*)guid
{
    NSString* sql = [NSString selecteSql:@[kDZ_T_Time_C_Date_Begin, kDZ_T_Time_C_Date_End] tableName:kDZTableTimeName whereArray:@[kDZ_T_Time_C_Type] decorate:nil];
    FMResultSet* result = [_dataBase executeQuery:sql withArgumentsInArray:@[guid]];
    double cost = 0.0f;
    while ([result next]) {
        NSDate* begin = [NSDate dateFromISO8601String:[result stringForColumn:kDZ_T_Time_C_Date_Begin]];
        NSDate* end = [NSDate dateFromISO8601String:[result stringForColumn:kDZ_T_Time_C_Date_End]];
        if (begin && end) {
            cost += ABS([begin timeIntervalSinceDate:end]);
        }
    }
    return cost;
}


- (BOOL) removeDeletedRow:(NSString*)guid
{
    NSString* sql = [NSString deleteSql:kDZTableDeletedObject whereArray:@[kDZ_T_DELETED_C_GUID] decorate:nil];
    return [_dataBase executeUpdate:sql, guid];
}
@end
