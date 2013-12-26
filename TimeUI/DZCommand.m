//
//  DZCommand.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-20.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZCommand.h"

@implementation DZCommand
@synthesize commandBlock = _commandBlock;

- (instancetype) initWithBlock:(DZCommandBlock)block
{
    self = [super init];
    if (self) {
        _commandBlock = block;
    }
    return self;
}
@end
