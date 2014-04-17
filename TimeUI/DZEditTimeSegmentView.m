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
#import "NSString+WizString.h"
#import <NSDate-TKExtensions.h>
//
#import "DZTime.h"
#import "DZTimeType.h"
#import "GLBucket.h"

@interface DZEditTimeSegmentView() <DZEditTimeLineDelegate, UIGestureRecognizerDelegate>
{
    
    NSMutableDictionary* _linesInfoDic;
    
    NSMutableDictionary* _colorsCache;
    
    UITapGestureRecognizer* _doubleTapGesture;
    DZEditTimeLine* _selectedLineView;
    
    UILongPressGestureRecognizer* _longPressRecg;
    
    NSMutableArray*  _timesDataArray;
    
    NSDate* _dateBegin;
    NSDate* _dateEnd;
    
    NSTimeInterval _totalTimeInterval;
    //
    DZTime* _editingTime;
    //
    NSMutableDictionary* _timeTypesCache;
    //
    BOOL _isShowDeleting;
    GLBucket* _glBucket;
    CALayer* _bucketContanierLayer;
}
@end

@implementation DZEditTimeSegmentView

- (void) commonInit
{
    self.backgroundColor = [UIColor clearColor];
    _linesInfoDic = [NSMutableDictionary new];
    _colorsCache       = [NSMutableDictionary new];
    _isShowDeleting = NO;
    
    _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGestrueRecg:)];
    _doubleTapGesture.numberOfTapsRequired = 2;
    _doubleTapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:_doubleTapGesture];
    //
    
    _longPressRecg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecgnizer:)];
    _longPressRecg.delegate = self;
    [self addGestureRecognizer:_longPressRecg];
    //
    _timesDataArray = [NSMutableArray new];
    _timeTypesCache = [NSMutableDictionary new];
    //
    _bucketContanierLayer = [CALayer new];
    CGRect bucketRect = CGRectMake(0, 0, 50, 40);
    _bucketContanierLayer.frame = bucketRect;
    _glBucket = [[GLBucket alloc] initWithFrame:bucketRect inLayer:_bucketContanierLayer];
    [self.layer addSublayer:_bucketContanierLayer];
    
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

