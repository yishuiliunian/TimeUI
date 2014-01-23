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
@interface DZMainViewController ()

@end

@implementation DZMainViewController

- (DZAccount*)account
{
    return DZActiveAccount;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_typesViewController willMoveToParentViewController:self];
    [self addChildViewController:_typesViewController];
    [self.view addSubview:_typesViewController.view];
    [_typesViewController didMoveToParentViewController:self];
    
    [_chartsViewController willMoveToParentViewController:self];
    [self addChildViewController:_chartsViewController];
    [self.view addSubview:_chartsViewController.view];
    [_chartsViewController didMoveToParentViewController:self];
    

	// Do any additional setup after loading the view.
}

- (void) viewWillLayoutSubviews
{
    _typesViewController.view.frame = CGRectMake(0, 0, CGRectVCWidth, 150);
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

@end
