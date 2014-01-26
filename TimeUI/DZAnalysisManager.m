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
        [_typesWeekModels setObject:midek forKey:type.name];
    }
}

- (void) triggleAnaylysisWeekWithType:(DZTimeType*)type
{
    DZCommand* c = [[DZCommand alloc] initWithBlock:nil];
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
