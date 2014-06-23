//
//  UIViewController+PullDown.m
//  TimeUI
//
//  Created by stonedong on 14-3-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "UIViewController+PullDown.h"
#import "DZPullDownViewController.h"
#import <objc/runtime.h>
static void const * kPullDonwViewController = &kPullDonwViewController;
@implementation UIViewController (PullDown)

- (void) setPdSuperViewController:(DZPullDownViewController *)pdSuperViewController
{
    objc_setAssociatedObject(self, kPullDonwViewController, pdSuperViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DZPullDownViewController*) __pdSuperViewController
{
    return objc_getAssociatedObject(self, kPullDonwViewController);
}


-(DZPullDownViewController*) pdSuperViewController
{
    DZPullDownViewController* pd = [self __pdSuperViewController];
    if (pd != nil) {
        return pd;
    }
    if ([self isKindOfClass:[DZPullDownViewController class]]) {
        return (DZPullDownViewController*)self;
    }
    if (self.parentViewController) {
        return [self.parentViewController pdSuperViewController];
    }
    return nil;
}

@end
