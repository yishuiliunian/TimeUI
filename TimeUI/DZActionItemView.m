//
//  DZActionItemView.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-18.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZActionItemView.h"
#import "DZSeparationLine.h"
@interface DZActionItemView ()
DEFINE_PROPERTY_STRONG(DZSeparationLine*,topSplitLineView);
DEFINE_PROPERTY_STRONG(DZSeparationLine*, bottomSplitLineView);
@end

@implementation DZActionItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        INIT_SELF_SUBVIEW(DZSeparationLine, _topSplitLineView);
        INIT_SELF_SUBVIEW(DZSeparationLine, _bottomSplitLineView);
        _bottomSplitLineView.lineColor = [UIColor lightGrayColor];
        _topSplitLineView.lineColor = [UIColor lightGrayColor];
        _bottomSplitLineView.alpha = 0.5;
        _topSplitLineView.alpha = 0.5;
    }
    return self;
}

- (void) layoutSubviews
{
    _topSplitLineView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1);
    _bottomSplitLineView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.bounds), 1);
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
