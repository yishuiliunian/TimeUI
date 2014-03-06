//
//  DZDragViewController.h
//  TimeUI
//
//  Created by Stone Dong on 13-11-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZCheckTypeViewController.h"
#import "DZCenterButtonViewController.h"
#import "DZChartViewController.h"
typedef enum {
    DZDragViewStateCenter,
    DZDragViewStateBottom,
    DZDragViewStateTop
}DZDragViewState;

@interface DZDragViewController : UIViewController <DZSelectTypeDelegate>
@property (nonatomic, strong) DZCheckTypeViewController* topViewController;
@property (nonatomic, strong) DZCenterButtonViewController* centerViewController;
@property (nonatomic, strong) DZChartViewController* bottomViewController;
@property (nonatomic, assign , readonly) DZDragViewState dragState;
@property (nonatomic, assign) float middleHeight;
@end
