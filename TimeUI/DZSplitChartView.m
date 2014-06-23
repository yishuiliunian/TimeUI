//
//  DZSplitChartView.m
//  TimeUI
//
//  Created by stonedong on 14-6-18.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZSplitChartView.h"
#import "DZChartNode.h"
#import "DZPieChartNode.h"

static CGFloat kTextLayerHeight = 40;
@interface DZNoteLayer : CALayer
@property (nonatomic, strong, readonly) CATextLayer* textLayer;
@property (nonatomic, strong, readonly) CAShapeLayer* colorLayer;
@property (nonatomic, assign) CGFloat percent;
@end

@implementation DZNoteLayer

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _textLayer = [CATextLayer new];
    _textLayer.alignmentMode = kCAAlignmentRight;
    _textLayer.fontSize = 15;
    _textLayer.foregroundColor = [UIColor blackColor].CGColor;
    _colorLayer = [CAShapeLayer new];
    [self addSublayer:_textLayer];
    [self addSublayer:_colorLayer];
    _percent = 1.0;
    return self;
}
- (void) layoutSublayers
{
    _textLayer.frame = CGRectMake(10, 0, CGRectGetWidth(self.frame)/2 - 20, CGRectGetHeight(self.frame));
    
    CGFloat width = (CGRectGetWidth(self.frame)/2)*_percent -20;
    width = width > 0 ? width : 1;
    _colorLayer.frame = CGRectMake(CGRectGetMaxX(_textLayer.frame)+20, 0, width, CGRectGetHeight(self.frame));
}

@end

@interface DZSplitChartView ()
{
    NSMutableArray* _nodes;
    NSMutableArray* _24nodes;
    NSMutableArray* _allTextLayers;
    NSMutableDictionary* _colorMap;
}
DEFINE_PROPERTY_STRONG_UILabel(zeroHourLabel);
DEFINE_PROPERTY_STRONG_UILabel(twHourLabel);
@end

@implementation DZSplitChartView
- (void) addChartNode:(DZChartNode *)node
{
    DZPieChartNode* pieChartNode = [[DZPieChartNode alloc] initWithChartNode:node];
    [_nodes addObject:pieChartNode];
    [self.layer addSublayer:pieChartNode.shapeLayer];
    if (_colorMap[node.key]) {
        pieChartNode.shapeLayer.fillColor = [_colorMap[node.key] CGColor];
    } else
    {
        _colorMap[node.key] = [UIColor colorWithCGColor:pieChartNode.shapeLayer.fillColor];
    }
    [self setNeedsDisplay];
}

