//
//  DZTableViewController.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZTableView.h"
@interface DZTableViewController : UIViewController <DZTableViewSourceDelegate>
@property (nonatomic, strong ,readonly) DZTableView* tableView;
@end
