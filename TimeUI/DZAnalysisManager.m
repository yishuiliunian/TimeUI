//
//  DZAnalysisManager.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-20.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZAnalysisManager.h"
#import "DZSingletonFactory.h"
#import "DZCommandQueue.h"
#import "DZTime.h"
#import "DZTimeType.h"
#import "DZAnalysisModels.h"
#import "DZAnalysisNotificationInterface.h"

NSString* commondIdentify(NSString* guid , NSString* type)
{
    return [NSString stringWithFormat:@"%@--%@",guid,type];
}

@interface DZAnalysisManager ()
{
    DZCommandQueue* _commandQueue;
    NSMutableDictionary* _typesWeekModels;
    NSMutableDictionary* _timeCountMap;
    NSMutableDictionary* _timeCostMap;
}
@end

@implementation DZAnalysisManager

+ (DZAnalysisManager*) shareManager
{
    return DZSingleForClass([DZAnalysisManager class]);
}


- (instancetype) init
{
    self = [super init];
    if (self) {
        _commandQueue = [[DZCommandQueue alloc] init];
        _typesWeekModels = [NSMutableDictionary new];
        _timeCountMap = [NSMutableDictionary new];
        _timeCostMap = [NSMutableDictionary new];
    }
    return self;
}

- (void) addWeekModel:(DZAnalysisWeekModel*)midek withType:(DZTimeType*)type
{
    @synchronized(_typesWeekModels)
    {
        [_typesWeekModels setObject:midek forKey:type.name];
    }
}

- (DZAnalysisWeekModel*) parseOnweakTimeData:(DZTimeType*)type
{
    NSArray* array =  [DZActiveTimeDataBase timesInOneWeakByType:type];
    float a[8] = {0,0,0,0,0,0,0,0};
    for (DZTime* time  in array) {
        NSDictionary* costs = [time parseDayCost];
        NSArray* keys = costs.allKeys;
        for (NSNumber* each  in keys) {
            float cost = [costs[each] floatValue];
            a[[each intValue]] += cost;
        }
    }
    DZAnalysisWeekModel* weekModel = [DZAnalysisWeekModel new];
    weekModel.monday = a[1];
    weekModel.tuesday = a[2];
    weekModel.wednesday = a[3];
    weekModel.thursday = a[4];
    weekModel.friday = a[5];
    weekModel.saturday = a[6];
    weekModel.sunday = a[7];
    return weekModel;
}

- (DZAnalysisWeekModel*) weekModelForType:(DZTimeType *)type
{
    DZAnalysisWeekModel* model = [_typesWeekModels objectForKey:type.name];
    if (!model) {
        model = [self parseOnweakTimeData:type];
        [self addWeekModel:model withType:type];
    }
    return model;
}

- (void) triggleAnaylysisWeekWithType:(DZTimeType*)type
{
    DZCommand* c = [[DZCommand alloc] initWithBlock:^{
        DZAnalysisWeekModel* model = [self parseOnweakTimeData:type];
        [self addWeekModel:model withType:type];
    }];
    [_commandQueue addCommand:c];
}

- (void) triggleCommand:(NSString*)command
{
    DZCommand* c = [[DZCommand alloc] init];
    c.identify = command;
    c.commandBlock = ^{
        NSLog(@"run command");
    };
    [_commandQueue addCommand:c];
}

- (int) numberOfTimeForType:(DZTimeType*)type
{
    return [_timeCountMap[type.guid] intValue];
}

- (void) triggleAnaylysisTimeCount
{
    DZCommand* c = [DZCommand commondWithIdentify:@"parsetimecount" Block:^{
        NSDictionary* dic =  [DZActiveTimeDataBase parseAllTypeCount];
        NSArray* allValues = dic.allKeys;
        
        for (NSString* key  in allValues) {
            NSDictionary* userInfo = @{@"count":dic[key], @"key":key};
            [_timeCountMap setObject:dic[key] forKey:key];
            [DZDefaultNotificationCenter postMessage:kDZNotification_parase_count userInfo:userInfo];
        }
    }];
    [_commandQueue addCommand:c];
}

- (void) triggleAnaylysisTimeCountWithType:(DZTimeType*)type
{
    NSString* guid = type.guid;
    DZCommand* c = [DZCommand commondWithIdentify:type.guid Block:^{
        int count = [DZActiveTimeDataBase numberOfTimeOfTypeGUID:guid];
        NSDictionary* userInfo = @{@"count":@(count), @"key":guid};
        [_timeCountMap setObject:@(count) forKey:guid];
        [DZDefaultNotificationCenter postMessage:kDZNotification_parase_count userInfo:userInfo];
    }];
    [_commandQueue addCommand:c];
}

- (NSTimeInterval) timeCostOfType:(DZTimeType*)type
{
    NSNumber* cost = _timeCostMap[type.guid];
    if (!cost) {
        NSTimeInterval time = [DZActiveTimeDataBase timeCostWithTypeGUID:type.guid];
        _timeCostMap[type.guid] = @(time);
        [self triggleAnaylysisTimeCostWithType:type];
        cost = @(time);
    }
    return [cost floatValue];
}

- (void) triggleAnaylysisTimeCostWithType:(DZTimeType*)type
{
    DZCommand* c = [DZCommand commondWithIdentify:commondIdentify(type.guid, @"timecost") Block:^{
        NSTimeInterval time = [DZActiveTimeDataBase timeCostWithTypeGUID:type.guid];
        _timeCostMap[type.guid] = @(time);
        [DZDefaultNotificationCenter postMessage:kDZNotification_time_cost userInfo:@{@"cost":@(time), @"guid":type.guid}];
    }];
    [_commandQueue addCommand:c];
}
@end
