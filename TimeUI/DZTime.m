//
//  DZTime.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTime.h"
#import <NSDate-TKExtensions.h>
#import "NSDate+SSToolkitAdditions.h"
#import "DZDevices.h"
@implementation DZTime
- (NSString*) deviceGuid
{
    return DZDevicesIdentify();
}

-(NSString*) description
{
    return [NSString stringWithFormat:@" %@ %@ %@ %@ %@", self.dateBegin, self.dateEnd, self.detail, self.typeGuid, self.guid];
}

- (NSDictionary*) parseDayCost
{
    NSMutableDictionary* dic = [NSMutableDictionary new];
    NSInteger week =  [self.dateBegin TKRealWeekday];
    if ([self.dateBegin daysAreTheSame:self.dateEnd]) {
        dic[@(week)] = @([self.dateEnd timeIntervalSinceDate:self.dateBegin]);
    }
    else
    {
         NSInteger days = [self.dateBegin TKDaysBetweenDate:self.dateEnd];
        for (int i = 0 ; i < days; i ++) {
            if (i == 0) {
                NSDate* endDate = [self.dateBegin TKDateByMovingToEndOfDay];
                dic[@(week)] = @([endDate timeIntervalSinceDate:self.dateBegin]);
            }else if (i == days - 1)
            {
                NSDate* bedingDate = [self.dateEnd TKDateByMovingToBeginningOfDay];
                dic[@(week + days - 1)] = @([self.dateEnd timeIntervalSinceDate:bedingDate]);
            }
            else
            {
                dic[@(week + i)] = @(24*60*60);
            }
        }
    }
    return dic;
}

- (NSDictionary*) toJsonObject {
    NSMutableDictionary* json = [NSMutableDictionary new];
    if (self.dateBegin) {
        [json setObject:[self.dateBegin TKISO8601String] forKey:DZTimeKeyBegin];
    }
    if (self.dateEnd) {
        [json setObject:[self.dateEnd TKISO8601String] forKey:DZTimeKeyEnd];
    }
    if (self.typeGuid) {
        [json setObject:self.typeGuid forKey:DZTimeKeyTypeGuid];
    }
    if (self.detail && ![self.detail isEqualToString:@""]) {
        [json setObject:self.detail forKey:DZTimeKeyDetail];
    }
    
    if (self.guid) {
        [json setObject:self.guid forKey:DZTimeKeyGuid];
    }
    if (self.userGuid) {
        [json setObject:self.userGuid forKey:DZTimeKeyUserGuid];
    }
    
    if (self.deviceGuid) {
        [json setObject:self.deviceGuid forKey:DZTimeKeyDeviceGuid];
    }
    [json setObject:_detail forKey:DZTimeKeyDetail];
    return json;
}

- (void) commonInit
{
    isMarshalSucceed = YES;
    _detail = @"";
}
- (instancetype) initGenGUID
{
    self = [super initGenGUID];
    if (self) {
        [self commonInit];
        _localChanged = YES;
    }
    return self;
}

- (void) setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:DZTimeKeyEnd]) {
        _dateEnd = [NSDate dateFromISO8601String:value];
        if (!_dateEnd) {
            isMarshalSucceed = NO;
        }
    }
    else if ([key isEqualToString:DZTimeKeyBegin])
    {
        _dateBegin = [NSDate dateFromISO8601String:value];
        if (!_dateBegin) {
            isMarshalSucceed = NO;
        }
    }
    else if ([key isEqualToString:DZTimeKeyDetail])
    {
        _detail = value;
    }
    else if ([key isEqualToString:DZTimeKeyDeviceGuid])
    {
        _deviceGuid = value;
    }
    else if ([key isEqualToString:DZTimeKeyTypeGuid])
    {
        _typeGuid = value;
    }
    else if ([key isEqualToString:DZTimeKeyUserGuid])
    {
        _userGuid = value;
    }
    else if ([key isEqualToString:DZTimeKeyGuid])
    {
        self.guid = value;
    }
}
- (instancetype) init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}
@end
