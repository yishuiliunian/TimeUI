//
//  DZChartViewController.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-11.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZChartViewController.h"
#import <PNChart.h>
#import "DZTime.h"
#import <KXKiOS7Colors.h>
@interface DZChartViewController ()
{
    PNChart* _charView;
}
@end

@implementation DZChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewDidLayoutSubviews
{
    _charView.frame = self.view.bounds;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _charView = [[PNChart alloc] init];
    _charView.clearsContextBeforeDrawing = YES;
    _charView.xLabels= @[@"x", @"y", @"z", @"a", @"b"];
    _charView.yValues = @[@1, @2 , @9, @2, @6];
    [self.view addSubview:_charView];
    _charView.frame = self.view.bounds;
    _charView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_charView strokeChart];
    _charView.backgroundColor = [KXKiOS7Colors lightBlue];
	// Do any additional setup after loading the view.
}

- (NSDictionary*) parseOnweakTimeData:(NSArray*)array
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
    
    NSMutableDictionary* dic = [NSMutableDictionary new];
    for (int i = 0 ; i < 7 ; i++) {
        dic[[@(i) stringValue]] = @(a[i]);
    }
    return dic;
}
- (void) showLineChartForType:(DZTimeType*)type
{
    NSArray* array =  [DZActiveTimeDataBase timesInOneWeakByType:type];
    NSDictionary* dic = [self parseOnweakTimeData:array];
    _charView.lineChart.xLabels = dic.allKeys;
    _charView.lineChart.yValues = dic.allValues;
    [_charView.lineChart strokeChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
