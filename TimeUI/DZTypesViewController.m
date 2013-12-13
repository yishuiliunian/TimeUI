//
//  DZTypesViewController.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-11.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTypesViewController.h"
#import "DZDBManager.h"
#import "DZTimeType.h"
@interface DZTypesViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView* _typesTableView;
    NSMutableArray* _typesArray;
}
@end

@implementation DZTypesViewController
@synthesize selectDelegate = _selectDelegate;
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
    _typesTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_typesTableView];
    _typesTableView.dataSource = self;
    _typesTableView.delegate = self;
    _typesArray = [[DZActiveTimeDataBase allTimeTypes] mutableCopy];
	// Do any additional setup after loading the view.
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZTimeType* type = _typesArray[indexPath.row];
    if ([_selectDelegate respondsToSelector:@selector(typesViewController:didSelect:)]) {
        [_selectDelegate typesViewController:self didSelect:type];
    }
}

- (void) viewWillLayoutSubviews
{
    _typesTableView.frame = self.view.bounds;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_typesArray count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* const cellIdentifiy = @"types_cells";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiy];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifiy];
    }
    DZTimeType* type = [_typesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = type.name;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
