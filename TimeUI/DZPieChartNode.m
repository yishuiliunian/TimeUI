//
//  DZPieChartNode.m
//  TimeUI
//
//  Created by stonedong on 14-6-18.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZPieChartNode.h"

#import "UIColor+DZColor.h"

@implementation DZPieChartNode

- (instancetype) initWithChartNode:(DZChartNode*)node
{
    self = [super init];
    if (!self) {
        return self;
    }
    _chartNode = node;
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    _shapeLayer.lineWidth = 0;
    _shapeLayer.opacity = 1.0f;
    return self;
}
- (NSString*) key
{
    return _chartNode.key;
}
- (void) setKey:(NSString *)key
{
    [_chartNode setKey:key];
}

- (int64_t) value
{
    return _chartNode.value;
}

- (void) setValue:(int64_t)value
{
    [_chartNode setValue:value];
}

- (BOOL) isSpecial
{
    return _chartNode.isSpecial;
}

- (void) setIsSpecial:(BOOL)isSpecial
{
    [_chartNode setIsSpecial:isSpecial];
}
@end
