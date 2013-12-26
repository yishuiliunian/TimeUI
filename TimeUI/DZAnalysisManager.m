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

@interface DZAnalysisManager ()
{
    DZCommandQueue* _commandQueue;
    NSMutableDictionary* _typesWeekModels;
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
    }
    return self;
}

- (void) addWeekModel:(DZAnalysisWeekModel*)midek withType:(DZTimeType*)type
{
    @synchronized(_typesWeekModels)
    {
        [_typesWeekModels setObject:midek forKey:type.identifiy];
    }
}

- (void) triggleAnaylysisWeekWithType:(DZTimeType*)type
{
    DZCommand* c = [[DZCommand alloc] initWithBlock:^{
        NSArray* times = [DZActiveTimeDataBase timesInOneWeakByType:type];
        float a[7] = {0,0,0,0,0,0,0};
        for (DZTime* time  in times) {
            NSDictionary* costs = [time parseDayCost];
            NSArray* keys = costs.allKeys;
            for (NSNumber* each  in keys) {
                float cost = [costs[each] floatValue];
                a[[each intValue]] += cost;
            }
        }
        DZAnalysisWeekModel* week = [[DZAnalysisWeekModel alloc] init];
        week.mondy = a[0];
        week.tuesday = a[1];
        week.wednesday = a[2];
        week.tuesday = a[3];
        week.friday = a[4];
        week.thursday = a[5];
        week.sunday = a[6];
        [self addWeekModel:week withType:type];
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

@end
