//
//  DZCenterButtonViewController.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZCenterButtonViewController.h"
#import "DZDBManager.h"
#import "DZTimeTrickManger.h"
#import "DZAnimationState.h"
#import "UIView+FrameAnimation.h"
#import "MZLoadingCircle.h"
#import <TTCounterLabel.h>
#import <KXKiOS7Colors.h>
#import "DZAudioManager.h"
@interface DZCenterButtonViewController ()
{
    UIButton* _centerButton;
    TTCounterLabel* _countLabel;
    MZLoadingCircle* _loadingCircle;
}
@end

@implementation DZCenterButtonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _minHeight = 100;
        _maxHeight = 200;
    }
    return self;
}

- (void) addTime
{
    [[DZTimeTrickManger shareManager] addTimeWithDetail:@""];
    [_countLabel reset];
    _countLabel.startValue = 0;
    [_countLabel start];
    
    [[DZAudioManager  shareManager] playBlum];
}


- (void) initLoadingCircle
{
//    _loadingCircle = [[MZLoadingCircle alloc] init];
//    [_loadingCircle willMoveToParentViewController:self];
//    [self.view addSubview:_loadingCircle.view];
//    [_loadingCircle didMoveToParentViewController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [KXKiOS7Colors lightOrange];
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_centerButton setTitle:@"点击以保存" forState:UIControlStateNormal];
    [_centerButton addTarget:self action:@selector(addTime) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_centerButton];
    
    
    
    DZAnimationState* s1 = [[DZAnimationState alloc] initWithDic:@{kDZKeyAlpha:@(1),
                                                                   kDZKeyFrame:[NSValue valueWithCGRect:CGRectMake(200, 0, 100, 100)]}];
    
    DZAnimationState* s2 = [[DZAnimationState alloc] initWithDic:@{kDZKeyAlpha:@(.5),
                                                                   kDZKeyFrame:[NSValue valueWithCGRect:CGRectMake(200, 0, 100, 100)]}];
    
    _centerButton.states = @[s1, s2];
    _centerButton.frame = s1.frame;
    
    _countLabel = [[TTCounterLabel alloc] init];
    _countLabel.states = @[DZAnimatinStateCreateWithDic(@{kDZKeyAlpha:@(1),
                                                          kDZKeyFrame:[NSValue valueWithCGRect:CGRectMake(10, 0, 200, 100)]}),
                           DZAnimatinStateCreateWithDic(@{kDZKeyAlpha:@(1),
                                                          kDZKeyFrame:[NSValue valueWithCGRect:CGRectMake(10, 0, 200, 100)]}),];
    
    _countLabel.startValue = [DZTimeTrickManger shareManager].alreadyCostTime*1000;
    [self.view addSubview:_countLabel];
    [self initLoadingCircle];
    _loadingCircle.view.frame = CGRectMake(200, 0, 60, 60);
    [_countLabel start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillLayoutSubviews
{
    _countLabel.frame = [_countLabel.states[0] frame];

}

@end
