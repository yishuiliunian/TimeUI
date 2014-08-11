//
//  DZPieChart.m
//  TimeUI
//
//  Created by stonedong on 14-3-28.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZPieChart.h"
#import "DZChartNode.h"
#import "UIColor+DZColor.h"
#import "DZPieChartNode.h"
#import "DZColorUnit.h"
@interface DZPieChart ()
DEFINE_PROPERTY_STRONG(DZColorUnit*, colorUnit);
DEFINE_PROPERTY_STRONG(UITapGestureRecognizer*, tapGesture);
@end

@implementation DZPieChart

- (void) commonInit
{
    _colorUnit = [DZColorUnit new];
    //
    _nodes = [NSMutableArray new];
    _selectedItemFont = [UIFont systemFontOfSize:16];
    _selectedItemColor = [UIColor blackColor];
    
    INIT_GESTRUE_TAP_IN_SELF(_tapGesture, 1, 1);
    [_tapGesture addTarget:self action:@selector(handleTapGesture:)];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) handleTapGesture:(UITapGestureRecognizer*)tapRcgn
{
    CGPoint point = [tapRcgn locationInView:self];
    if (tapRcgn.state == UIGestureRecognizerStateRecognized) {
        DZPieChartNode* selectedNode = nil;
        for (DZPieChartNode* node  in _nodes) {
            if (CGPathContainsPoint(node.shapeLayer.path, nil, point, YES) ) {
                selectedNode = node;
            }
        }
        if (selectedNode) {
            for (DZPieChartNode* node  in _nodes) {
                if (node != selectedNode) {
                    node.isSpecial = NO;
                }
            }
            selectedNode.isSpecial = YES;
        }
        [self setNeedsDisplay];
    }
}

- (void) addChartNode:(DZChartNode *)node
{
    DZPieChartNode* pieChartNode = [[DZPieChartNode alloc] initWithChartNode:node];
    pieChartNode.shapeLayer.fillColor = [_colorUnit randomColor].CGColor;
    [_nodes addObject:pieChartNode];
    [self.layer addSublayer:pieChartNode.shapeLayer];
    [self setNeedsDisplay];
}
- (instancetype) initWithChartNodes:(NSArray *)nodes
{
    self = [super init];
    if (!self) {
        return self;
    }
    for (DZChartNode* node  in nodes) {
        [self addChartNode:node];
    }
    return nil;
}

-(CABasicAnimation*) strokeAnimation
{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    return pathAnimation;
}


- (void) drawRect:(CGRect)rect
{
    if (_nodes.count == 0) {
#warning 做清空画布的操作
        return;
    }
    
    CGFloat sumValue = 0;
    for (DZPieChartNode* node  in _nodes) {
        sumValue += node.value;
    }
    
    CGFloat startAngle = 0;
    
    CGPoint centerPoint = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    
    CGFloat cicleRedius = (CGRectGetWidth(self.frame) > CGRectGetHeight(self.frame) ? CGRectGetHeight(self.frame) : CGRectGetWidth(self.frame) ) /2 - 10;
    
    
    DZPieChartNode* selectedItemNode;
    for (int i = 0 ; i < _nodes.count; i++) {
        DZPieChartNode* node = _nodes[i];
        
        CGFloat percent = node.value / (CGFloat)sumValue;
        CGFloat nodeAngle = 2*M_PI * percent;
        
        if (i == 0) {
            startAngle = -M_PI / 2 - nodeAngle / 2;
        }

        
        CGPoint circleCenter = centerPoint;
        if (node.isSpecial) {
            CGFloat centerAngle = startAngle + nodeAngle / 2;
    
            CGPoint angleCenterPoint ;
            angleCenterPoint.x = centerPoint.x + cos(centerAngle)*cicleRedius;
            angleCenterPoint.y = centerPoint.y + sin(centerAngle)*cicleRedius;
            
            
            circleCenter.x +=  10* cos(centerAngle);
            circleCenter.y += 10 * sin(centerAngle);
            
            selectedItemNode = node;
        }

        
        CGFloat endAngle = startAngle + nodeAngle;
        
        UIBezierPath* path = [UIBezierPath bezierPath];
        [path moveToPoint:circleCenter];
        
        CGPoint startPoint;
        startPoint.x = circleCenter.x + cos(startAngle)*cicleRedius;
        startPoint.y = circleCenter.y + sin(startAngle)*cicleRedius;
        
        CGPoint endPoint;
        endPoint.x = circleCenter.x + cos(endAngle)*cicleRedius;
        endPoint.y = circleCenter.y + sin(startAngle)*cicleRedius;
        
        
        
        
        [path addLineToPoint:startPoint];
        
        [path addArcWithCenter:circleCenter radius:cicleRedius startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        [path addLineToPoint:circleCenter];
        [path closePath];
        
        node.shapeLayer.path = path.CGPath;
        if (node.isSpecial) {
            [node.shapeLayer addAnimation:[self strokeAnimation] forKey:@"strokeEnd"];
            node.shapeLayer.strokeEnd = 1.0;
        }
        else
        {
            [node.shapeLayer removeAllAnimations];
        }
        startAngle = endAngle;
    }
    
    
    CGRect circleRect = CGRectMake(centerPoint.x - cicleRedius, centerPoint.y - cicleRedius, 2*cicleRedius, 2*cicleRedius);
    
    CGSize titleSize = [selectedItemNode.key sizeWithFont:_selectedItemFont];
    
    CGFloat titleHeight = titleSize.height + 5;
    CGFloat restWidth = CGRectGetWidth(self.frame) - CGRectGetWidth(circleRect);
    CGPoint titleStartPoint = CGPointMake(0, CGRectGetMinY(circleRect));
    
    CGFloat titleXOffSetCenter = sqrt(2*cicleRedius*titleHeight - titleHeight*titleHeight);
    CGFloat titleXRestWidth = cicleRedius - titleXOffSetCenter;
    if (titleSize.width < titleXRestWidth) {
        titleStartPoint.x = CGRectGetMinX(circleRect);
    } else {
        if (restWidth/2 + titleXRestWidth > titleSize.width) {
            titleStartPoint.x = centerPoint.x - titleXOffSetCenter - titleSize.width;
        }
        else
        {
            titleStartPoint.x = 0;
        }
    }
    CGRect selectedItemTiltleRect = CGRectMake(titleStartPoint.x, titleStartPoint.y , CGRectViewWidth, titleHeight);
    
    [selectedItemNode.key drawInRect:selectedItemTiltleRect withFont:_selectedItemFont];
    
}
- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void) cleanAllNodes
{
    for (DZPieChartNode* node  in _nodes) {
        [node.shapeLayer removeFromSuperlayer];
    }
    [_nodes removeAllObjects];
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
