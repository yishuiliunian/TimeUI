//
//  UIView+FrameAnimation.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-9.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "UIView+FrameAnimation.h"
#import "DZKVODefines.h"
#import <objc/runtime.h>
#import "DZAnimationState.h"
@implementation UIView (FrameAnimation)

@dynamic currentStateIndex;
@dynamic states;

- (void) setCurrentStateIndex:(NSInteger)currentStateIndex
{
    objc_setAssociatedObject(self, kDZObjectKeyCurrentStateIndex, @(currentStateIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger) currentStateIndex
{
    return [objc_getAssociatedObject(self, kDZObjectKeyCurrentStateIndex) integerValue];
}

- (void) setStates:(NSArray *)states
{
    objc_setAssociatedObject(self, kDZObjectKeyStates, states, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray*) states
{
    return objc_getAssociatedObject(self, kDZObjectKeyStates);
}


- (void) didMoveToAnimationStateIndex:(NSInteger)index
{
  
}

- (void) moveToIndex:(NSInteger)index withProgress:(float)progress
{
    if (self.currentStateIndex == index) {
        return;
    }
    NSArray* states = self.states;
    DZAnimationState* aimState = nil;
    if (index >= states.count || index < 0) {
        aimState = DZAnimationStateZero;
    }
    else
    {
        aimState = states[index];
    }
    DZAnimationState* originState = states[self.currentStateIndex];
    DZAnimationState* inState = [originState stateMoveTo:aimState inProcess:progress];
    if ([inState isSupportAnimationKey:DZAnimationKeyFrame]) {
        self.frame = inState.frame;
    }
    if ([inState isSupportAnimationKey:DZAnimationKeyAlpha]) {
        self.alpha = inState.alpha;
    }
    if (ABS(progress - 1.00) <= 0.00001 ) {
        self.currentStateIndex = index;
        [self didMoveToAnimationStateIndex:self.currentStateIndex];
    }
}

@end
