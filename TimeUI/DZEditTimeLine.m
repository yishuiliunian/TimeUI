//
//  DZEditTimeLine.m
//  TimeUI
//
//  Created by Stone Dong on 14-2-14.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZEditTimeLine.h"

@interface DZEditTimeLine ()
{
}
DEFINE_PROPERTY_STRONG_UILabel(typeTextLabel);
@end

@implementation DZEditTimeLine
- (void) commonInit
{
    self.backgroundColor = [UIColor clearColor];
    _lineColor = [UIColor orangeColor];
    _timeColor = [UIColor blackColor];
    _timeFont = [UIFont systemFontOfSize:16];
    _timeString = @"asdfasd";
    INIT_SELF_SUBVIEW_UILabel(_typeTextLabel);
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


- (void) layoutSubviews
{
    _typeTextLabel.text = @"吃饭";
    float centerY =  (CGRectViewHeight - 2)/2 + 0.5;
    _typeTextLabel.frame = CGRectMake(0, centerY, 80, 20);
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
