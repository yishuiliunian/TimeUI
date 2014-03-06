//
//  DZLineChart.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-11.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "PNLineChart.h"
#import "DZChartNode.h"

@interface DZLineChart : UIView
@property (nonatomic, strong, readonly) CAShapeLayer* shapeLayer;
@property (nonatomic, strong, readonly) CAShapeLayer* xAxisLineLayer;
@property (nonatomic, strong) UIFont* yLabelFont;
@property (nonatomic, strong) UIFont* xLabelFont;
@property (nonatomic, strong) UIColor* xLabelColor;
@property (nonatomic, strong) UIColor* yLabelColor;
@property (nonatomic, strong) UIColor* lineColor;
DEFINE_PROPERTY_STRONG(UIColor*, gridColor);
DEFINE_PROPERTY_STRONG(UIColor*, specialNodeColor);
@property (nonatomic, assign) float minYInterval;
@property (nonatomic, strong) NSArray*  values;
@end
