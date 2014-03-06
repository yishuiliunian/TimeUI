//
//  UIViewController+PullDown.m
//  TimeUI
//
//  Created by stonedong on 14-2-22.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "UIViewController+PullDown.h"
#import <objc/runtime.h>
typedef struct {
private: DZBookDirection _lastDirection;
    
public:    CGPoint beginPoint;
    CGPoint endPoint;
    BOOL isMoving;
    CGPoint lastPoint;
    BOOL didTapedNavigationBar;
    
    void setEndPoint(CGPoint point)
    {
        _lastDirection = moveDirection();
        if(CGPointEqualToPoint(endPoint, CGPointZero))
        {
            lastPoint = point;
        }
        else
        {
            lastPoint = endPoint;
        }
        endPoint = point;
        DZBookDirection nDirection = moveDirection();
        if(_lastDirection != DZBookDirectionNone && _lastDirection != nDirection)
        {
            beginPoint = point;
        }
    }
    
    float moveDistance()
    {
        return ABS(beginPoint.y - endPoint.y);
    }
    
    float moveStepDistance()
    {
        return  endPoint.y - lastPoint.y;
    }
    
    DZBookDirection moveDirection()
    {
        DZBookDirection direction;
        if(CGPointEqualToPoint(beginPoint, endPoint))
        {
            direction = _lastDirection;
        }
        if(beginPoint.y > endPoint.y)
        {
            direction = DZBookDirectionTop;
        }
        else
        {
            direction = DZBookDirectionDown;
        }
        
        return direction;
    }
    
    void clearData()
    {
        beginPoint = CGPointZero;
        endPoint = CGPointZero;
        isMoving = NO;
        _lastDirection = DZBookDirectionNone;
    }
}DZBookMove;


@protocol DZTopViewControllderProtocol <NSObject>
- (UIViewController*)_dztopViewController;
@end

@interface UIViewController (_pan_innder) <DZTopViewControllderProtocol>
@end

@implementation UIViewController (_pan_innder)

- (UIViewController*) _dztopViewController
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        
        return [[(UINavigationController*)self topViewController] _dztopViewController];
    }
    if ([self isKindOfClass:[UITabBarController class]]) {
        return  [[(UITabBarController*)self selectedViewController] _dztopViewController];
    }
    return self;
}

@end

DEFINE_PROPERTY_KEY(PullDownBeginPoint);
DEFINE_PROPERTY_KEY(PullDownPanGestrueRecognizer);
DEFINE_PROPERTY_KEY(PullDownState);
@implementation UIViewController (PullDown)

