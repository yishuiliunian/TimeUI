//
//  DZWebAppRuntime.h
//  TimeUI
//
//  Created by stonedong on 14-4-4.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZWebApplication.h"
@interface DZWebAppRuntime : NSObject
@property (nonatomic, assign, readonly) BOOL isReady;
@property (nonatomic, strong)  DZWebApplication* appliaction;
@property (nonatomic, strong) NSDictionary* apiWhiteList;

- (instancetype) initWithApplication:(DZWebApplication*)application;
- (void) prepareRuntimeEnviroment;
- (BOOL) canRequestModule:(NSString*)model api:(NSString*)api;
@end
