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
@synthesize maxHeight = _maxHeight;
@synthesize minHeight = _minHeight;
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
            NSLog(@"asdfasd");
        }
    }
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

@end
