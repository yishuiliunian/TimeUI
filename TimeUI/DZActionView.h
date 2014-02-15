//
//  DZActionView.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-18.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZCustomeView.h"
#import "DZActionContentView.h"
#import "DZActionItemView.h"


@class DZActionView;
@protocol DZActionDelegate <NSObject>

- (BOOL) actionView:(DZActionView*)actionView shouldHideTapAtIndex:(NSInteger)index item:(DZActionItemView*)item;

- (void) actionView:(DZActionView*)actionView didHideWithTapAtIndex:(NSInteger)index item:(DZActionItemView*)item;
@end

@interface DZActionView : DZCustomeView <DZActionTapInterface>
@property (nonatomic, weak) id<DZActionDelegate> delegate;
@property (nonatomic, strong, readonly) DZActionContentView* actionContentView;
- (instancetype) initWithItems:(NSArray*)items;
@end




@interface UIView (DZAction)
@property (nonatomic, strong, readonly) DZActionView* dzActionView;
@end