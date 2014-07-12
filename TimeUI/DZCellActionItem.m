//
//  DZCellActionItem.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-13.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZCellActionItem.h"

@interface DZCellActionItem ()
{
    UIColor* _disableColor;
}
@end

@implementation DZCellActionItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _edgeInset = UIEdgeInsetsZero;
        _disableColor = [UIColor grayColor];
        _enableColor = [UIColor greenColor];
        [self setEnabled:NO ];
    }
    return self;
}

- (void) setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (enabled) {
        [self setBackgroundColor:_enableColor];
    } else {
        [self setBackgroundColor:_disableColor];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
