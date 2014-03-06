//
//  DZObject.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-27.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZObject.h"

@implementation DZObject

- (instancetype) initGenGUID
{
    self = [super init];
    if (self) {
        _guid = [DZGlobals genGUID];
    }
    return self;
}
- (NSDictionary*) toJsonObject
{
    return @{};
}
@end
