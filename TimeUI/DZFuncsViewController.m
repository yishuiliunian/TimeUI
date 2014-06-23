//
//  DZFuncsViewController.m
//  TimeUI
//
//  Created by stonedong on 14-6-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZFuncsViewController.h"
#import "DZFuncCell.h"
#import "DZFunctionsManager.h"
#import "DZSplitChartView.h"
@interface DZFuncsViewController ()
{
    NSMutableArray* _allFunctions;
}
@end

@implementation DZFuncsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) reloadAllData
{
    _allFunctions = [DZFunctionsDefaultManager.functions mutableCopy];
    [self.parallelTableView reloadData];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"牛逼功能再次";
    
    [self reloadAllData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allFunctions.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* const kDZIdentifier = @"parallelCells";
    DZFuncCell* cell = [tableView dequeueReusableCellWithIdentifier:kDZIdentifier];
    if (!cell) {
        cell = [[DZFuncCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDZIdentifier];
    }
    DZFuncPlugin* plugin = _allFunctions[indexPath.row];
    cell.backgroudImageView.image = DZCachedImageByName(plugin.detailImage);
    cell.nameLabel.label.text = plugin.name;
    cell.nameLabel.backgroundImageView.backgroundColor = [UIColor whiteColor];
    cell.nameLabel.backgroundImageView.alpha = 0.5;
    //
    cell.contentDetailLabel.label.text = plugin.detail;
    cell.contentDetailLabel.backgroundImageView.backgroundColor = [UIColor greenColor];
    cell.contentDetailLabel.backgroundImageView.alpha = 0.3;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZFuncPlugin* plugin = _allFunctions[indexPath.row];
    if (plugin.type == DZFuncPluginViewController) {
        Class c = NSClassFromString(plugin.className);
        UIViewController* vc = [[c alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
