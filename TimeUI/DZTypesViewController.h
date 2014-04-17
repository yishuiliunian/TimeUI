//
//  DZTypesViewController.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-11.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZAstirFrameViewController.h"
#import "DZTableViewController.h"
#import "DZInputCellView.h"
@class DZTypesViewController;
@protocol DZSelectTypeDelegate <NSObject>

- (void) typesViewController:(DZTypesViewController*)vc didSelect:(DZTimeType*)type;

@end

@interface DZTypesViewController : DZTableViewController<UITableViewDataSource, UITableViewDelegate, DZInputCellViewDelegate>
{
    NSMutableArray* _typesArray;
    NSMutableArray* _timeTypes;
    
}
@property (nonatomic, weak) id<DZSelectTypeDelegate> selectDelegate;

- (void) reloadAllData;

- (void) didAddTypes:(DZTimeType*)type;
- (void) didRemoveTypes:(DZTimeType*)type;
@end
