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
@interface DZMainViewController () <DZShareInterface,DZActionDelegate>

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
    

	// Do any additional setup after loading the view.
}

- (void) viewWillLayoutSubviews
{
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
        [self presentViewController:navigationVC animated:YES completion:^{
            
        }];
    } else if (index == 2)
    {
        UINavigationController* navigationVC = [[UINavigationController alloc] initWithRootViewController:[DZSettingsViewController new]];
        [self presentViewController:navigationVC animated:YES completion:^{
            
        }];
    }
}


@end
