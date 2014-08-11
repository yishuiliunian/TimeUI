//
//  DZColorUnit.m
//  TimeUI
//
//  Created by stonedong on 14-8-8.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZColorUnit.h"
#import <HexColors/HexColor.h>
@interface DZColor : NSObject
DEFINE_PROPERTY_STRONG(UIColor*, color);
DEFINE_PROPERTY_ASSIGN(int, usedCount);
@end

@implementation DZColor


@end


static int const kMaxAllocNewColorCount = 10;
@interface DZColorUnit ()
{
    NSMutableArray* _hexStringCache;
    NSMutableDictionary* _colorCache;
}
DEFINE_PROPERTY_ASSIGN(int, allocCount);
@end

@implementation DZColorUnit
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _allocCount = 0;
    _hexStringCache = [@[@"#5263c3",
                       @"#bd64d3",
                       @"#2ea9df",
                       @"#76c61e",
                       @"#ffc000",
                       @"#ffb19b"] mutableCopy];
    
    _colorCache = [NSMutableDictionary new];
    
    for (NSString* hex  in _hexStringCache) {
        DZColor* color = [self dzcolorWithHex:hex];
        _colorCache[hex] = color;

    }
    return self;
}

- (DZColor*) dzcolorWithHex:(NSString*)hex
{
    UIColor* color = [UIColor colorWithHexString:hex];
    DZColor* dzcolor = [DZColor new];
    dzcolor.color = color;
    dzcolor.usedCount = 0;
    return dzcolor;
}

- (UIColor*) randomColorWithUsedCount:(int)count{
    NSArray* allValue = _colorCache.allValues;
    for (DZColor* color in allValue) {
        if (color.usedCount < count) {
            color.usedCount++;
            return color.color;
        }
    }
    return nil;
}


- (NSString*) randomHexString
{
    NSArray* array= @[@"0",
                      @"1",
                      @"2",
                      @"3",
                      @"4",
                      @"5",
                      @"6",
                      @"7",
                      @"8",
                      @"9",
                      @"a",
                      @"b",
                      @"c",
                      @"d",
                    @"e",
                      @"f"];
    NSMutableString* string = [NSMutableString new];
    [string appendString:@"#"];
    for(int i = 0 ; i < 6; i ++) {
        [string appendString:array[rand()%array.count]];
    }
    return string;
}

- (UIColor*) allocNewColor{
    NSString* randomStr = [self randomHexString];
    DZColor* dzcolor = [self dzcolorWithHex:randomStr];
    _colorCache[randomStr] = dzcolor;
    dzcolor.usedCount++;
    _allocCount ++;
    return dzcolor.color;
}

- (UIColor*) allocNewColorWithLimit {
    if (_allocCount < kMaxAllocNewColorCount) {
        return [self allocNewColor];
    }
    return nil;
}
- (UIColor*) randomColor
{
    UIColor* color = [self randomColorWithUsedCount:1];
    if (color) {
        return color;
    }
    color = [self allocNewColorWithLimit];
    if (color) {
        return color;
    }
    for (int i = 2; i < 100; i++) {
        color = [self randomColorWithUsedCount:i];
        if (color) {
            return color;
        }
    }
    return [UIColor whiteColor];
}
@end
