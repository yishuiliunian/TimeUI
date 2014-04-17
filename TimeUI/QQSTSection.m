//
//  QQSTSection.m
//  QQMSFContact
//
//  Created by Stone Dong on 14-2-12.
//
//

#import "QQSTSection.h"

@interface QQSTSection ()
{
    NSMutableArray* _rows;
}
@end

@implementation QQSTSection

- (void) commonInit
{
    _rows = [NSMutableArray new];
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    [self commonInit];
    return self;
}
- (NSInteger) rowCount
{
    return _rows.count;
}
- (void) addRow:(QQSTRow *)row atIndex:(NSInteger)index
{
    [_rows insertObject:row atIndex:index];
}

- (void) removeRowAtIndex:(NSInteger)index
{
    [_rows removeObjectAtIndex:index];
}

- (QQSTRow*) rowAtIndex:(NSInteger)index
{
    return _rows[index];
}

@end
