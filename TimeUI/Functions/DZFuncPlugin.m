//
//  DZFuncPlugin.m
//  TimeUI
//
//  Created by stonedong on 14-6-18.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZFuncPlugin.h"

DZFuncPluginType DecodeIntToFuncPluginType(int i)
{
    switch (i) {
        case DZFuncPluginNomarl:
            return DZFuncPluginNomarl;
        case DZFuncPluginViewController:
            return DZFuncPluginViewController;
        default:
            return DZFuncPluginNomarl;
    }
}

INIT_DZ_EXTERN_STRING(kFuncName , name);
INIT_DZ_EXTERN_STRING(kFuncClassName , class)
INIT_DZ_EXTERN_STRING(kFuncDetail, detail)
INIT_DZ_EXTERN_STRING(kFuncType, type);

@implementation DZFuncPlugin
- (void) setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:kFuncName]) {
        _name = value;
    } else if ([key isEqualToString:kFuncDetail]) {
        _detail = value;
    } else if ([key isEqualToString:kFuncClassName]) {
        _className = value;
    } else if ([key isEqualToString:kFuncType])
    {
        _type = DecodeIntToFuncPluginType([value integerValue]);
    }
}

- (id) valueForKey:(NSString *)key
{
    if ([key isEqualToString:kFuncName]) {
        return _name;
    } else if ([key isEqualToString:kFuncClassName])
    {
        return _className;
    } else if ([key isEqualToString:kFuncDetail]) {
        return _detail;
    } else if ([key isEqualToString:kFuncType]) {
        return @(_type);
    }
    else
    {
        return [super valueForKey:key];
    }
}
@end
