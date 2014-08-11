//
//  DZListHanldeView.m
//  TimeUI
//
//  Created by stonedong on 14-8-7.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZListHanldeView.h"

@interface DZListHanldeView ()
DEFINE_PROPERTY_STRONG_UIImageView(arrowImageView);
@end

@implementation DZListHanldeView

- (void) commonInit
{
    INIT_SELF_SUBVIEW_UIImageView(_arrowImageView);
    _arrowImageView.image = DZCachedImageByName(@"bus_list_arrow");
    _state = DZListHanldeViewInvalid;
    [self setState:DZListHanldeStateBottom animation:NO];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    [self commonInit];
    return self;
}
- (void) setState:(DZListHanldeState)state
{
    [self setState:state animation:YES];
}
- (void) setState:(DZListHanldeState)state animation:(BOOL)animation
{
    if (_state != state) {
        _state = state;
        if (state == DZListHanldeStateMoving) {
            self.image = DZCachedImageByName(@"list_handle_large");
        } else {
            self.image = DZCachedImageByName(@"list_handle");
        }
        //
        if (state == DZListHanldeStateTop) {
            [self setArrowImageViewRotation:0];
        } else if (state == DZListHanldeStateBottom) {
            [self setArrowImageViewRotation:M_PI];
        }
        [self setNeedsLayout];
    }
}
- (void) setArrowImageViewRotation:(CGFloat)angle
{
    [UIView animateWithDuration:0.5 animations:^{
        _arrowImageView.layer.transform = CATransform3DMakeRotation(angle, 1.0, 0, 0.0);
    }];
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    animation.delegate = self;
//    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(angle, 0, 0, 1.0)];
//    //执行时间
//    
//    animation.duration = 2;
//    animation.cumulative = YES;//累积的
//    [_arrowImageView.layer addAnimation:animation forKey:@"a"];
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    CGFloat yMargin = DZListHanldeStateMoving == _state? 15 : 20;
    CGFloat arrowHeight = 15;
    CGFloat arrowWidth = 20;
    _arrowImageView.frame = CGRectMake((CGRectGetWidth(self.frame) - arrowWidth)/2, yMargin, arrowWidth, arrowHeight);
}
@end
