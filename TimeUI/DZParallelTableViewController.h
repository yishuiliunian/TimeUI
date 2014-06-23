//
//  DZParallelTableViewController.h
//  TimeUI
//
//  Created by stonedong on 14-6-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZParallelTableView.h"
@interface DZParallelTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readonly) DZParallelTableView* parallelTableView;
@end
