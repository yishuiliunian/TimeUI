//
//  DZActionContentView.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-18.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZActionItemView.h"
@class DZActionContentView;
@protocol DZActionTapInterface
- (void) actionContentView:(DZActionContentView*)contentView didTapItem:(DZActionItemView*)item atIndex:(NSInteger)index;
@end
@class DZActionView;

@interface DZActionContentView : UIView
@property (nonatomic, weak) NSObject<DZActionTapInterface>* tapDelegate;
@property (nonatomic, assign, readonly) float height;
@property (nonatomic, strong) NSArray* items;
- (instancetype) initWithItems:(NSArray*)items;
@end
