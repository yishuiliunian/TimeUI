//
//  NSError+dz.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-16.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "NSError+dz.h"

@implementation NSError (dz)
+ (NSError*)dzErrorWithCode:(int)code message:(NSString *)message
{
    return [NSError errorWithDomain:@"com.dzpqzb.catchtime" code:code userInfo:@{NSLocalizedDescriptionKey: (message ? message : @"unknow")}];
}

+ (NSError*) dzParseErrorWithKey:(NSString *)key
{
    return [NSError dzErrorWithCode:DZParserErrorCodePE message:[NSString stringWithFormat:@"parser key %@ error!", key]];
}
@end
