//
//  DZWebOperationSystem.m
//  TimeUI
//
//  Created by stonedong on 14-4-4.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZWebOperationSystem.h"
#import "DZSingletonFactory.h"
#import "DZWebApplication.h"
#import "DZWebAppRuntime.h"

static NSString* const kWebOSJSBridgeURLScheme = @"openjsbridge";

@interface DZWebOperationSystem ()
{
    NSMutableDictionary* _applicationRuntimeMap;
}
@end

@implementation DZWebOperationSystem
+ (DZWebOperationSystem*) defaultOS
{
    return DZSingleForClass([DZWebOperationSystem class]);
}

- (void) commonInit
{
    _applicationRuntimeMap = [NSMutableDictionary dictionary];
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    [self commonInit];
    return self;
}
- (BOOL) isWebApplicationRequst:(NSURL *)url
{
    if ([url.scheme isEqualToString:kWebOSJSBridgeURLScheme]) {
        return YES;
    }
    return NO;
}

- (void) addWebApplicationRuntime:(DZWebAppRuntime*)runtime
{
    @synchronized(self)
    {
        if (runtime.appliaction.appId) {
            _applicationRuntimeMap[runtime.appliaction.appId] = runtime;
        }
    }
}

- (void) removeWebApplicationRuntimeByAppId:(NSString*)appId
{
    @synchronized(self){
        if (appId) {
            if ([_applicationRuntimeMap objectForKey:appId]) {
                [_applicationRuntimeMap removeObjectForKey:appId];
            }
        }
    }
}


- (DZWebAppRuntime*) createWebApplicationRuntimeWithAppID:(NSString *)appID
{
    DZWebApplication* webApp = [[DZWebApplication alloc] initWithAppID:appID];
    DZWebAppRuntime* runtime = [[DZWebAppRuntime alloc] initWithApplication:webApp];
    [self addWebApplicationRuntime:runtime];
    return runtime;
}

- (void) killWebApplicationWithAppID:(NSString *)appId
{
    [self removeWebApplicationRuntimeByAppId:appId];
}

- (DZWebAppRuntime*) aliveWebApplicationRuntimWithAppID:(NSString *)appID
{
    DZWebAppRuntime* runtime = _applicationRuntimeMap[appID];
    if (runtime) {
        return runtime;
    }
    return [self createWebApplicationRuntimeWithAppID:appID];
}

@end

