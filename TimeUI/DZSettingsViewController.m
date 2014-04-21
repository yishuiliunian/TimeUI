//
//  DZSettingsViewController.m
//  TimeUI
//
//  Created by stonedong on 14-3-29.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZSettingsViewController.h"
#import "DZEditServerHostViewController.h"
#import "DZAccountManager.h"
#import "DZ24Analysis.h"
DEFINE_NSStringValue(RowServerHost, 服务器地址);
@interface DZSettingsViewController ()

@end

@implementation DZSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadData
{
    
    
    QQSTSection* accountSection = [QQSTSection new];
    accountSection.title = @"账号";
    accountSection.footerTitle = @"注销账号后，将会使用默认账号来保存您的时间信息，并且不能够与服务器同步您的时间信息。";
    
    
    QQSTRow* logoutRow = [[QQSTRow alloc] initWithTarget:self action:@selector(logoutCurrentAccount)];
    logoutRow.title = @"注销";
    [accountSection addRow:logoutRow atIndex:0];
    
    
    QQSTSection* sectionDebug = [[QQSTSection alloc] init];
    sectionDebug.title = @"调试";
    sectionDebug.footerTitle = @"看到该设置，表示您现在使用的是开发或者测试版本，如果需要正式版本请从AppStore下载";
    
    QQSTRow* serverHost = [[QQSTRow alloc] initWithTarget:self action:@selector(changedServerHost)];
    serverHost.title = kDZRowServerHost;
    [sectionDebug addRow:serverHost atIndex:0];
    
    NSMutableArray* sectionDatas  = [NSMutableArray new];
#if DZDEBUG == 1
    [sectionDatas addObject:sectionDebug];
#endif
    if (DZActiveAccount.isLogin) {
        [sectionDatas addObject:accountSection];
    }
    _sectionData = sectionDatas;
}

- (void) changedServerHost
{
    [self.navigationController pushViewController:[DZEditServerHostViewController new] animated:YES];
}

- (void) logoutCurrentAccount
{
    DZActiveAccount.isLogin = NO;
    [self reloadAllData];
}

- (void) updateTableViewCell:(UITableViewCell *)cell forRowData:(QQSTRow *)row
{
    [super updateTableViewCell:cell forRowData:row];
    if ([row.title isEqual:kDZRowServerHost]) {
        cell.detailTextLabel.text = DZServerHost;
    } else if ([row.title isEqual:@"注销"])
    {
        cell.backgroundColor = [UIColor redColor];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = item;
    // Do any additional setup after loading the view.
    
    
    DZ24Analysis* ana = [DZ24Analysis new];
    [ana loadTypes:[DZActiveTimeDataBase allTimeTypes] times:[DZActiveTimeDataBase allTimes]];
}

- (void) dismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadAllData];
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
