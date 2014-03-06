//
//  UIView+FrameAnimation.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-9.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DZAnimationState;

@interface UIView (FrameAnimation)
@property (nonatomic, assign) NSInteger currentStateIndex;
@property (nonatomic, strong) NSArray* states;
- (void) moveToIndex:(NSInteger)index withProgress:(float)progress;
- (void) moveAllSubViewsToIndex:(NSUInteger)index withProcess:(float)process;
@end
