//
//  DZWebAppRuntime.m
//  TimeUI
//
//  Created by stonedong on 14-4-4.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZWebAppRuntime.h"

@implementation DZWebAppRuntime
@synthesize isReady = _isReady;

- (void) commonInit
{
    _isReady = NO;
}

- (instancetype) initWithApplication:(DZWebApplication *)application
{
    self = [super init];
    if (!self) {
        return self;
    }
    _appliaction = application;
    [self commonInit];
    return self;
}

- (void) prepareRuntimeEnviroment
{
    _isReady = NO;

}

- (BOOL) isReady
{
    return _isReady;
}
- (BOOL) canRequestModule:(NSString *)model api:(NSString *)api
{
    return NO;
}

@end
