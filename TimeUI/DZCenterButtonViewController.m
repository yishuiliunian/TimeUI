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
#import <TTCounterLabel.h>
@interface DZCenterButtonViewController ()
{
    UIButton* _centerButton;
    TTCounterLabel* _countLabel;
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
    NSArray* types = [DZActiveTimeDataBase allTimeTypes];
    [[DZTimeTrickManger shareManager]  addTimeLogWithType:types.lastObject detail:@""];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_centerButton setTitle:@"asdfa" forState:UIControlStateNormal];
    [_centerButton addTarget:self action:@selector(addTime) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_centerButton];
    _centerButton.backgroundColor = [UIColor redColor];
    
    
    
    DZAnimationState* s1 = [[DZAnimationState alloc] initWithDic:@{kDZKeyAlpha:@(1),
                                                                   kDZKeyFrame:[NSValue valueWithCGRect:CGRectMake(40, 40, 100, 100)]}];
    
    DZAnimationState* s2 = [[DZAnimationState alloc] initWithDic:@{kDZKeyAlpha:@(.5),
                                                                   kDZKeyFrame:[NSValue valueWithCGRect:CGRectMake(240, 40, 50, 50)]}];
    
    _centerButton.states = @[s1, s2];
    _centerButton.frame = s1.frame;
    
    _countLabel = [[TTCounterLabel alloc] init];
    _countLabel.states = @[DZAnimatinStateCreateWithDic(@{kDZKeyAlpha:@(1),
                                                          kDZKeyFrame:[NSValue valueWithCGRect:CGRectMake(10, 10, 100, 100)]}),
                           DZAnimatinStateCreateWithDic(@{kDZKeyAlpha:@(1),
                                                          kDZKeyFrame:[NSValue valueWithCGRect:CGRectMake(200, 40, 100, 100)]}),];
    _countLabel.frame = [_countLabel.states[0] frame];
    [self.view addSubview:_countLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillLayoutSubviews
{
  float process =   CGRectGetMinY(self.view.frame) / CGRectGetHeight(self.view.superview.frame);
    [_centerButton moveToIndex:(_centerButton.currentStateIndex + 1)%2 withProgress:process];
    [_countLabel moveToIndex:(_countLabel.currentStateIndex + 1)%2 withProgress:process];
}

@end
