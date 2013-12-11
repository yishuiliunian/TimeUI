//
//  DZTimeType.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTimeType.h"

@implementation DZTimeType

- (void) setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:kDZKeyDetail]) {
        _detail = value;
    }
    else if ([key isEqualToString:kDZKeyIdentifiy])
    {
        _identifiy = value;
    }
    else if ([key isEqualToString:kDZKeyName])
    {
        _name = value;
    }
}
@end
