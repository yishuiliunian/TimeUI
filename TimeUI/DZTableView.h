//
//  DZTableView.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZTableViewSourceDelegate.h"
#import "DZTableViewCell.h"
#import "DZPullDownView.h"
#import "DZPullDownDelegate.h"
#import "DZTableViewActionDelegate.h"

@interface DZTableView : UIScrollView
@property (nonatomic, strong, readonly) NSArray* visibleCells;
@property (nonatomic, weak) id<DZTableViewActionDelegate> actionDelegate;
@property (nonatomic, weak) id<DZTableViewSourceDelegate> dataSource;
@property (nonatomic, weak) id<DZPullDownDelegate> pulldownDelegate;
@property (nonatomic, strong) DZPullDownView* topPullDownView;
- (DZTableViewCell*) dequeueDZTalbeViewCellForIdentifiy:(NSString*)identifiy;
- (void) reloadData;
- (void) insertRowAt:(NSSet *)rowsSet withAnimation:(BOOL)animation;
@end
