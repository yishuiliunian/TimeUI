//
//  DZSplitChartView.h
//  TimeUI
//
//  Created by stonedong on 14-6-18.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DZChartNode;
@interface DZSplitChartView : UIScrollView
DEFINE_PROPERTY_ASSIGN_Float(innerCiclePercent);
- (void) addChartNode:(DZChartNode *)node;
@end
