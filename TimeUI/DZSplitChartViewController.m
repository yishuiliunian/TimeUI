//
//  DZSplitChartViewController.m
//  TimeUI
//
//  Created by stonedong on 14-6-18.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZSplitChartViewController.h"
#import "DZ24Analysis.h"
#import "DZChartNode.h"
@interface DZSplitChartViewController ()

@end

@implementation DZSplitChartViewController
@synthesize splitChartView = _splitChartView;
- (DZSplitChartView*) splitChartView
{
    if (!_splitChartView) {
        _splitChartView = [[DZSplitChartView alloc] initWithFrame:CGRectLoadViewFrame];
    }
    return _splitChartView;
}

- (void) loadView
{
    self.view = self.splitChartView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray* array = [DZ24Analysis chartNodes];
    for (DZChartNode* node  in array) {
        [self.splitChartView addChartNode:node];
    }
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
