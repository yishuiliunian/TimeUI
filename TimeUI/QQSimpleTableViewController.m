//
//  QQSimpleTableViewController.m
//  QQMSFContact
//
//  Created by Stone Dong on 14-2-12.
//
//

#import "QQSimpleTableViewController.h"


@interface QQSimpleTableViewController ()

@end

@implementation QQSimpleTableViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView
{
     _tableView = [[UITableView alloc] initWithFrame:CGRectLoadViewFrame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.view = _tableView;
}
- (void) loadData
{
    _sectionData = [NSArray new];
}

- (void) reloadAllData
{
    [self loadData];
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadAllData];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _tableView.backgroundView = nil;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionData.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sectionData[section] rowCount];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cells";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];


    }

    //
    
    QQSTRow* row = [_sectionData[indexPath.section] rowAtIndex:indexPath.row];
    [self updateTableViewCell:cell forRowData:row];
    return cell;
}
- (void) updateTableViewCell:(UITableViewCell*)cell forRowData:(QQSTRow*)row
{
    cell.textLabel.text = row.title;
    cell.detailTextLabel.text = row.detail;
    cell.accessoryType = row.accessoryType;
    cell.accessibilityLabel = row.title;
}

- (NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [[_sectionData objectAtIndex:section] footerTitle];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* title = [[_sectionData objectAtIndex:section] headerTitle];
    if (!title) {
        return [[_sectionData objectAtIndex:section] title];
    }
    return title;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QQSTRow* row = [_sectionData[indexPath.section] rowAtIndex:indexPath.row];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (row.actionTarget && [row.actionTarget respondsToSelector:row.action]) {
        [row.actionTarget performSelector:row.action];
    }
#pragma clang diagnostic pop
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString* text = [self tableView:tableView titleForFooterInSection:section];
    if (!text) {
        return nil;
    }
    UILabel* label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = text;
    label.textAlignment = UITextAlignmentLeft;
    label.numberOfLines = 0;
    
    UIView* view = [UIView new];
    view.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 20);
    [view addSubview:label];
    
    label.frame = CGRectMake(13, 0, CGRectGetWidth(self.tableView.frame)-28, 20);
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSString* text = [self tableView:tableView titleForFooterInSection:section];
    if (!text) {
        return 10;
    }
    UIFont* font = [UIFont systemFontOfSize:14];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(CGRectGetWidth(self.tableView.frame), CGFLOAT_MAX)];
    return size.height + 10;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    return 10;
}

@end
