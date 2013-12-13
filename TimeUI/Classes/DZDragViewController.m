//
//  DZDragViewController.m
//  TimeUI
//
//  Created by Stone Dong on 13-11-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZDragViewController.h"
#import "DZAstirFrameViewController.h"
#import "UIView+FrameAnimation.h"
#import "DZAnimationState.h"

#import "DZTimeTrickManger.h"
@interface DZDragViewController ()
{
    float _dragBottomViewYoffSet;
    float _dragTopViewYoffSet;
    
    UIPanGestureRecognizer* _bottomPanGestrueRecognizer;
    UIView* animationView;
}

@end

@implementation DZDragViewController
@synthesize topViewController = _topViewController;
@synthesize bottomViewController = _bottomViewController;
@synthesize centerViewController = _centerViewController;
@synthesize dragState = _dragState;

- (void) addDragChildViewController:(UIViewController*)vc
{
    [vc willMoveToParentViewController:self];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

- (void) removeDragChildViewController:(UIViewController*)vc
{
    [vc willMoveToParentViewController:Nil];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
    [vc didMoveToParentViewController:nil];
}

- (void) setTopViewController:(UIViewController *)topViewController
{
    if (_topViewController) {
        [self removeDragChildViewController:_topViewController];
    }
    _topViewController = topViewController;
    if (topViewController) {
        [self addDragChildViewController:topViewController];
    }
    [_topViewController.view addShadow];
}

- (void) setBottomViewController:(UIViewController *)bottomViewController
{
    if (_bottomViewController) {
        [self removeDragChildViewController:_bottomViewController];
        [_bottomViewController.view removeGestureRecognizer:_bottomPanGestrueRecognizer];
    }
    _bottomViewController = bottomViewController;
    [_bottomViewController.view addShadow];
}

- (void) setDragState:(DZDragViewState)dragState withAnimation:(BOOL)animation
{
    _dragState = dragState;
    switch (dragState) {
        case DZDragViewStateTop:
            _dragBottomViewYoffSet = _middleHeight;
            break;
        case DZDragViewStateBottom:
            _dragBottomViewYoffSet = CGRectGetHeight(self.view.bounds);
            break;
        case DZDragViewStateCenter:
            _dragBottomViewYoffSet = (CGRectGetHeight(self.view.frame) + _middleHeight)/2 ;
        default:
            break;
    }
    [self layoutChildViewControllersWithAnimation:animation];
}
- (void) handleBottomPanGestrueRecognizer:(UIPanGestureRecognizer*)panRcg
{
    CGPoint ponit = [panRcg locationInView:self.view];
    if (panRcg.state == UIGestureRecognizerStateChanged) {
        [self setOffsetsWithBottonViewYoffSet:ponit.y];
        [self layoutChildViewControllersWithAnimation:NO];
    }
    else if (panRcg.state == UIGestureRecognizerStateEnded)
    {
        float middleLine = CGRectGetHeight(self.view.frame) /2;
        if (ponit.y < middleLine - _middleHeight) {
            [self setDragState:DZDragViewStateTop withAnimation:YES];
        }
        else if (ponit.y > middleLine + _middleHeight)
        {
            [self setDragState:DZDragViewStateBottom withAnimation:YES];
        }
        else
        {
            [self setDragState:DZDragViewStateCenter withAnimation:YES];
        }
        
    }
}
- (void) setCenterViewController:(UIViewController *)centerViewController
{
    if (_centerViewController) {
        [self removeDragChildViewController:_centerViewController];
    }
    _centerViewController = centerViewController;
    if (centerViewController) {
        [self addDragChildViewController:centerViewController];
    }
    if (_centerViewController) {
        if (!_bottomPanGestrueRecognizer) {
            _bottomPanGestrueRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleBottomPanGestrueRecognizer:)];
        }
        [_centerViewController.view addGestureRecognizer:_bottomPanGestrueRecognizer];
    }
}

- (void) setOffsetsWithBottonViewYoffSet:(float)offset
{
    _dragBottomViewYoffSet = offset;
    _dragTopViewYoffSet = _dragBottomViewYoffSet - 200 - CGRectGetHeight(self.view.frame);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dragBottomViewYoffSet = 300;
        _dragTopViewYoffSet = 100;
        _middleHeight = 100;
    }
    return self;
}
- (void) layoutChildViewControllersWithAnimation:(BOOL)animation
{
    [self.view insertSubview:_centerViewController.view belowSubview:_bottomViewController.view];
    [self.view insertSubview:_centerViewController.view belowSubview:_topViewController.view];
    [self.view insertSubview:_bottomViewController.view belowSubview:_topViewController.view];
    [self setOffsetsWithBottonViewYoffSet:_dragBottomViewYoffSet];
    void(^animationBlock)(void) = ^(void) {
        _bottomViewController.view.frame = CGRectMake(0,
                                                      _dragBottomViewYoffSet,
                                                      CGRectGetWidth(self.view.frame),
                                                      CGRectGetHeight(self.view.frame) - _dragBottomViewYoffSet);
        
        _topViewController.view.frame = CGRectMake(0, 0,
                                                   CGRectGetWidth(self.view.frame),
                                                   _dragBottomViewYoffSet - _middleHeight);
        
        _centerViewController.view.frame = CGRectMake(0, CGRectGetMaxY(_topViewController.view.frame), CGRectGetWidth(self.view.frame), _middleHeight);
    };
    
    if (animation) {
        [UIView animateWithDuration:0.25 animations:animationBlock];
    }
    else
    {
        animationBlock();
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setDragState:DZDragViewStateCenter withAnimation:NO];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) typesViewController:(DZTypesViewController *)vc didSelect:(DZTimeType *)type
{
    [_bottomViewController showLineChartForType:type];
    [[DZTimeTrickManger shareManager] setTimeType:type];
}
@end
