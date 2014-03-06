//
//  NSDictionary+DecodeJSON.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "NSDictionary+DecodeJSON.h"
#import "NSError+dz.h"
#import "NSDate+SSToolkitAdditions.h"
@implementation NSDictionary (DecodeJSON)
- (NSString*) decodeStringWithKey:(NSString*)key error:(NSError* __autoreleasing*)error
{
    NSString* str = self[key];
    if (!str) {
        if (error != NULL) {
            *error = [NSError dzParseErrorWithKey:key];
        }
    }
    return str;
}
- (NSDate*) decodeDateWithKey:(NSString*)key error:(NSError* __autoreleasing*)error
{
    NSString* dateStr = self[key];
    NSDate* date = [NSDate dateFromISO8601String:dateStr];
    if (!date) {
        if (error != NULL) {
            *error = [NSError dzParseErrorWithKey:key];
        }
    }
    return date;
}
- (BOOL) decodeBOOLWithKey:(NSString*)key error:(NSError* __autoreleasing*)error
{
    id str = self[key];
    if (!str) {
        if (error != NULL) {
            *error = [NSError dzParseErrorWithKey:key];
        }
    }
    return [str boolValue];
}

- (int64_t) decodeLonglongValueWithKey:(NSString*)key error:(NSError* __autoreleasing*)error
{
    id str = self[key];
    if (!str) {
        if (error != NULL) {
            *error = [NSError dzParseErrorWithKey:key];
        }
    }
    return [str longLongValue];
}
@end
