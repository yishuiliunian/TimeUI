//
//  DZPageScrollViewController.m
//  QQPicShow
//
//  Created by Stone Dong on 13-10-17.
//  Copyright (c) 2013年 Tencent SNS Terminal Develope Center. All rights reserved.
//

#import "DZPageScrollViewController.h"
#import "DZGeometryTools.h"
@interface DZPageScrollViewController ()
{
    BOOL _isFirstAppear;
}
@end

@implementation DZPageScrollViewController
@synthesize initIndex = _initIndex;
@synthesize pageScrollView = _pageScrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isFirstAppear = YES;
        _initIndex = NSNotFound;
    }
    return self;
}

- (DZPageScrollView*) pageScrollView
{
    if (!_pageScrollView) {
        _pageScrollView = [[DZPageScrollView alloc] init];
        _pageScrollView.pageDelegate = self;
        _pageScrollView.pageActionDelegate = self;
    }
    return _pageScrollView;
}

- (void) loadView
{
    if (!_pageScrollView) {
        _pageScrollView = [[DZPageScrollView alloc] init];
        _pageScrollView.pageDelegate = self;
        _pageScrollView.pageActionDelegate = self;
    }
    self.view = _pageScrollView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isFirstAppear) {
        [_pageScrollView reloadData];
        if (_initIndex != NSNotFound) {
            [_pageScrollView scrollToPageAtIndex:_initIndex withAnimation:NO];
        } 
        _isFirstAppear = NO;
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_pageScrollView setNeedsLayout];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
