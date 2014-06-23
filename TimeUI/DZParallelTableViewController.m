//
//  DZParallelTableViewController.m
//  TimeUI
//
//  Created by stonedong on 14-6-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZParallelTableViewController.h"

@interface DZParallelTableViewController ()

@end

@implementation DZParallelTableViewController
@synthesize parallelTableView = _parallelTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (DZParallelTableView*) parallelTableView
{
    if (!_parallelTableView) {
        _parallelTableView = [[DZParallelTableView alloc] initWithFrame:CGRectLoadViewFrame];
        _parallelTableView.delegate = self;
        _parallelTableView.dataSource = self;
    }
    return _parallelTableView;
}

- (void) loadView
{
    self.view = self.parallelTableView;
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
