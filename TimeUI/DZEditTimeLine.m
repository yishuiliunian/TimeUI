//
//  DZEditTimeLine.m
//  TimeUI
//
//  Created by Stone Dong on 14-2-14.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZEditTimeLine.h"
#import <SKBounceAnimation.h>
@interface DZEditTimeLine ()
{
    UILongPressGestureRecognizer* _longPressRecg;
    id _longPressTarget;
    SEL _longPressAction;
}
DEFINE_PROPERTY_STRONG_UILabel(typeTextLabel);
DEFINE_PROPERTY_STRONG_NSString(timeString);
@end

@implementation DZEditTimeLine
- (void) commonInit
{
    self.backgroundColor = [UIColor clearColor];
    _lineColor = [UIColor orangeColor];
    _timeColor = [UIColor blackColor];
    _timeFont = [UIFont systemFontOfSize:16];
    INIT_SELF_SUBVIEW_UILabel(_typeTextLabel);
    

}
- (void) setRatio:(float)ratio
{
    _ratio = ratio;
    NSString* timeStr = nil;
    if ([_delegate respondsToSelector:@selector(editTimeLine:timeStringWithRote:)]) {
        timeStr = [_delegate editTimeLine:self timeStringWithRote:_ratio];
    } else {
        timeStr = @"sss";
    }
    _timeString = timeStr;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        // Initialization code
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    static float segmentWidth = 20;
    static float segSpaceWidth = 5;
    float labelMaxWidth = 80;
    NSInteger segCount = floor((CGRectViewWidth - labelMaxWidth )/(segmentWidth + segSpaceWidth));
    
    float lastSegmentMaxX = 0;
    for (int i = 0 ; i < segCount; i++) {
        CGRect rect = CGRectMake(segmentWidth*i + 5*i, (CGRectViewHeight - 2)/2 + 0.5, segmentWidth, 2);
        UIBezierPath* path =[UIBezierPath bezierPathWithRect:rect];
        [[UIColor orangeColor] setFill];
        [path fill];
        lastSegmentMaxX = CGRectGetMaxX(rect);
    }
    
    CGSize strSize = [_timeString sizeWithFont:_timeFont];
    
    [_timeColor setStroke];
    [_timeColor setFill];
    
    CGRect textRect = CGRectMake(lastSegmentMaxX + 5,(CGRectViewHeight - strSize.height)/2  , strSize.width, strSize.height);
    [_timeString drawInRect:textRect withFont:_timeFont];
    
    //
    NSInteger restCount = MAX(floor((CGRectViewWidth - strSize.width - lastSegmentMaxX - 10) / (segmentWidth + segSpaceWidth)), 1 );

    for (int i = 0 ; i < restCount; i++) {
        CGRect rect = CGRectMake(CGRectGetMaxX(textRect)+ 5 + segmentWidth*i + 5*i, (CGRectViewHeight - 2)/2 + 0.5, segmentWidth, 2);
        UIBezierPath* path =[UIBezierPath bezierPathWithRect:rect];
        [[UIColor orangeColor] setFill];
        [path fill];
    }
}
- (void) setTypeString:(NSString *)typeString
{
    if (_typeString != typeString) {
        SKBounceAnimation* animation = [SKBounceAnimation animationWithKeyPath:@"position.y"];
        
        CGRect rect = _typeTextLabel.layer.frame;
        animation.fromValue = @(-5);
        animation.toValue = @(0);
        animation.numberOfBounces = 3;
        animation.duration = 0.5;
        animation.shouldOvershoot = YES;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        [_typeTextLabel.layer addAnimation:animation forKey:@"bounce"];
        _typeTextLabel.text = typeString;
    }
}

- (void) layoutSubviews
{
    float centerY =  (CGRectViewHeight - 2)/2 + 0.5;
    _typeTextLabel.frame = CGRectMake(0, centerY - 20, 80, 20);
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
