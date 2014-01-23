//
//  DZTableViewController.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZAstirFrameViewController.h"
#import "DZTableView.h"
@interface DZTableViewController : DZAstirFrameViewController <DZTableViewSourceDelegate, DZTableViewActionDelegate>
@property (nonatomic, strong) UIImageView* headerView;
@property (nonatomic, strong) UIImageView* backgroudView;
@property (nonatomic, strong ,readonly) DZTableView* tableView;
@end
