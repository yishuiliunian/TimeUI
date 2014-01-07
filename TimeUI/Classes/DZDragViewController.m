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
#import "DZNotificationCenter.h"
#import "DZShakeRecognizedWindow.h"
#import "DZGlobalActionView.h"
#import "DZSyncActionItemView.h"
#import "DZLabelActionItem.h"
#import "DZHistoryViewController.h"
#import "DZSettingsViewController.h"
#import "DZLoginViewController.h"
#import "DZRegisterViewController.h"

@interface DZDragViewController () <DZShareInterface, DZActionDelegate>
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

- (void) setTopViewController:(DZTypesViewController *)topViewController
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

- (void) setBottomViewController:(DZChartViewController *)bottomViewController
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

- (void) didGetShareMessage
{
    DZGlobalActionView* actionView = [[DZGlobalActionView alloc] init];
    actionView.delegate = self;
    DZSyncActionItemView* syncItem = [[DZSyncActionItemView alloc] init];
    syncItem.height = 40;
    syncItem.backgroundColor = [UIColor redColor];
    
    
    DZLabelActionItem* historyItem = [[DZLabelActionItem alloc] init];
    historyItem.textLabel.text = @"历史记录";
    historyItem.height = 70;
    
    DZLabelActionItem* settingItem = [[DZLabelActionItem alloc] init];
    settingItem.textLabel.text = @"设置";
    settingItem.height = 70;
    
    DZLabelActionItem* cancelItem = [[DZLabelActionItem alloc] init];
    cancelItem.textLabel.text = @"取消";
    cancelItem.height = 70;
    
    DZLabelActionItem* loginItem = [[DZLabelActionItem alloc] init];
    loginItem.textLabel.text = @"登陆";
    loginItem.height = 70;
    
    DZLabelActionItem* registerItem = [[DZLabelActionItem alloc] init];
    registerItem.textLabel.text = @"注册";
    registerItem.height = 70;
    
    cancelItem.textLabel.textAlignment = NSTextAlignmentRight;
    [actionView.actionContentView setItems:@[syncItem, historyItem, settingItem, loginItem , registerItem,cancelItem]];
    [actionView showWithAnimation:YES];
}

- (BOOL) actionView:(DZActionView *)actionView shouldHideTapAtIndex:(NSInteger)index item:(DZActionItemView *)item
{
    if (index == 0) {
        return NO;
    }
    return YES;
}

- (void) actionView:(DZActionView *)actionView didHideWithTapAtIndex:(NSInteger)index item:(DZActionItemView *)item
{
    if (index == 1) {
        UINavigationController* navigationVC = [[UINavigationController alloc] initWithRootViewController:[DZHistoryViewController new]];
        [self presentViewController:navigationVC animated:YES completion:^{
            
        }];
    } else if (index == 2)
    {
        UINavigationController* navigationVC = [[UINavigationController alloc] initWithRootViewController:[DZSettingsViewController new]];
        [self presentViewController:navigationVC animated:YES completion:^{
            
        }];
    } else if (index == 3) {
        UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:[DZLoginViewController new]];
        __unused id a = navVC.view;
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
    } else if (index == 4)
    {
        UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:[DZRegisterViewController new]];
        __unused id a = navVC.view;
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[DZNotificationCenter defaultCenter] addObserver:self forKey:DZShareNotificationMessage];
	// Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DZThemeLoadCSS;
    [self setDragState:DZDragViewStateCenter withAnimation:NO];
    
}

- (void) loadViewCSS:(id)cssValue forKey:(NSString *)key
{
    
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
