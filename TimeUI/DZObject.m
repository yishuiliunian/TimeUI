//
//  DZObject.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-27.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZObject.h"
#import "DZAccountManager.h"
#import "DZAccount.h"
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
- (id) valueForKey:(NSString *)key
{
    if ([key isEqualToString:SJKeyUserGUID]) {
        return [DZActiveAccount identifiy];
    }
    return [NSNull null];
}
@end
