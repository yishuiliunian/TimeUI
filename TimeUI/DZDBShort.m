//
//  DZDBShort.m
//  TimeUI
//
//  Created by stonedong on 14-8-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZDBShort.h"
#import "DZDBManager.h"
#import "DZTime.h"
#import "DZTimeType.h"
BOOL DBAddDeletedRowAtDB(NSString* guid, NSString* type, id<DZTimeDBInterface> db) {
    DZDeletedObject* deo = [DZDeletedObject new];
    deo.type = type;
    deo.guid = guid;
    deo.deletedDate = [NSDate date];
    return [db updateDeletedObject:deo];
}

BOOL DBAddDeletedRow(NSString* guid, NSString* type) {
    return  DBAddDeletedRowAtDB(guid, type, DZActiveTimeDataBase);
}


BOOL DBDeleteTimeRowAtDB(DZTime* time, id<DZTimeDBInterface> db)
{
    if(![db deleteTime:time]) return NO;
    return DBAddDeletedRowAtDB(time.guid, kDZObjectTypeTime, db);
}

BOOL DBDeleteTimeRow(DZTime* time) {
    id<DZTimeDBInterface> db = DZActiveTimeDataBase;
    return  DBDeleteTimeRowAtDB(time, db);
}

BOOL DBDeleteTimeTypeRowAtDB(DZTimeType* type, id<DZTimeDBInterface> db) {
    NSArray* allTimes = [db timesByType:type];
    for (DZTime* time  in allTimes) {
        if(!DBDeleteTimeRowAtDB(time, db)) { return NO ;};
    }
    if(![db deleteTimeType:type]) return NO;
    return DBAddDeletedRowAtDB(type.guid, kDZObjectTypeType, db);
}

BOOL DBDeleteTimeTypeRow(DZTimeType* type) {
    return DBDeleteTimeTypeRowAtDB(type, DZActiveTimeDataBase);
}

