//
//  DZLineChart.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-11.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZLineChart.h"

#define DZLineChartDefaultMinYInterval 10
@interface DZLineChart ()
{
    UIBezierPath* _processLine;
    NSMutableArray* _yImaginaryLines;
    NSMutableSet* _nodeNoteCircles;
}
@property (nonatomic, assign) float animationTime;
@end
@implementation DZLineChart

- (void) commonInit
{
    _animationTime = 2;
    //
    _xLabelFont           = [UIFont systemFontOfSize:12];
    _xLabelColor          = [UIColor blackColor];
    //
    _yLabelFont           = [UIFont systemFontOfSize:12];
    _minYInterval         = 30;
    _yLabelColor          = [UIColor blackColor];

    _shapeLayer           = [CAShapeLayer layer];
    _shapeLayer.lineCap   = kCALineCapRound;
    _shapeLayer.lineJoin  = kCALineJoinBevel;
    _shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
    _shapeLayer.lineWidth = 2.0;
    _shapeLayer.strokeEnd = 0.0;
    [self.layer addSublayer:_shapeLayer];
    
    _xAxisLineLayer = [CAShapeLayer layer];
    _xAxisLineLayer.lineCap   = kCALineCapRound;
    _xAxisLineLayer.lineJoin  = kCALineJoinBevel;
    _xAxisLineLayer.fillColor = [[UIColor whiteColor] CGColor];
    _xAxisLineLayer.lineWidth = 3.0;
    _xAxisLineLayer.strokeEnd = 0.0;
    [self.layer addSublayer:_xAxisLineLayer];
    
    _yImaginaryLines = [NSMutableArray new];
    
    _nodeNoteCircles = [NSMutableSet new];
    //
    _lineColor = [UIColor blueColor];
    _gridColor = [UIColor lightGrayColor];
    _specialNodeColor = [UIColor orangeColor];
    
}


