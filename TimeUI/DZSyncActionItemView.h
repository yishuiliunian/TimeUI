//
//  DZSyncActionItemView.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-19.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZActionItemView.h"
@class DZSyncActionItemView;
@protocol DZActionChangeAccountDelegate
- (void) syncActionItemViewRigsterAccount:(DZSyncActionItemView*)itemView;
- (void) syncActionItemViewLoginAccount:(DZSyncActionItemView*)itemView;

@end

@interface DZSyncActionItemView : DZActionItemView
@property (nonatomic, weak) NSObject<DZActionChangeAccountDelegate>* accountDelegate;
@end
