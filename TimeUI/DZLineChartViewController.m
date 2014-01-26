//
//  DZLineChartViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-8.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZLineChartViewController.h"
#import "DZDBManager.h"
#import "DZTime.h"
#import <NSDate-TKExtensions.h>
@interface DZLineChartViewController ()

@end

@implementation DZLineChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) loadView
{
    _lineChart = [[DZLineChart alloc] initWithFrame:CGRectLoadViewFrame];
    self.view = _lineChart;
}

- (void) loadViewCSS:(id)cssValue forKey:(NSString *)key
{
    if ([key isEqualToString:@"chart_line"]) {
        _lineChart.lineColor = cssValue;
    }
}
- (NSArray*) parseOnweakTimeData:(NSArray*)array
{
    float a[7] = {0,0,0,0,0,0,0};
    for (DZTime* time  in array) {
        NSDictionary* costs = [time parseDayCost];
        NSArray* keys = costs.allKeys;
        for (NSNumber* each  in keys) {
            float cost = [costs[each] floatValue];
            a[[each intValue]] += cost;
        }
    }
    
    NSMutableArray* nodes = [NSMutableArray new];
    
    NSDate* date = [NSDate date];
    NSInteger weekDay = [date TKRealWeekday];

    #define ADD_NODE(name, i)     DZChartNode* node##name = [DZChartNode new];\
    node##name.key = @""#name;\
    node##name.value = a[i];\
    [nodes addObject:node##name];\
    if (i == weekDay) { node##name.isSpecial = YES;}
    
    
    ADD_NODE(Mon, 1);
    ADD_NODE(Tue, 2);
    ADD_NODE(Wed, 3);
    ADD_NODE(Thu, 4);
    ADD_NODE(Fri, 5);
    ADD_NODE(Sat, 6);
    ADD_NODE(Sun, 7);

    
    return nodes;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    DZTimeType* type = [DZActiveTimeDataBase allTimeTypes].firstObject;
    NSArray* array =  [DZActiveTimeDataBase timesInOneWeakByType:type];
    NSArray* nodes = [self parseOnweakTimeData:array];
    _lineChart.values = nodes;
    [_lineChart setNeedsDisplay];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.lineChart setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
