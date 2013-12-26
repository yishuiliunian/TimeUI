//
//  DZCommandQueue.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-20.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZCommandQueue.h"
#import "DZCommandThread.h"
@interface DZCommandQueue ()
{
    NSMutableSet* _commandQueue;
    NSMutableArray* _commandThreadsArray;
}
@end
@implementation DZCommandQueue
@synthesize countOfThread = _countOfThread;
- (id) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self commitInit];
    return self;
}



- (void) commitInit
{
    _conditionLock       = [[NSCondition alloc] init];
    _commandQueue        = [NSMutableSet new];
    _commandThreadsArray = [NSMutableArray new];
    _countOfThread = 2;
    for (int i = 0 ; i < _countOfThread; i++) {
        DZCommandThread* thread = [[DZCommandThread alloc] init];
        thread.commandQueue = self;
        [thread start];
    }
}

- (void) addCommand:(DZCommand *)command
{
    [_conditionLock lock];
    BOOL exist = NO;
    for (DZCommand* cmd  in _commandQueue) {
        if ([cmd.identify isEqualToString:command.identify]) {
            exist = YES;
        }
    }
    if (!exist) {
        [_commandQueue addObject:command];
        [_conditionLock signal];
    }
    [_conditionLock unlock];
}

- (DZCommand*) anyCommand
{
    [_conditionLock lock];
    [_conditionLock wait];
    DZCommand* command = [_commandQueue anyObject];
    if (command) {
        [_commandQueue removeObject:command];
    }
    [_conditionLock unlock];
    return command;
}
@end
