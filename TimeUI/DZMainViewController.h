//
//  DZMainViewController.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZViewController.h"
#import "DZTypesViewController.h"
#import "DZChartsViewController.h"
@interface DZMainViewController : DZViewController
@property (nonatomic, strong) DZTypesViewController* typesViewController;
@property (nonatomic, strong) DZChartsViewController* chartsViewController;
@property (nonatomic, strong, readonly) DZAccount* account;
@end