- (void) commitInit
{
    _nodes = [NSMutableArray new];
    _colorMap = [NSMutableDictionary new];
    _24nodes = [NSMutableArray array];
    _allTextLayers = [NSMutableArray array];
    //
    _innerCiclePercent = 0.618;
    
    INIT_SELF_SUBVIEW_UILabel(_zeroHourLabel);
    INIT_SELF_SUBVIEW_UILabel(_twHourLabel);
    INIT_SELF_SUBVIEW(DZOvalMaskImageView, _avatarImageView);
    
    _zeroHourLabel.text = @"00:00 AM";
    _twHourLabel.text = @"12:00 PM";
    _zeroHourLabel.font = [UIFont boldSystemFontOfSize:13];
    _twHourLabel.font = [UIFont boldSystemFontOfSize:13];
    self.backgroundColor = [UIColor whiteColor];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [self commitInit];
    return self;
}
- (UIBezierPath*) pathForInnerRedius:(CGFloat) innerRedius
                         outerRedius:(CGFloat)outerRedius
                          startAngle:(CGFloat)startAngle
                            endAngle:(CGFloat)endAngle
                              center:(CGPoint)circleCenter
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    CGPoint(^PointPosition)(CGFloat angle, CGFloat redius) = ^(CGFloat angle, CGFloat redius) {
        CGPoint point;
        point.x = circleCenter.x + cos(angle)*redius;
        point.y = circleCenter.y + sin(angle)*redius;
        return point;
    };
    
    CGPoint outerStartPoint = PointPosition(startAngle, outerRedius);
    CGPoint outerEndPoint = PointPosition(endAngle, outerRedius);
    CGPoint innerStartPoint = PointPosition(startAngle, innerRedius);
    CGPoint innerEndPoint = PointPosition(endAngle, innerRedius);
    
    
    [path moveToPoint:innerStartPoint];
    [path addLineToPoint:outerStartPoint];
    [path addArcWithCenter:circleCenter radius:outerRedius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [path addLineToPoint:outerEndPoint];
    [path addLineToPoint:innerEndPoint];
    [path addArcWithCenter:circleCenter radius:innerRedius startAngle:endAngle endAngle:startAngle clockwise:NO];
    [path addLineToPoint:innerStartPoint];
    [path closePath];
    return path;
}
- (void) drawRect:(CGRect)rect
{
    if (_nodes.count == 0) {
        return;
    }
    CGFloat sumValue = 0;
    for (DZPieChartNode* node  in _nodes) {
        sumValue += node.value;
    }
    
    CGFloat startAngle = DEGREE_TO_ANGLE(-90);
    CGPoint centerPoint = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    CGFloat outerRedius = (CGRectGetWidth(self.frame) > CGRectGetHeight(self.frame) ? CGRectGetHeight(self.frame) : CGRectGetWidth(self.frame) ) /2 - 10;
    CGFloat decorateRedius = outerRedius - 5;
    CGFloat innerRedius = decorateRedius * _innerCiclePercent;
    
    CGFloat decorateStartAngle = DEGREE_TO_ANGLE(-90);
    
    for (CAShapeLayer* layer in _24nodes) {
        [layer removeFromSuperlayer];
    }
    for (int i = 1; i <= 24; i++) {
        CGFloat endAngle = startAngle + M_PI/12 * i;
        CAShapeLayer* shapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:shapeLayer];
        shapeLayer.fillColor = [UIColor whiteColor].CGColor;
        shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        
        shapeLayer.path = [self pathForInnerRedius:decorateRedius
                                        outerRedius:outerRedius
                                         startAngle:decorateStartAngle
                                           endAngle:endAngle
                                             center:centerPoint].CGPath;
        decorateStartAngle = endAngle;
    }
    
    for (int i = 0 ; i < _nodes.count; i++) {
        DZPieChartNode* node = _nodes[i];
        CGFloat percent = node.value / (CGFloat)sumValue;
        CGFloat nodeAngle = 2*M_PI * percent;
        CGPoint circleCenter = centerPoint;
        CGFloat endAngle = startAngle + nodeAngle;
        node.shapeLayer.path = [self pathForInnerRedius:innerRedius
                                            outerRedius:decorateRedius
                                             startAngle:startAngle
                                               endAngle:endAngle
                                                 center:circleCenter].CGPath;
        startAngle = endAngle;
    }
    
    
    CGFloat startY = centerPoint.y + outerRedius + 10;
    
    
    for (DZNoteLayer* layer in _allTextLayers) {
        [layer removeFromSuperlayer];
    }
    
    int64_t max = 0;
    int64_t sum = 0;
    
    NSMutableDictionary* trimNodesMap = [NSMutableDictionary new];
    for (DZPieChartNode* node  in _nodes) {
        DZPieChartNode* trimNode = node;
        if (trimNodesMap[node.key]) {
            trimNode = trimNodesMap[node.key];
            trimNode.chartNode.value += node.value;
        } else
        {
            trimNodesMap[node.key] = node;
        }
    }
    NSArray* trimNodes = [trimNodesMap allValues];
    trimNodes = [trimNodes sortedArrayUsingComparator:^NSComparisonResult(DZPieChartNode*  obj1, DZPieChartNode* obj2) {
        return obj1.chartNode.value < obj2.chartNode.value;
    }];
    
    
    for (DZPieChartNode* node  in trimNodes) {
        max = node.value > max ? node.value : max;
        sum += node.value;
    }
    
    for (int i = 0; i < trimNodes.count; i++) {
        DZPieChartNode* node = trimNodes[i];
        CGRect textRect = CGRectMake(10, startY, outerRedius*2, 30);
        DZNoteLayer* layer = [DZNoteLayer layer];
        layer.textLayer.string = node.key;
        layer.colorLayer.backgroundColor = [_colorMap[node.chartNode.key] CGColor];
        layer.frame = textRect;
        [_allTextLayers addObject:layer];
        [self.layer addSublayer:layer];
        layer.percent = node.value / (float)max;
        startY += 40;
    }
    
    //
    self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), centerPoint.y + outerRedius + 10 + kTextLayerHeight * trimNodes.count);
    
    CGRect zeroHourRect = CGRectMake(centerPoint.x - 30, centerPoint.y - outerRedius - 20, 60, 20);
    _zeroHourLabel.frame = zeroHourRect;
    CGRect twHourRect = CGRectMake(centerPoint.x - 30, centerPoint.y + outerRedius - 30 , 60, 20);
    _twHourLabel.frame = twHourRect;
    
    //
    CGRect centerRect = CGRectZero;
    centerRect.origin = CGPointMake(centerPoint.x - innerRedius, centerPoint.y - innerRedius);
    centerRect.size = CGSizeMake(innerRedius*2, innerRedius*2);

    UIImage* image = DZCachedImageByName(@"bg_types");
    
    _avatarImageView.frame = centerRect;
    _avatarImageView.image = image;
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
