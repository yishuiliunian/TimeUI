//
//  DZShakeRecognizedWindow.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-19.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZShakeRecognizedWindow.h"
#import "DZNotificationCenter.h"
#import "DZPageScrollView.h"
#import "DZTeachViewController.h"


@interface DZShakeRecognizedWindow () <DZPageScrollViewDelegate>
@property (nonatomic, strong) DZTeachViewController* techViewController;
@end
@implementation DZShakeRecognizedWindow


- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self commitInit];
    
    return self;
}
- (void) commitInit
{
    
}
- (BOOL) isShowGuidView
{
    return _techViewController ? YES : NO;
}
- (void) triggleTeachGuideView
{
    if (self.isShowGuidView) {
        return;
    }
    _techViewController = [[DZTeachViewController alloc] init];
    [self addSubview:_techViewController.view];
    _techViewController.view.backgroundColor = [UIColor redColor];
    [self setNeedsLayout];
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event {
	if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        [[DZNotificationCenter defaultCenter] postMessage:DZShareNotificationMessage userInfo:nil];
	}
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    if (_techViewController) {
        _techViewController.view.frame = CGRectMake(100, 100, 120, 120);
        [self bringSubviewToFront:_techViewController.view];
        [_techViewController.pageScrollView setNeedsLayout];
    }
}


@end
