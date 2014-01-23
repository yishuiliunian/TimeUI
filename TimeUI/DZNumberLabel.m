//
//  DZNumberLabel.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZNumberLabel.h"
@interface DZNumberLabel ()
{
    CATextLayer* _numberTextLayer;
}
@end
@implementation DZNumberLabel

- (void) commonInit
{
    _numberTextLayer = [CATextLayer new];
    _numberTextLayer.font = (__bridge CGFontRef)[UIFont systemFontOfSize:15];
    _numberTextLayer.fontSize = 15;
    _numberTextLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:_numberTextLayer];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void) setNumber:(int)number
{
    if (_number != number) {
        
        int repeatCount = ABS(number - _number);
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, -CGRectViewHeight / 2, CGRectViewWidth, CGRectViewHeight)];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, CGRectViewHeight/2, CGRectViewWidth, CGRectViewHeight)];
        animation.byValue = [NSValue valueWithCGRect:_numberTextLayer.bounds];
        animation.duration = 1.0f/ repeatCount;
        animation.repeatCount = 100000;
        animation.autoreverses = YES;
        animation.removedOnCompletion = YES;
        [_numberTextLayer addAnimation:animation forKey:@"frame"];
    }
    _number = number;
    _numberTextLayer.string = [@(number) stringValue];
}
- (void) layoutSubviews
{
    _numberTextLayer.frame = self.bounds;
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
