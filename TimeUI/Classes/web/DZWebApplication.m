//
//  DZWebApplication.m
//  TimeUI
//
//  Created by stonedong on 14-4-4.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZWebApplication.h"

@implementation DZWebApplication
- (instancetype) initWithAppID:(NSString *)appID
{
    self = [super init];
    if (!self) {
        return self;
    }
    _appId = appID;
    return self;
}
@end
