//
//  UIViewController+PullDown.h
//  TimeUI
//
//  Created by stonedong on 14-3-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DZPullDownViewController;
@interface UIViewController (PullDown)
@property (nonatomic, strong) DZPullDownViewController* pdSuperViewController;
- (void) addLeftBackItem;
@end