- (instancetype) initWithTime:(DZTime *)time
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _dateBegin = time.dateBegin;
    _dateEnd = time.dateEnd;
    _totalTimeInterval = ABS([_dateEnd timeIntervalSinceDate:_dateBegin])/0.9;
    _editingTime = time;
    DZTimeType* type = [DZActiveTimeDataBase timeTypByGUID:time.typeGuid];
    [self addDivisionLine:0.05f withType:nil];
    [self addDivisionLine:0.95f withType:type];
    [self addDivisionLine:1.0f withType:nil];
    [_linesInfoDic[@(1.0f)] setHidden:YES];
    return self;
}
- (void) handleDoubleTapGestrueRecg:(UITapGestureRecognizer*)dtrecg
{
    CGPoint point = [dtrecg locationInView:self];
    float rote = point.y / CGRectViewHeight;
    if (dtrecg.state == UIGestureRecognizerStateRecognized) {
        if ([_delegate respondsToSelector:@selector(editTimeSegmentView:willAddLinewithRote:)] ) {
            [_delegate editTimeSegmentView:self willAddLinewithRote:rote];
        }
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void) handleLongPressGestureRecgnizer:(UILongPressGestureRecognizer*)lpRecg
{
    if (lpRecg.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [lpRecg locationInView:self];
        for (DZEditTimeLine* line  in _linesInfoDic.allValues) {
            if (CGRectContainsPoint(line.frame, point)) {
                [self editTimeLine:line didHanldeLongPress:nil];
                return;
            }
        }
    } else if(lpRecg.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [lpRecg locationInView:self];
        
        if (_selectedLineView) {
            CGRect frame = _selectedLineView.frame;
            frame.origin.y = point.y - CGRectGetHeight(frame)/2;
            _selectedLineView.frame = frame;
            float rote = point.y / CGRectViewHeight;
            [self changeLineView:_selectedLineView toRatio:rote];
            if (rote < 0.05f) {
                [self showTrashBunket];
            } else
            {
                [self hideTrashBunket];
            }
        }
    } else if(lpRecg.state == UIGestureRecognizerStateEnded)
    {
        if (_selectedLineView) {
            _selectedLineView.backgroundColor = [UIColor clearColor];
            if (_isShowDeleting) {
                NSNumber* ratio = @(_selectedLineView.ratio);
                [_linesInfoDic removeObjectForKey:ratio];
                [_timeTypesCache removeObjectForKey:ratio];
                [_selectedLineView removeFromSuperview];
                [self hideTrashBunket];
            }
            _selectedLineView = nil;
            [self setNeedsLayout];
            [self setNeedsDisplay];
            for (DZEditTimeLine* line  in _linesInfoDic.allValues) {
                line.alpha = 1.0;
            }
        }
    }
}



- (void) addDivisionLine:(float)rote withType:(DZTimeType*)type
{
    DZEditTimeLine* line = [[DZEditTimeLine alloc] init];
    line.delegate = self;
    [self addSubview:line];
    line.ratio = rote;
    line.typeString = type.name;
    _linesInfoDic[@(rote)] = line;
    [self setNeedsLayout];
    [self setNeedsDisplay];
    if (type) {
        _timeTypesCache[@(rote)] = type;
    }
}

- (void) changeLineView:(DZEditTimeLine*)line toRatio:(float)toRatio
{
    if (_linesInfoDic[@(toRatio)]) {
        return;
    }
    [_linesInfoDic removeObjectForKey:@(line.ratio)];
    [_linesInfoDic setObject:line forKey:@(toRatio)];
    DZTimeType* type = _timeTypesCache[@(line.ratio)];
    [_timeTypesCache removeObjectForKey:@(line.ratio)];
    if (type) {
        [_timeTypesCache setObject:type forKey:@(toRatio)];
    }
    line.ratio = toRatio;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}
- (void) editTimeLine:(DZEditTimeLine *)line didHanldeLongPress:(UILongPressGestureRecognizer *)recg
{
    NSArray* allLines = _linesInfoDic.allValues;
    _selectedLineView = line;
    
    for (DZEditTimeLine* each  in allLines) {
        if ([each isEqual:line]) {
            each.backgroundColor = [UIColor orangeColor];
        } else
        {
            each.alpha = 0.4;
        }
    }
}
- (NSString*) editTimeLine:(DZEditTimeLine *)line timeStringWithRote:(float)rote
{
    NSDate* date = [_dateBegin dateByAddingTimeInterval:_totalTimeInterval*(rote - 0.05)];
    return [date TKHourAndMinutes];
}

- (UIColor*) randomCellColorForRote:(float)rote
{
    UIColor* color = [_colorsCache objectForKey:@(rote)];
    if (!color) {
        
        NSArray* allInfos = _linesInfoDic.allKeys;
        allInfos = [allInfos sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        NSDictionary* dic = [UIColor typeCellColors];
        NSInteger index = [allInfos indexOfObject:@(rote)];
        if (index == 0) {
            color = dic[@(rand()%dic.count)];
        } else if (index > 0 && index < (int)allInfos.count -1) {
            float upRote = [allInfos[index -1] floatValue];
            float downRote = [allInfos[index + 1] floatValue];
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
            float upRote = [allInfos[index -1] floatValue];
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

- (NSDictionary*) rectsValues
{
    
    NSMutableDictionary* rectRatioDic = [NSMutableDictionary new];
    //
    NSMutableArray* rectsValue = [NSMutableArray new];
    float centerComWidth      = 40;
    float centerComMinX       = CGRectViewWidth /2 - centerComWidth / 2 ;
    //
    NSArray* allInfos = _linesInfoDic.allKeys;
    allInfos = [allInfos sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    int count = allInfos.count;
    //
    for (int index =  0; index < count; index ++) {
        float rote = [allInfos[index] floatValue];
        float height = CGRectViewHeight * rote;
        if (index == 0) {
            CGRect rect = CGRectMake(centerComMinX, 0, centerComWidth, height);
            [rectsValue addObject:[NSValue valueWithCGRect:rect]];
            rectRatioDic[allInfos[index]] = [NSValue valueWithCGRect:rect];

        } else
        {
            CGRect lastRect = [rectsValue[index-1] CGRectValue];
            height -= CGRectGetMaxY(lastRect);
            CGRect rect = CGRectMake(centerComMinX, CGRectGetMaxY(lastRect), centerComWidth, height);
            [rectsValue addObject:[NSValue valueWithCGRect:rect]];
            
            rectRatioDic[allInfos[index]] = [NSValue valueWithCGRect:rect];

        }
    }
    return rectRatioDic;
}

- (void) drawRect:(CGRect)rect
{
    //drawRects
    
    NSArray* allInfos = _linesInfoDic.allKeys;
    allInfos = [allInfos sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    NSDictionary* rects = [self rectsValues];
    for (int i = 0; i < rects.count; i++) {
        UIBezierPath* bezierPath = [UIBezierPath bezierPathWithRect:[rects[allInfos[i]] CGRectValue]];
        float rote = [allInfos[i] floatValue];
        if (_selectedLineView && [allInfos[i] compare:@(_selectedLineView.ratio)] == 0) {
            [[UIColor orangeColor] setFill];
        }
        else
        {
            if (i == 0 || i == rects.count -1) {
                [[UIColor grayColor] setFill];
            } else {
                [[self randomCellColorForRote:rote] setFill];
            }
        }

        [bezierPath fill];
    }
    
}

- (void) layoutSubviews
{
    _bucketContanierLayer.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(_bucketContanierLayer.frame),
                                             0,
                                             CGRectGetWidth(_bucketContanierLayer.frame),
                                             CGRectGetHeight(_bucketContanierLayer.frame));
    //
    
    NSArray* allInfos = _linesInfoDic.allKeys;
    allInfos = [allInfos sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSDictionary* rects = [self rectsValues];
    for (NSNumber* each  in allInfos) {
        DZEditTimeLine* line = _linesInfoDic[each];
        CGRect rect = [rects[each] CGRectValue];
        if (_selectedLineView) {
            if ([_selectedLineView isEqual:line]) {
                continue;
            }
        }
        line.frame = CGRectMake(0, CGRectGetMaxY(rect) - 10, CGRectViewWidth, 20);
    }

}


//
- (NSArray*) getAllEditedTimes
{
    NSMutableArray* allTimes = [NSMutableArray new];
    //
    NSArray* allInfos = _linesInfoDic.allKeys;
    allInfos = [allInfos sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    for (int i = 1; i < allInfos.count - 1; i++) {
        float preRato = [allInfos[i-1] floatValue];
        float ratio = [allInfos[i] floatValue];
        NSDate* dateBegin = [_dateBegin dateByAddingTimeInterval:_totalTimeInterval*(preRato - 0.05)];
        NSDate* dateEnd = [_dateBegin dateByAddingTimeInterval:_totalTimeInterval*(ratio - 0.05)];
        
        DZTimeType* type = _timeTypesCache[allInfos[i]];
        
        DZTime* time =[[DZTime alloc] initWithType:type begin:dateBegin end:dateEnd detal:nil];
        [allTimes addObject:time];
    }
    return allTimes;
}

- (void) showTrashBunket
{
    if (_isShowDeleting) {
        return;
    }
    [_glBucket openBucket];
    _isShowDeleting = YES;
}

- (void) hideTrashBunket
{
    if (!_isShowDeleting) {
        return;
    }
    [_glBucket closeBucket];
    _isShowDeleting = NO;
}
@end
