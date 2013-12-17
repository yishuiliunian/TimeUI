//
//  NSOperationQueue+DZ.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-17.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "NSOperationQueue+DZ.h"
#import "DZSingletonFactory.h"
@implementation NSOperationQueue (DZ)
+ (NSOperationQueue*) backgroudQueue
{
    return DZSingleForClass([NSOperationQueue class]);
}
@end
