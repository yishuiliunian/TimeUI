//
//  DZTypeCell.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-13.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTypeCell.h"

@implementation DZTypeCell

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
    _textLabel.frame = self.bounds;
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
