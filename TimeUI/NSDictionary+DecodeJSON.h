//
//  NSDictionary+DecodeJSON.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DecodeJSON)
- (NSString*) decodeStringWithKey:(NSString*)key error:(NSError* __autoreleasing*)error;
- (NSDate*) decodeDateWithKey:(NSString*)key error:(NSError* __autoreleasing*)error;
- (BOOL) decodeBOOLWithKey:(NSString*)key error:(NSError* __autoreleasing*)error;
- (int64_t) decodeLonglongValueWithKey:(NSString*)key error:(NSError* __autoreleasing*)error;
@end