- (CAShapeLayer*) _aShapeLayer
{
    CAShapeLayer* anyLayer = [CAShapeLayer layer];
    anyLayer.lineCap   = kCALineCapRound;
    anyLayer.lineJoin  = kCALineJoinBevel;
    anyLayer.fillColor = [[UIColor whiteColor] CGColor];
    anyLayer.lineWidth = 3.0;
    anyLayer.strokeEnd = 0.0;
    return anyLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(CABasicAnimation*) strokeAnimation
{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = _animationTime;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    return pathAnimation;
}


- (void) drawRect:(CGRect)rect
{
    if (![_values count]) {
        return;
    }
    for (CAShapeLayer* l in _nodeNoteCircles) {
        [l removeFromSuperlayer];
    }
    [_nodeNoteCircles removeAllObjects];
    //init
    
    //draw y labels
    float max = 0;
    for (DZChartNode* node  in _values) {
        max = MAX(max, node.value);
    }
    max = MAX(10, 0);
    int64_t count            = _values.count;
    float yInterval          = max/count;

    float yAxisBottomOffSet  = 40;
    float yAxisTopOffSet     = 10;
    float yLabelsXOffset     = 10;
    float yLabelsWidth       = 20;
    float yAxisHeight        = CGRectGetHeight(self.frame) - yAxisBottomOffSet - yAxisTopOffSet;
    float yHInterval         = yAxisHeight/count;
    float xLabelsOffsetYAxis = 5;
    float xAxisOffSetRight   = 10;

    ////
    
    float xContextWidth      = CGRectGetWidth(self.frame) - yLabelsXOffset- yLabelsWidth - xAxisOffSetRight;
    float perXLabelWidth     = xContextWidth / _values.count;
    
    for (int i = _values.count; i > 0 ; i--) {
        count = i;
        yInterval = max/count;
        yHInterval = yAxisHeight / i;
        if (yHInterval > _minYInterval) {
            break;
        }
    }
    //
    NSMutableArray* gridLines = [NSMutableArray new];
    //
    CGPoint axisOriginPoint = CGPointZero;
    
    CGPoint yAxisMaxPoint = CGPointZero;

    for (int i = 0 ; i < count + 1; i++) {
        NSString* ytext = [@((int)floor(i*yInterval)) stringValue];
        
        CGRect rect = CGRectMake(yLabelsXOffset, CGRectGetHeight(self.frame) - ( yAxisBottomOffSet + yHInterval * (i +1)), yLabelsWidth, yHInterval);
        
        CGFloat textHeight = [ytext sizeWithFont:_yLabelFont constrainedToSize:CGSizeMake(1000, 1000)].height;
        CGRect yTextRect  = CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(rect) - textHeight/2, yLabelsWidth, textHeight);
        CGPoint currentYaxisPoint = CGPointMake(CGRectGetMaxX(rect) + xLabelsOffsetYAxis, CGRectGetMaxY(rect));
        if (i == 0) {
            axisOriginPoint = currentYaxisPoint;
        } else if (i == count) {
            yAxisMaxPoint = currentYaxisPoint;
        }
        [_yLabelColor setFill];
        [_yLabelColor setStroke];
        [ytext drawInRect:yTextRect  withAttributes:nil];
        UIBezierPath* path = [UIBezierPath bezierPath];
        CGPoint beginPoint = currentYaxisPoint;
        [path moveToPoint:beginPoint];
        [path addLineToPoint:CGPointMake(beginPoint.x + xContextWidth - perXLabelWidth, beginPoint.y )];
        [gridLines addObject:path];
    }
    float chartContentHeight = ABS(yAxisMaxPoint.y - axisOriginPoint.y);

    //draw x line
    
    UIBezierPath* xAxisLine = [UIBezierPath bezierPath];
    [xAxisLine moveToPoint:axisOriginPoint];
    [xAxisLine addLineToPoint:CGPointMake(axisOriginPoint.x+xContextWidth - perXLabelWidth, axisOriginPoint.y)];
    _xAxisLineLayer.strokeColor = _gridColor.CGColor;
    _xAxisLineLayer.path = xAxisLine.CGPath;
    [_xAxisLineLayer addAnimation:[self strokeAnimation] forKey:@"strokeEnd"];
    _xAxisLineLayer.strokeEnd = 1.0;
    //
    _processLine = [UIBezierPath bezierPath];
    _processLine.lineWidth = 1.0;
    [_processLine setLineCapStyle:kCGLineCapRound];
    [_processLine setLineJoinStyle:kCGLineJoinRound];
    //
    //
    CFTimeInterval currentTime = CACurrentMediaTime();
    CABasicAnimation* xAxisAnimation = [self strokeAnimation];
    xAxisAnimation.beginTime = currentTime;
    
    CGPoint* nodePoints = (CGPoint*)malloc(sizeof(CGPoint)*_values.count);

    for (int i = 0 ; i < _values.count; i++) {
        DZChartNode* node = _values[i];
        float y = node.value / (double)max * yAxisHeight;
        if (y > -0.01 && y < 0.01) {
            y = axisOriginPoint.y;
        }
        float x = perXLabelWidth* i+ axisOriginPoint.x;
        CGPoint point  = CGPointMake(x, y);
        nodePoints[i] = point;
        [_processLine addLineToPoint:point];
        [_processLine moveToPoint:point];
        
        CGPoint xaixsPoint = CGPointMake(x, axisOriginPoint.y);
        UIBezierPath* imagePath = [UIBezierPath bezierPath];
        [imagePath moveToPoint:xaixsPoint];
        [imagePath addLineToPoint:CGPointMake(x, axisOriginPoint.y - chartContentHeight)];
        [gridLines addObject:imagePath];
        
        //draw xaixs label
        
        CGSize xLabelSize = [node.key sizeWithFont:_xLabelFont constrainedToSize:CGSizeMake(100, 100)];
        
        CGRect xLabelRect = CGRectExpandPoint(xaixsPoint, xLabelSize);
        xLabelRect.origin.y = xaixsPoint.y + 5;
        
        [_xLabelColor setFill];
        [_xLabelColor setStroke];
        [node.key drawInRect:xLabelRect withFont:_xLabelFont];
        
    }
    _shapeLayer.path = _processLine.CGPath;
    _shapeLayer.strokeColor = _lineColor.CGColor;
    [_shapeLayer addAnimation:xAxisAnimation forKey:@"strokeEndAnimation"];
    _shapeLayer.strokeEnd = 1.0;
    
    for (UIBezierPath* path  in gridLines) {
        [_gridColor setStroke];
        [path stroke];
    }
    
    
    for (int i = 0 ; i < _values.count; i++) {
        CGPoint point =  nodePoints[i];
        CGSize size = CGSizeMake(5, 5);
        UIBezierPath* bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectExpandPoint(point, size)];

        
        CAShapeLayer* shape = [CAShapeLayer new];
        shape           = [CAShapeLayer layer];
        shape.lineCap   = kCALineCapRound;
        shape.lineJoin  = kCALineJoinBevel;
        shape.fillColor = [[UIColor whiteColor] CGColor];
        
        DZChartNode* node = _values[i];
        if (node.isSpecial) {
            shape.strokeColor = _specialNodeColor.CGColor;
        }
        else
        {
            shape.strokeColor = _lineColor.CGColor;
        }
        shape.lineWidth = 2.0;
        shape.strokeEnd = 1.0;
        shape.path = bezierPath.CGPath;
        [self.layer addSublayer:shape];
        [_nodeNoteCircles addObject:shape];
    }
    //
    
    free(nodePoints);
}
- (void) setLineColor:(UIColor *)lineColor
{
    if (_lineColor != lineColor) {
        _lineColor = lineColor;
        [self setNeedsDisplay];
    }
}
- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


@end
