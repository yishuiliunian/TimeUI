//
//  DZChartNode.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-8.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZChartNode.h"

@implementation DZChartNode
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _identify = [DZGlobals genGUID];
    _isSpecial = NO;
    return self;
}

+ (DZChartNode*) nodeWithKey:(NSString *)key value:(int64_t)value
{
    DZChartNode* node = [DZChartNode new];
    node.key = key;
    node.value = value;
    return node;
}
@end
