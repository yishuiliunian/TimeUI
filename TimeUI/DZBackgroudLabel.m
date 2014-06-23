//
//  DZBackgroudLabel.m
//  TimeUI
//
//  Created by stonedong on 14-6-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZBackgroudLabel.h"

@implementation DZBackgroudLabel
@synthesize label = _label;
@synthesize backgroundImageView = _backgroundImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        INIT_SELF_SUBVIEW_UIImageView(_backgroundImageView);
        INIT_SELF_SUBVIEW_UILabel(_label);
        _edgeInsets = UIEdgeInsetsZero;
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    self.backgroundImageView.frame =self.bounds;
    self.label.frame = CGRectMake(_edgeInsets.left,
                                  _edgeInsets.top,
                                  CGRectGetWidth(self.bounds) - _edgeInsets.left + _edgeInsets.right,
                                  CGRectGetHeight(self.bounds) - _edgeInsets.top + _edgeInsets.bottom);
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