- (void) setPullDownState:(DZTopViewControllerStatues)pullDownState
{
    objc_setAssociatedObject(self,
                             kPKPullDownState,
                             @(pullDownState),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DZTopViewControllerStatues) pullDownState
{
    return (DZTopViewControllerStatues)[objc_getAssociatedObject(self, kPKPullDownState) intValue];
}

- (CGPoint) pullDownBeginPoint
{
    return [objc_getAssociatedObject(self, kPKPullDownBeginPoint) CGPointValue];
}

- (void) setPullDownBeginPoint:(CGPoint)pullDownBeginPoint
{
    objc_setAssociatedObject(self,
                             kPKPullDownBeginPoint,
                             [NSValue valueWithCGPoint:pullDownBeginPoint],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPanGestureRecognizer*) pullDownPanGestureRecognizer
{
    return objc_getAssociatedObject(self, kPKPullDownPanGestrueRecognizer);
}

- (void) setPullDownPanGestureRecognizer:(UIPanGestureRecognizer *)pullDownPanGestureRecognizer
{
    objc_setAssociatedObject(self,
                             kPKPullDownPanGestrueRecognizer,
                             pullDownPanGestureRecognizer,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) trigglePullDown
{
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformPanGestureRecoginzer:)];
    [self.view addGestureRecognizer:pan];
    self.pullDownPanGestureRecognizer = pan;
}


- (void) setTopViewControllerYCoordiate:(float)y
{
    self.view.frame = CGRectSetY(self.pullDownPanGestureRecognizer.view.frame, y);
}
- (void) didPerformPanGestureRecoginzer:(UIGestureRecognizer*)recognizer
{
    //
    CGPoint location = [recognizer locationInView:self.view];
    //
    DZBookMove _moveData;
    _moveData.beginPoint = self.pullDownBeginPoint;
    UIViewController* _topVC = [self _dztopViewController];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _moveData.beginPoint = location;
        if (_topVC.navigationController) {
            UINavigationController* nav = _topVC.navigationController;
            CGPoint poinInNav = [recognizer locationInView:nav.navigationBar];
            CGRect navFrame = nav.navigationBar.frame;
            if (CGRectContainsPoint(navFrame, poinInNav)) {
                _moveData.didTapedNavigationBar = YES;
            }
            else
            {
                _moveData.didTapedNavigationBar = NO;
            }
                    }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        if (!_moveData.didTapedNavigationBar) {
            UIView* topView = _topVC.view;
            if (![topView isKindOfClass:[UIScrollView class]]) {
                NSArray* subViews = topView.subviews;
                for (UIView* each  in subViews) {
                    if ([each isKindOfClass:[UIScrollView class]]) {
                        topView = each;
                        break;
                    }
                }
            }
            //
            if ([topView isKindOfClass:[UIScrollView class]]) {
                UIScrollView* scrollView = (UIScrollView*)topView;
                float contentOffSetY = scrollView.contentOffset.y + scrollView.contentInset.top;
                if (self.pullDownState == DZTopViewControllerStatueFullScreen) {
                    if (contentOffSetY > 0) {
                        return;
                    }
                }
                else if (self.pullDownState == DZTopViewControllerStatueMoving)
                {
                    if ([topView.superview isKindOfClass:[UIWebView class]]) {
                        if (contentOffSetY < -5) {
                            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top - 5);
                        }
                    }
                    else
                    {
                        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top);
                    }
                    
                }
            }
            //
        }
        if(self.pullDownState == DZTopViewControllerStatueBottomToggled || self.pullDownState == DZTopViewControllerStatueFullScreen)
        {
            if (CGPointEqualToPoint(_moveData.beginPoint, CGPointZero)) {
                _moveData.beginPoint = location;
            }
        }
        _moveData.setEndPoint(location);
        float moveStep = _moveData.moveStepDistance();
        if (CGRectGetMinY(self.view.frame) + moveStep <= 0) {
            return;
        }
        [UIView animateWithDuration:0.25 animations:^{
            [self setTopViewControllerYCoordiate:CGRectGetMinY(self.view.frame) + moveStep];
        }];
        self.pullDownState = DZTopViewControllerStatueMoving;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        _moveData.setEndPoint(location);
//        if (_moveData.moveDirection() == DZBookDirectionTop) {
//            if(CGRectGetMinY(self.view.frame) > KDZPullDownToggledBottomOffSetTop )
//            {
//                [self setTopViewControllerStatue:DZTopViewControllerStatueBottomToggled animation:YES];
//            }
//            else
//            {
//                [self setTopViewControllerStatue:DZTopViewControllerStatueFullScreen animation:YES];
//            }
//            
//        }
//        else
//        {
//            if(CGRectGetMinY(self.topViewController.view.frame) < kDZPullUpToggledUpOffSetTop )
//            {
//                [self setTopViewControllerStatue:DZTopViewControllerStatueFullScreen animation:YES];
//            }
//            else
//            {
//                [self setTopViewControllerStatue:DZTopViewControllerStatueBottomToggled animation:YES];
//            }
//        }
        ///
        //
        _moveData.clearData();
        
    }
    
    CGRectGetMaxX(<#CGRect rect#>)
}



@end
