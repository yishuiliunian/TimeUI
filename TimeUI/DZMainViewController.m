//
//  DZMainViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZMainViewController.h"
#import "DZAccountManager.h"
#import "DZSeparationLine.h"
#import "DZGlobalActionView.h"
#import "DZNotificationCenter.h"
#import "DZShakeRecognizedWindow.h"
#import "DZSyncActionItemView.h"
#import "DZLabelActionItem.h"
#import "DZHistoryViewController.h"
#import "DZSettingsViewController.h"
#import "DZLoginViewController.h"
#import "DZRegisterViewController.h"
#import "UIViewController+PullDown.h"
#import "DZPullDownViewController.h"


#define DZMainStateMiddleOffset (CGRectGetViewControllerHeight/2)

#define DZMainStateTopOffSet 20

@interface DZMainViewController () <DZShareInterface,DZActionDelegate, UIGestureRecognizerDelegate, DZActionChangeAccountDelegate>

{
    UIPanGestureRecognizer* _panGestureRecognizer;
    CGPoint _lastPoint;
}
@end

@implementation DZMainViewController

- (void) dealloc
{
    [[DZNotificationCenter defaultCenter] removeObserver:self forMessage:DZShareNotificationMessage];
}
- (DZAccount*)account
{
    return DZActiveAccount;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _state = DZMainViewStateMidlle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[DZNotificationCenter defaultCenter] addObserver:self forKey:DZShareNotificationMessage];
    [_typesViewController willMoveToParentViewController:self];
    [self addChildViewController:_typesViewController];
    [self.view addSubview:_typesViewController.view];
    [_typesViewController didMoveToParentViewController:self];
    
    [_chartsViewController willMoveToParentViewController:self];
    [self addChildViewController:_chartsViewController];
    [self.view addSubview:_chartsViewController.view];
    [_chartsViewController didMoveToParentViewController:self];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestrueRecg:)];
    [_chartsViewController.timeControl.dragBackgroundImageView addGestureRecognizer:_panGestureRecognizer];
    _chartsViewController.timeControl.dragBackgroundImageView.userInteractionEnabled = YES;
    _panGestureRecognizer.minimumNumberOfTouches = 1;
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    
    _panGestureRecognizer.delegate = self;
	// Do any additional setup after loading the view.
}


- (CGRect) stateRecognizerArea:(DZMainViewState)state direction:(DZDirection)direction
{
    float perfectLine = CGRectGetViewControllerHeight / 2 * 0.618;
    float resideLine = CGRectGetViewControllerHeight / 2 - perfectLine;
    if (direction == DZDirectionDown) {
        if (state == DZMainViewStateTop) {
            return CGRectMake(0, -100, CGRectGetViewControllerWidth, resideLine);
        } else {
            return CGRectMake(0, resideLine, CGRectGetViewControllerWidth, CGRectGetViewControllerHeight);
        }
    } else if (direction == DZDirectionUp)
    {
        if (state == DZMainViewStateTop) {
            return CGRectMake(0, -100, CGRectGetViewControllerWidth, perfectLine);
        } else {
            return CGRectMake(0, perfectLine, CGRectGetViewControllerWidth, CGRectGetViewControllerHeight);
        }
    }
    return CGRectZero;
}
- (void) handlePanGestrueRecg:(UIPanGestureRecognizer*)swipRcg
{
    CGPoint point = [swipRcg locationInView:self.view];
    static DZDirection direction;
    if (swipRcg.state == UIGestureRecognizerStateBegan) {
        _lastPoint = point;
    }
    else if (swipRcg.state == UIGestureRecognizerStateChanged) {
        
        if(ABS(_lastPoint.y - point.y) > 7)
        {
            direction = DZDirectionVerticalityWithPoints(_lastPoint, point);
            _lastPoint = point;
        }
        [self layoutChildViewControllerOffSet:point.y Animation:YES];
    } else if (swipRcg.state == UIGestureRecognizerStateEnded) {

        if (direction == DZDirectionUp) {
            [self setState:DZMainViewStateTop animation:YES];
        } else
        {
            [self setState:DZMainViewStateMidlle animation:YES];

        }
        if (CGRectContainsPoint([self stateRecognizerArea:DZMainViewStateTop direction:direction], point)) {
        } else {
            
        }
    }
}
- (void) setState:(DZMainViewState)state animation:(BOOL)animation
{
    _state = state;
    float offset = DZMainStateMiddleOffset;
    if (state == DZMainViewStateTop) {
        offset = DZMainStateTopOffSet;
    }
    [self layoutChildViewControllerOffSet:offset Animation:animation];
}
- (void) layoutChildViewControllerOffSet:(float)offset Animation:(BOOL)animation
{
    CGRect rect = CGRectZero;
    rect.origin = CGPointMake(0, offset);
    rect.size.width = CGRectGetViewControllerWidth;
    rect.size.height = CGRectGetViewControllerHeight - offset;
    _chartsViewController.view.frame = rect;
    
    _typesViewController.view.frame = CGRectMake(0, 0, CGRectGetViewControllerWidth, CGRectGetViewControllerHeight - offset);
}

- (void) viewWillLayoutSubviews
{

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _typesViewController.view.frame = CGRectMake(0, 0, CGRectVCWidth, 230);
    _chartsViewController.view.frame = CGRectMake(0, CGRectGetMaxY(_typesViewController.view.frame), CGRectVCWidth, CGRectVCHeight - CGRectGetHeight(_typesViewController.view.frame));

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didGetShareMessage
{
    DZGlobalActionView* actionView = [[DZGlobalActionView alloc] init];
    actionView.delegate = self;
    DZSyncActionItemView* syncItem = [[DZSyncActionItemView alloc] init];
    syncItem.height = 40;
    syncItem.accountDelegate = self;
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
    
    cancelItem.textLabel.textAlignment = NSTextAlignmentRight;
    [actionView.actionContentView setItems:@[syncItem, historyItem, settingItem,cancelItem]];
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
        
        [self.pdSuperViewController  pdPresentViewController:navigationVC animated:YES completion:^{
            
        }];
        return;
      
        
        [self presentViewController:navigationVC animated:YES completion:^{
           
        }];
    } else if (index == 2)
    {
        UINavigationController* navigationVC = [[UINavigationController alloc] initWithRootViewController:[DZSettingsViewController new]];
        [self presentViewController:navigationVC animated:YES completion:^{
            
        }];
    }
}

- (void) syncActionItemViewLoginAccount:(DZSyncActionItemView *)itemView
{
    DZActionView* actionView = itemView.dzActionView;
    [actionView hideWithAnimation:YES];
    
    DZLoginViewController * loginVC = [[DZLoginViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES completion:^{
        
    }];
}

- (void) syncActionItemViewRigsterAccount:(DZSyncActionItemView *)itemView
{
    DZActionView* actionView = itemView.dzActionView;
    [actionView hideWithAnimation:YES];
    DZRegisterViewController* registerVC = [[DZRegisterViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:registerVC] animated:YES completion:^{
        
    }];
}

@end
