//
//  DZTableViewController.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTableViewController.h"
#import "DZGeometryTools.h"
@interface DZTableViewController () <DZPullDownDelegate>

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
    
    DZPullDownView* pullView = [[DZPullDownView alloc] init];
    
    UILabel* a = [[UILabel alloc] init];
    a.textAlignment = NSTextAlignmentCenter;
    a.text = @"asdfasdfasdfasdfasd";
    pullView.height = 44;
    a.backgroundColor = [UIColor blueColor];
    pullView.contentView = a;
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

- (CGFloat) dzTableView:(DZTableView *)tableView cellHeightAtRow:(NSInteger)row
{
    return 40;
}
- (NSInteger) numberOfRowsInDZTableView:(DZTableView *)tableView
{
    return 100;
}

- (DZTableViewCell*) dzTableView:(DZTableView *)tableView cellAtRow:(NSInteger)row
{
    static NSString* const cellIdentifiy = @"detifail";
    DZTableViewCell* cell = [tableView dequeueDZTalbeViewCellForIdentifiy:cellIdentifiy];
    if (!cell) {
        cell = [[DZTableViewCell alloc] initWithIdentifiy:cellIdentifiy];
    }
    float redColor = 20.0f;
    
    cell.backgroundColor = [UIColor colorWithRed:redColor / 255.0 * (row %10) green:redColor / 255.0 * (row %10) blue:redColor / 255.0 * (row %10) alpha:1];
    return cell;
}


- (void) pullDownView:(DZPullDownView *)pullDownView didChangedState:(DZPullDownViewState)originState toState:(DZPullDownViewState)aimState
{
    NSLog(@"change state %d to state %d",originState, aimState);
}

@end
