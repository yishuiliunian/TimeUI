//
//  DZPullDownViewController.h
//  TimeUI
//
//  Created by stonedong on 14-3-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+PullDown.h"
@interface DZPullDownViewController : UINavigationController
- (void) pdPresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
- (void) pdPopViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
@end
