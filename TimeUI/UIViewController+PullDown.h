//
//  UIViewController+PullDown.h
//  TimeUI
//
//  Created by stonedong on 14-2-22.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DZTopViewControllerStatueFullScreen,
    DZTopViewControllerStatueBottomToggled,
    DZTopViewControllerStatueMoving
    
}DZTopViewControllerStatues;

typedef enum {
    DZBookDirectionNone,
    DZBookDirectionLeft,
    DZBookDirectionRight,
    DZBookDirectionTop,
    DZBookDirectionDown
    
} DZBookDirection;





@interface UIViewController (PullDown)
DEFINE_PROPERTY_ASSIGN(CGPoint, pullDownBeginPoint);
DEFINE_PROPERTY_STRONG(UIPanGestureRecognizer*, pullDownPanGestureRecognizer);
DEFINE_PROPERTY_ASSIGN(DZTopViewControllerStatues, pullDownState);

- (void) trigglePullDown;
@end
