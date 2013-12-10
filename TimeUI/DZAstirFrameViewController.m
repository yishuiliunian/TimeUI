//
//  DZAstirFrameViewController.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-9.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZAstirFrameViewController.h"
#import "DZKVODefines.h"
#import "DZAnimationState.h"
#import "UIView+FrameAnimation.h"
@interface DZAstirFrameViewController ()

@end

@implementation DZAstirFrameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _maxHeight = 400;
        _minHeight = 100;
    }
    return self;
}

- (void) viewDidLayoutSubviews
{
    
}
- (void) viewWillLayoutSubviews
{
    NSArray* subViews = [self.view subviews];
    for (UIView* eachView in subViews) {
        NSArray* states = eachView.states;
        if (states) {
            float totoal =  ABS(_maxHeight - _minHeight);
            float progress = 1;
            if (ABS(totoal) > 0.00001) {
                progress = CGRectGetHeight(self.view.frame) / totoal;
            }
            
            [eachView moveToIndex:(eachView.currentStateIndex + 1)%2 withProgress:progress];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView* a = [[UIView alloc] init];
    
    DZAnimationState* s1 = [[DZAnimationState alloc] initWithDic:@{kDZKeyAlpha:@(1),
                                                                   kDZKeyFrame:[NSValue valueWithCGRect:CGRectMake(40, 10, 10, 10)]}];
    
    DZAnimationState* s2 = [[DZAnimationState alloc] initWithDic:@{kDZKeyAlpha:@(.5),
                                                                   kDZKeyFrame:[NSValue valueWithCGRect:CGRectMake(90, 40, 70, 90)]}];
    
    a.states = @[s1, s2];
    [self.view addSubview:a];
    a.backgroundColor = [UIColor orangeColor];
    a.frame = s1.frame;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
