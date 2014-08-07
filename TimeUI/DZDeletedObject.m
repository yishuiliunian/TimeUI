//
//  DZDeletedObject.m
//  TimeUI
//
//  Created by stonedong on 14-8-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZDeletedObject.h"
#import "NSDate+SSToolkitAdditions.h"
#import <NSDate-TKExtensions.h>
@implementation DZDeletedObject

- (void) setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:SJKeyObjectGuid]) {
        self.guid = value;
    } else if ([key isEqualToString:SJKeyDeletedDate] || [key isEqualToString:@"DeletedTime"]) {
        self.deletedDate = [NSDate dateFromISO8601String:value];
    } else if ([key isEqualToString:SJKeyDeletedType]) {
        self.type = value;
    }
}

- (id) valueForKey:(NSString *)key
{
    if ([key isEqualToString:SJKeyDeletedType]) {
        return self.type;
    } else if ([key isEqualToString:SJKeyDeletedDate]) {
        return [self.deletedDate TKISO8601String];
    } else if ([key isEqualToString:SJKeyObjectGuid]) {
        return self.guid;
    } else
    {
        return [super valueForKey:key];
    }
    return [NSNull null];
}
- (NSDictionary*)toJsonObject
{
    return [self dictionaryWithValuesForKeys:@[SJKeyDeletedDate, SJKeyDeletedType,SJKeyObjectGuid, SJKeyUserGUID]];
}
@end
