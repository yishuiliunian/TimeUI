//
//  DZChartsViewController.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZViewController.h"
#import "DZPageScrollViewController.h"
@interface DZChartsViewController : DZPageScrollViewController
@property (nonatomic, strong) NSArray* chartsViewContoller;
- (instancetype) initWithChartControllers:(NSArray*)vcs;
@end
