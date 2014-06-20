//
//  DZOvalMaskImageView.m
//  TimeUI
//
//  Created by stonedong on 14-6-19.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZOvalMaskImageView.h"
@interface DZOvalMaskImageView ()
{
    CAShapeLayer* _maskLayer;
}
@end
@implementation DZOvalMaskImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _maskLayer = [CAShapeLayer new];
        self.layer.mask = _maskLayer;
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    _maskLayer.path = path.CGPath;
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
