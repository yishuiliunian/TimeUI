//
//  DZChartViewController.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-11.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZChartViewController.h"
#import <PNChart.h>
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

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
