//
//  NSURL+Untils.m
//  TimeUI
//
//  Created by stonedong on 14-4-4.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "NSURL+Untils.h"

@implementation NSURL (Untils)

- (NSDictionary *)queryComponents{
    NSArray *components = [self.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    for (NSString *component in components) {
        //检查kv的长度，有可能没value甚至没key
        NSArray *kv = [component componentsSeparatedByString:@"="];
        NSString *key = kv.count > 0 ? [kv objectAtIndex:0] : nil;
        NSString *value = kv.count > 1 ? [kv objectAtIndex:1] : nil;
        if (value == nil) value = @"";
        //必须至少有个key，value默认为空字符串
        if (key && key.length && value) {
            id existedValue = [results objectForKey:key];
            if (existedValue) {
                if ([existedValue isMemberOfClass:[NSMutableArray class]]) {
                    [existedValue addObject:value];
                }
                else {
                    [results setObject:[NSMutableArray arrayWithObjects:existedValue, value, nil] forKey:key];
                }
            }
            else {
                [results setObject:value forKey:key];
            }
        }
    }
    return results;
}

- (NSString *)queryComponentNamed:(NSString *)name{
    return [self queryComponentNamed:name index:0];
}

- (NSString *)queryComponentNamed:(NSString *)name index:(NSInteger)index{
    id result = [[self queryComponents] objectForKey:name];
    if ([result isKindOfClass:[NSArray class]]) {
        if ([result count]) {
            return [result objectAtIndex:index];
        }
        else return nil;
    }
    return result;
}
@end
