//
//  DZTimeCountLabel.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-26.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZTimeCountLabel.h"
#import "MFLTransformingDigit.h"
#import "MFLTransformingDigit+Animation.h"
#import "CTime.h"
@interface DZTimeCountLabel ()
{
    CFTimeInterval _startTime;
    NSTimer* _countTimer;
    
    NSMutableArray* _digitLabels;
}
@end

@implementation DZTimeCountLabel

- (void) commoInit
{
    _digitLabels = [NSMutableArray new];
    for (int i = 0 ; i < 3; i++) {
        NSMutableArray* part = [NSMutableArray new];
        for (int j = 0 ; j < 2; j++) {
            MFLTransformingDigit* d = [[MFLTransformingDigit alloc] init];
            [self addSubview:d];
            [part addObject:d];
            d.strokeColor = [UIColor blackColor].CGColor;
            [d setAnimationDuration:0.2];
        }
        [_digitLabels addObject:part];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commoInit];
    }
    return self;
}

- (void) increaseTime:(NSTimer*)timer
{
    CFTimeInterval current = CFAbsoluteTimeGetCurrent();
    double space = current - _startTime + _beginTimeOffset;
    
    CTime time = CTime(space);
    std::vector<int> disVector;
    time.getHMSDisplay(disVector);
    std::vector<int>::iterator itor = disVector.begin();
    for (int partCount = 0; partCount < _digitLabels.count; partCount++) {
        NSArray* part = _digitLabels[partCount];
        for (int digitCount = 0; digitCount < part.count; digitCount++) {
            MFLTransformingDigit* digit = part[digitCount];
            int value = 0;
            if (itor != disVector.end()) {
                value = *itor;
            }
            [digit animateToDigit:value];
            itor++;
        }
    }
}
- (void) start
{
   _startTime = CFAbsoluteTimeGetCurrent();
    _countTimer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(increaseTime:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_countTimer forMode:NSRunLoopCommonModes];
}

- (void) layoutSubviews
{
    
    int partsCount = _digitLabels.count;
    int digitsCount = 0;
    for (NSArray* each  in _digitLabels) {
        digitsCount += each.count;
    }
    float partSpace = 20;
    float digitSpace = 0;
    float xMargin = 20;
    float partWidth = (CGRectViewWidth - partSpace*(partsCount -1)- xMargin*2)/partsCount;
    for (int partCount = 0; partCount < _digitLabels.count; partCount++) {
        NSArray* part = _digitLabels[partCount];
        CGRect partRect = CGRectMake(xMargin + partWidth*partCount + partCount*partSpace, 0, partWidth, CGRectViewHeight);
        float digitWidth = (CGRectGetWidth(partRect) - digitSpace*( part.count - 1) ) / part.count;
        for (int digitCount = 0; digitCount < part.count; digitCount ++) {
            CGRect digitRect = CGRectMake(CGRectGetMinX(partRect) + digitSpace*digitCount + digitWidth*digitCount, CGRectGetMinY(partRect), digitWidth, CGRectGetHeight(partRect));
            MFLTransformingDigit* label = part[digitCount];
            label.frame = digitRect;

        }
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
