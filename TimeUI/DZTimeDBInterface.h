//
//  DZTimeDBInterface.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DZTime;
@class DZTimeType;

@protocol DZTimeDBInterface <NSObject>
@property (nonatomic, strong, readonly) NSError* lastError;
- (BOOL) updateTime:(DZTime *)time;
- (DZTime*) timeByGuid:(NSString*)guid;
- (NSArray*) allTimes;
//

- (NSArray*) timesByType:(DZTimeType*)type;
- (NSArray*) timesInOneWeakByType:(DZTimeType*)type;
//
- (BOOL) updateTimeType:(DZTimeType*)type;
- (DZTimeType*) tiemTypeByIdentifiy:(NSString*)identifiy;
- (DZTimeType*) timeTypByGUID:(NSString*)guid;
- (NSArray*) allTimeTypes;
- (NSArray*) allChangedTimes;
- (BOOL) setTime:(DZTime*)time localchanged:(BOOL)localchanged;

- (BOOL) delteTimeType:(DZTimeType*)type;
- (NSArray*) allLocalChangedTypes;
- (BOOL) setTimeType:(DZTimeType*)type localchanged:(BOOL)changed;
//
- (BOOL) setSyncVersion:(NSString*)key version:(int64_t)version;
- (int64_t) getSyncVersion:(NSString*)key;
- (BOOL) setTimeVersion:(int64_t)version;
- (int64_t) timeVersion;
- (BOOL) setTimeTypeVersion:(int64_t)version;
- (int64_t) timeTypeVersion;
@end
