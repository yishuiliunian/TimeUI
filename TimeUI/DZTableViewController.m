//
//  DZTableViewController.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTableViewController.h"
#import "DZGeometryTools.h"
#import "DZInputCellView.h"
#import "DZTimeType.h"
#import "DZTypeCell.h"
@interface DZTableViewController () <DZPullDownDelegate, UIScrollViewDelegate, DZInputCellViewDelegate>
{
}
@end

@implementation DZTableViewController
@synthesize tableView = _tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (DZTableView*) tableView
{
    if (!_tableView) {
        _tableView = [[DZTableView alloc] initWithFrame:CGRectLoadViewFrame];
    }
    return _tableView;
}

- (void) loadView
{
    if (!_tableView) {
        _tableView = [[DZTableView alloc] initWithFrame:CGRectLoadViewFrame];
    }
    _tableView.dataSource = self;
    self.view = _tableView;
    _tableView.delegate = self;
    _tableView.actionDelegate = self;
    DZPullDownView* pullView = [[DZPullDownView alloc] init];
    pullView.height = 44;
    pullView.delegate = self;
    _tableView.topPullDownView = pullView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillLayoutSubviews
{
    
}

@end
