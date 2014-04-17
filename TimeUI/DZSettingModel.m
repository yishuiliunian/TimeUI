//
//  DZSettingModel.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-26.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZSettingModel.h"

@implementation DZSettingModel

- (instancetype) initWithIdentify:(NSString *)identifer
                             name:(NSString *)name
                             type:(DZSettingModelType)type
                     defaultValue:(id)value
                     changedBlock:(SettingsValueChangedBlock)block
{
    self = [super init];
    if (!self) {
        return self;
    }
    _identify = identifer;
    _name = name;
    _type = type;
    _valueChangedBlock = block;
    _value = value;
    return self;
}

- (void) setValue:(id)value
{
}
@end
