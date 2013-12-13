//
//  DZDevices.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZDevices.h"
float DeviceSystemMajorVersion() {
    
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* versionStr = [[UIDevice currentDevice] systemVersion];
        NSArray* dots = [versionStr componentsSeparatedByString:@"."];
        float v = 0;
        for (int i = 0 ; i < dots.count; ++i) {
            NSString* str = dots[i];
            float value = [str floatValue] * pow(0.1, i);
            v += value;
        }
        _deviceSystemMajorVersion = v;
        
    });
    return _deviceSystemMajorVersion;
    
}


@implementation DZDevices

@end
