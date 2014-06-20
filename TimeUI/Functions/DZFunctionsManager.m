//
//  DZFunctionsManager.m
//  TimeUI
//
//  Created by stonedong on 14-6-18.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZFunctionsManager.h"
#import "DZSingletonFactory.h"
#import "DZFileUtility.h"
#import "DZUserDataManager.h"
#import "DZFuncPlugin.h"
static NSString* kDZUserFunctions = @"kDZUserFunctions";

@interface DZFunctionsManager ()
{
    NSMutableArray* _allFunctions;
}
@end

@implementation DZFunctionsManager
+ (DZFunctionsManager*) defaultManager
{
    return DZSingleForClass([DZFunctionsManager class]);
}

- (void) loadAllFunctions
{
    NSArray* allFuncs = [[DZUserDataManager shareManager] activeUserDataForKey:kDZUserFunctions];
    
    if (!allFuncs) {
        NSError* error = nil;
        NSArray* json = [DZFileUtility jsonObjectFromResourcesByName:@"defaults_functions" type:@"json" error:&error];
        if (json) {
            allFuncs = json;
        } else {
            DDLogError(@"读取默认功能列表失败！！！！");
        }
    }
    if (allFuncs) {
        for (NSDictionary* dic in allFuncs) {
            DZFuncPlugin* plugin = [DZFuncPlugin new];
            [plugin setValuesForKeysWithDictionary:dic];
            [_allFunctions addObject:plugin];
        }
    }
}

- (void) commonInit
{
    _allFunctions = [NSMutableArray new];
    [self loadAllFunctions];
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

- (NSArray*) functions
{
    return [_allFunctions copy];
}

@end
