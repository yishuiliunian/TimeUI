//
//  DZTopCostViewController.m
//  TimeUI
//
//  Created by stonedong on 14-3-29.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZTopCostViewController.h"
#import "DZChartNode.h"
#import "DZAnalysisManager.h"
#import "DZAnalysisNotificationInterface.h"
@interface DZTopCostViewController () <DZAnalysisAllCostNI>

@end

@implementation DZTopCostViewController
- (void) dealloc
{
    [DZDefaultNotificationCenter removeObserver:self forMessage:kDZNotification_AnalaysisAllCost];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [DZDefaultNotificationCenter addObserver:self forKey:kDZNotification_AnalaysisAllCost];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [DZShareAnalysisManager triggleAnaylysisTimeCost];
    [self parasedAllTimeCost];

    // Do any additional setup after loading the view.
}
- (void) parasedAllTimeCost
{
    NSDictionary* allCosts = [DZShareAnalysisManager allTimeCostModel];
    [self.pieChart cleanAllNodes];
    NSArray* allKeys = [allCosts allKeys];
    for (NSString* key  in allKeys) {
        DZChartNode* node1 = [[DZChartNode alloc] init];
        node1.value = [allCosts[key] longLongValue];;
        node1.key = key;
        [self.pieChart addChartNode:node1];
    }
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
