//
//  DZEditTimeSegmentView.m
//  TimeUI
//
//  Created by Stone Dong on 14-2-14.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZEditTimeSegmentView.h"
#import "UIColor+DZColor.h"
#import "DZEditTimeLine.h"

@interface DZEditTimeSegmentView()
{
    NSMutableArray* _divisionLinesInfo;
    NSMutableArray* _lineViews;
    NSMutableDictionary* _colorsCache;
    
    UITapGestureRecognizer* _doubleTapGesture;
}
@end

@implementation DZEditTimeSegmentView


- (void) handleDoubleTapGestrueRecg:(UITapGestureRecognizer*)dtrecg
{
    CGPoint point = [dtrecg locationInView:self];
    float rote = point.y / CGRectViewHeight;
    if (dtrecg.state == UIGestureRecognizerStateRecognized) {
        [self addDivisionLine:rote];
    }
    
}
- (void) commonInit
{
    _divisionLinesInfo = [NSMutableArray new];
    _lineViews         = [NSMutableArray new];
    _colorsCache       = [NSMutableDictionary new];
    [self addDivisionLine:0.05f];
    [self addDivisionLine:0.95f];
    [self addDivisionLine:1.0f];
    
    
    _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGestrueRecg:)];
    _doubleTapGesture.numberOfTapsRequired = 2;
    _doubleTapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:_doubleTapGesture];
}

- (void) addDivisionLine:(float)rote
{
    [_divisionLinesInfo addObject:@(rote)];
    [_divisionLinesInfo sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    DZEditTimeLine* line = [[DZEditTimeLine alloc] init];
    [self addSubview:line];
    [_lineViews addObject:line];
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
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
- (UIColor*) randomCellColorForRote:(float)rote
{
    UIColor* color = [_colorsCache objectForKey:@(rote)];
    if (!color) {
        NSDictionary* dic = [UIColor typeCellColors];
        NSInteger index = [_divisionLinesInfo indexOfObject:@(rote)];
        if (index == 0) {
            color = dic[@(rand()%dic.count)];
        } else if (index > 0 && index < (int)_divisionLinesInfo.count -1) {
            float upRote = [_divisionLinesInfo[index -1] floatValue];
            float downRote = [_divisionLinesInfo[index + 1] floatValue];
            UIColor* upIndexColor = _colorsCache[@(upRote)];
            UIColor* downIndexColor = _colorsCache[@(downRote)];
            for (; ; ) {
                color = dic[@(rand()%dic.count)];
                if (![upIndexColor isEqual:color] && ![downIndexColor isEqual:color]) {
                    break;
                }
            }
        }
        else
        {
            float upRote = [_divisionLinesInfo[index -1] floatValue];
            UIColor* upIndexColor = [self randomCellColorForRote:upRote];
            for (; ; ) {
                color = dic[@(rand()%dic.count)];
                if (![upIndexColor isEqual:color] ) {
                    break;
                }
            }
        }
        [_colorsCache setObject:color forKey:@(rote)];
    }
    return color;
}

- (NSArray*) rectsValues
{
    NSMutableArray* rectsValue = [NSMutableArray new];
    float centerComWidth      = 40;
    float centerComMinX       = CGRectViewWidth /2 - centerComWidth / 2 ;
    //
    int count = _divisionLinesInfo.count;
    //
    for (int index =  0; index < count; index ++) {
        float rote = [_divisionLinesInfo[index] floatValue];
        float height = CGRectViewHeight * rote;
        if (index == 0) {
            CGRect rect = CGRectMake(centerComMinX, 0, centerComWidth, height);
            [rectsValue addObject:[NSValue valueWithCGRect:rect]];
        } else
        {
            CGRect lastRect = [rectsValue[index-1] CGRectValue];
            height -= CGRectGetMaxY(lastRect);
            CGRect rect = CGRectMake(centerComMinX, CGRectGetMaxY(lastRect), centerComWidth, height);
            [rectsValue addObject:[NSValue valueWithCGRect:rect]];
        }
    }
    return rectsValue;
}

- (void) drawRect:(CGRect)rect
{
    //drawRects
    NSArray* rects = [self rectsValues];
    for (int i = 0; i < rects.count; i++) {
        UIBezierPath* bezierPath = [UIBezierPath bezierPathWithRect:[rects[i] CGRectValue]];
        float rote = [_divisionLinesInfo[i] floatValue];
        if (i == 0 || i == rects.count -1) {
            [[UIColor grayColor] setFill];
        } else {
            [[self randomCellColorForRote:rote] setFill];
        }
        [bezierPath fill];
    }
    
}

- (void) layoutSubviews
{
    NSArray* rects = [self rectsValues];
    for (int i = 0; i < rects.count; i ++) {
        DZEditTimeLine* line = _lineViews[i];
        CGRect rect = [rects[i] CGRectValue];
        line.frame = CGRectMake(0, CGRectGetMaxY(rect) - 10, CGRectViewWidth, 20);
    }
}

@end
