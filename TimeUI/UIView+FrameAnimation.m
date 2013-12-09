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

@end
