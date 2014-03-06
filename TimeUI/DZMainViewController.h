//
//  DZMainViewController.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZViewController.h"
#import "DZCheckTypeViewController.h"
#import "DZChartsViewController.h"

typedef enum {
    DZMainViewStateMidlle,
    DZMainViewStateTop
}DZMainViewState;

@interface DZMainViewController : DZViewController
@property (nonatomic, strong) DZCheckTypeViewController* typesViewController;
@property (nonatomic, strong) DZChartsViewController* chartsViewController;
@property (nonatomic, assign) DZMainViewState state;
@property (nonatomic, strong, readonly) DZAccount* account;
@end
