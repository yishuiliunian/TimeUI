//
//  DZPieChartViewController.m
//  TimeUI
//
//  Created by stonedong on 14-3-28.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZPieChartViewController.h"
#import "DZChartNode.h"

@interface DZPieChartViewController ()

@end

@implementation DZPieChartViewController
@synthesize pieChart = _pieChart;
- (DZPieChart*) pieChart
{
    if (!_pieChart) {
        _pieChart = [[DZPieChart alloc] initWithFrame:CGRectLoadViewFrame];
    }
    return _pieChart;
}

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
    self.view = self.pieChart;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
