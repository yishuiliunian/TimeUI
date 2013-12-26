//
//  DZThemeManager.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-20.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZThemeManager.h"
#import "DZSingletonFactory.h"
#import <GLKit/GLKit.h>
#import <GLKit/GLKTextureLoader.h>
@implementation DZThemeManager

+ (DZThemeManager*) shareManager
{
    return DZSingleForClass([DZThemeManager class]);
}


- (instancetype) init
{
    self = [super init];
    if (self) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"activity-icons-small" ofType:@"png"];
        NSError* error = nil;
        GLKTextureInfo* infos = [GLKTextureLoader textureWithContentsOfFile:path options:Nil error:&error];
        
    }
    return self;
}

@end
