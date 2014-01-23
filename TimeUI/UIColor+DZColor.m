//
//  UIColor+DZColor.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-23.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "UIColor+DZColor.h"

@implementation UIColor (DZColor)
- (UIColor*) colorWithOffset:(float)offset
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    if ([self getRed:&red green:&green blue:&blue alpha:&alpha]) {
        return [UIColor colorWithRed:red+offset green:green+offset blue:blue+offset alpha:alpha];
    }
    return self;
}
@end
