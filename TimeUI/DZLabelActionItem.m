//
//  DZLabelActionItem.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-31.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZLabelActionItem.h"

@implementation DZLabelActionItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [UILabel new];
        [self addSubview:_textLabel];
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    _textLabel.frame = CGRectMake(10, 0, CGRectGetWidth(self.bounds) - 20, CGRectGetHeight(self.bounds));
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
