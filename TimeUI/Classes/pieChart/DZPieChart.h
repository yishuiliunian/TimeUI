//
//  DZPieChart.h
//  TimeUI
//
//  Created by stonedong on 14-3-28.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DZChartNode;
@interface DZPieChart : UIView
{
    NSMutableArray* _nodes;
}

DEFINE_PROPERTY_STRONG(UIColor*, selectedItemColor);
DEFINE_PROPERTY_STRONG(UIFont*, selectedItemFont);
DEFINE_PROPERTY_ASSIGN_Float(centerRediusPercent);
- (void) cleanAllNodes;
- (void) addChartNode:(DZChartNode*)node;
- (instancetype) initWithChartNodes:(NSArray*)nodes;
@end
