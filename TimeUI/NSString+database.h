//
//  NSString+database.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (database)
+ (NSString*) deleteSql:(NSString*)tableName whereArray:(NSArray*)whereFields decorate:(NSString*)decorate;
+ (NSString*) selecteSql:(NSString*)tableName whereArray:(NSArray*)whereFields decorate:(NSString*)decorate;
+ (NSString*) updateSql:(NSString*)tableName setFields:(NSArray*)setFields whereArray:(NSArray*)whereFields;
+ (NSString*) insertSql:(NSString*) tableName columns:(NSArray*)array;
+ (NSString*) selecteSql:(NSArray*)fields tableName:(NSString *)tableName whereArray:(NSArray *)whereFields decorate:(NSString *)decorate;
@end
