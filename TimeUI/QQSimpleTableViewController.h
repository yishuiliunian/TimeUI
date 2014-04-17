//
//  QQSimpleTableViewController.h
//  QQMSFContact
//
//  Created by Stone Dong on 14-2-12.
//
//


#import "QQSTSection.h"
#import "QQSTRow.h"

@interface QQSimpleTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray* _sectionData;
}
@property (nonatomic, strong, readonly) UITableView* tableView;
- (void) updateTableViewCell:(UITableViewCell*)cell forRowData:(QQSTRow*)row;
- (void) loadData;
- (void) reloadAllData;
@end
