//
//  DZLineChartViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-8.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZLineChartViewController.h"

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray* nodes = [NSMutableArray new];
    for (int i = 0 ; i < 9 ; i++) {
        DZChartNode* node = [DZChartNode new];
        node.value = rand()%100;
        node.key = [@(i) stringValue];
        
        [nodes addObject:node];
    }
    [nodes[5] setIsSpecial:YES];
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
