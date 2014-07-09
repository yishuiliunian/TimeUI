//
//  DZHistoryViewController.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-31.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZHistoryViewController.h"
#import "DZTime.h"
#import "NSString+WizString.h"
#import "NSString+database.h"
#import "NSDate+SSToolkitAdditions.h"
#import <NSDate-TKExtensions.h>

@interface DZHistoryViewController ()
@property (nonatomic, strong) NSMutableArray* _timeHistoryArray;
@end

@implementation DZHistoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    
    }
    return self;
}

- (void) popSelfPd
{
    [self.pdSuperViewController pdPopViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"时间沙漏，记录点滴";
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    [self addLeftBackItem];
    NSArray* times  = [[DZActiveTimeDataBase allTimes] mutableCopy];
    
    NSMutableDictionary* dayTimes = [NSMutableDictionary new];
    for (DZTime*  each in times) {
        NSString* str = [each.dateBegin TKDateDayMonthNameYear];
        if (str) {
            NSMutableArray* a = dayTimes[str];
            if (!a) {
                a = [NSMutableArray new];
                dayTimes[str] = a;
            }
            [a addObject:each];
        }
    }
    
    NSArray* allTimesKey = [dayTimes.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        return [obj2 compare:obj1];
    }];
    
    NSMutableArray* allSortedTimes = [NSMutableArray new];
    for (NSString* str in allTimesKey) {
        NSMutableArray* sortedA = dayTimes[str];
        [sortedA sortUsingComparator:^NSComparisonResult(DZTime* obj1, DZTime* obj2) {
            return [obj2.dateBegin compare:obj1.dateBegin];
        }];
        [allSortedTimes addObject:sortedA];
    }
    __timeHistoryArray = allSortedTimes;
    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return __timeHistoryArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [__timeHistoryArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    DZTime* time = __timeHistoryArray[indexPath.section][indexPath.row];
    cell.textLabel.text = time.typeName;
    cell.detailTextLabel.text = [NSString readableTimeStringWithInterval:ABS([time.dateBegin timeIntervalSinceDate:time.dateEnd])];
    return cell;
}


- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[__timeHistoryArray[section] firstObject] dateBegin] TKDateDayMonthNameYear];
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* contentView = [UIView new];
    contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 40);
    NSString* title = [self tableView:tableView titleForHeaderInSection:section];
    UILabel* titleLable = [UILabel new];
    [contentView addSubview:titleLable];
    titleLable.frame = contentView.bounds;
    titleLable.text = title;
    return contentView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
