//
//  DZWebAppRuntimePlugin.m
//  TimeUI
//
//  Created by stonedong on 14-4-4.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZWebAppRuntimePlugin.h"

@implementation DZWebAppRuntimePlugin
+ (NSString*) version
{
    return @"0.0.1";
}
+ (NSString*) detail
{
    return @"web app运行环境！";
}
+ (NSString*) moduleName
{
    return @"runtime";
}

DEFINE_Handle_JS_Requst_Function(init)
{
    
}

@end
