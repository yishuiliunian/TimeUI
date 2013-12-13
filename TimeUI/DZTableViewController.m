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
@interface DZTableViewController () <DZPullDownDelegate, UIScrollViewDelegate>

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
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    _tableView.topPullDownView.topYOffSet = _tableView.contentOffset.y ;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_tableView.topPullDownView.state == DZPullDownViewStateToggled) {
        DZInputCellView* inputView = [[DZInputCellView alloc] init];
        [inputView showInView:[UIApplication sharedApplication].keyWindow withAnimation:YES completion:^{
            
        }];
    }
    
}

@end
