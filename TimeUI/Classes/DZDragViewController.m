//
//  DZDragViewController.m
//  TimeUI
//
//  Created by Stone Dong on 13-11-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZDragViewController.h"
#import "DZAstirFrameViewController.h"
@interface DZDragViewController ()
{
    float _dragBottomViewYoffSet;
    float _dragTopViewYoffSet;
    
    UIPanGestureRecognizer* _bottomPanGestrueRecognizer;
}
@end

@implementation DZDragViewController
@synthesize topViewController = _topViewController;
@synthesize bottomViewController = _bottomViewController;
@synthesize centerViewController = _centerViewController;

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
    CALayer* layer = _topViewController.view.layer;
    layer.shadowColor = [UIColor lightGrayColor].CGColor;
    layer.shadowOffset = CGSizeMake(5, 5);
    layer.shadowOpacity = 0.4;
    layer.shadowRadius = 5;

}

- (void) setBottomViewController:(UIViewController *)bottomViewController
{
    if (_bottomViewController) {
        [self removeDragChildViewController:_bottomViewController];
        [_bottomViewController.view removeGestureRecognizer:_bottomPanGestrueRecognizer];
    }
    _bottomViewController = bottomViewController;
    if (bottomViewController) {
        [self addDragChildViewController:bottomViewController];
        if (!_bottomPanGestrueRecognizer) {
            _bottomPanGestrueRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleBottomPanGestrueRecognizer:)];
        }
        [bottomViewController.view addGestureRecognizer:_bottomPanGestrueRecognizer];
    }
    
    CALayer* layer = _bottomViewController.view.layer;
    layer.shadowColor = [UIColor lightGrayColor].CGColor;
    layer.shadowOffset = CGSizeMake(-5, -5);
    layer.shadowOpacity = 0.4;
    layer.shadowRadius = 5;
}


- (void) handleBottomPanGestrueRecognizer:(UIPanGestureRecognizer*)panRcg
{
    if (panRcg.state == UIGestureRecognizerStateChanged) {
        CGPoint ponit = [panRcg locationInView:self.view];
        [self setOffsetsWithBottonViewYoffSet:ponit.y];
        [self layoutChildViewControllers];
        NSLog(@"%f %f",ponit.x, ponit.y);
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
    }
    return self;
}
- (void) layoutChildViewControllers
{
    static int i = 0;
    [self.view insertSubview:_centerViewController.view belowSubview:_bottomViewController.view];
    [self.view insertSubview:_centerViewController.view belowSubview:_topViewController.view];
    [self.view insertSubview:_bottomViewController.view belowSubview:_topViewController.view];
    [self setOffsetsWithBottonViewYoffSet:_dragBottomViewYoffSet];
    _centerViewController.view.frame = self.view.bounds;
    
    _bottomViewController.view.frame = CGRectMake(0, _dragBottomViewYoffSet, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- i++);
    _topViewController.view.frame = CGRectMake(0, _dragTopViewYoffSet, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- i++);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutChildViewControllers];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
