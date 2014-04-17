//
//  DZPullDownViewController.m
//  TimeUI
//
//  Created by stonedong on 14-3-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZPullDownViewController.h"

//

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



@interface DZPullDownViewController () <UIGestureRecognizerDelegate>
{
    NSMutableArray* _pdChildViewControllers;
    DZBookMove _moveData;
}
DEFINE_PROPERTY_ASSIGN(DZTopViewControllerStatues, pullDownState);

@end

@implementation DZPullDownViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _pdChildViewControllers = [NSMutableArray new];
        
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformPanGestureRecoginzer:)];
        pan.delegate = self;
        [self.view addGestureRecognizer:pan];
    }
    return self;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pdPresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [viewControllerToPresent willMoveToParentViewController:self];
    [self addChildViewController:viewControllerToPresent];
    [self.view addSubview:viewControllerToPresent.view];
    [viewControllerToPresent didMoveToParentViewController:self];
    viewControllerToPresent.view.frame = CGRectOffset(self.view.bounds, 0, CGRectGetHeight(self.view.frame));
    
    [_pdChildViewControllers addObject:viewControllerToPresent];
    [UIView animateWithDuration:0.25 animations:^{
        viewControllerToPresent.view.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) pdPopViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    UIViewController* viewController = [_pdChildViewControllers lastObject];
    if (!viewController) {
        return;
    }
    [viewController willMoveToParentViewController:Nil];
    
    void (^FinishBlock)() = ^{
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
        [viewController didMoveToParentViewController:nil];
        [_pdChildViewControllers removeLastObject];
        if (completion) {
            completion();
        }
    };
    
    [UIView animateWithDuration:0.25 animations:^{
           viewController.view.frame = CGRectOffset(self.view.bounds, 0, CGRectGetHeight(self.view.frame));
    } completion:^(BOOL finished) {
        FinishBlock();
    }];
}

- (void) setTopViewControllerYCoordiate:(float)y
{
    UIViewController* viewController = [_pdChildViewControllers lastObject];
    viewController.view.frame = CGRectSetY(viewController.view.frame, y);
}

- (void) didPerformPanGestureRecoginzer:(UIGestureRecognizer*)recognizer
{
    //
    CGPoint location = [recognizer locationInView:self.view];
    //
    UIViewController* _topVC = [_pdChildViewControllers lastObject];
    if ([_topVC isKindOfClass:[UINavigationController class]]) {
        _topVC = [(UINavigationController*)_topVC topViewController];
    }
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
                if (contentOffSetY > 0) {
                    return;
                }
            }
            //
        }
        _moveData.setEndPoint(location);
        float moveStep = _moveData.moveStepDistance();
        
        if (CGRectGetMinY(self.view.frame) + moveStep <= 0) {
            return;
        }
         UIViewController* viewController = [_pdChildViewControllers lastObject];
        [self setTopViewControllerYCoordiate:CGRectGetMinY(viewController.view.frame) + moveStep];
        self.pullDownState = DZTopViewControllerStatueMoving;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        _moveData.setEndPoint(location);
         UIViewController* viewController = [_pdChildViewControllers lastObject];
        
        float distance = CGRectGetMinY(viewController.view.frame);
        if (distance < CGRectGetHeight(self.view.bounds) * 0.318) {
            [UIView animateWithDuration:0.25 animations:^{
                [self setTopViewControllerYCoordiate:0];
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [self pdPopViewControllerAnimated:YES completion:^{
                
            }];
        }
        _moveData.clearData();
    }
    
}

@end
