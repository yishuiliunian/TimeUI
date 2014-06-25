//
//  DZCheckTypeViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-2-15.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZCheckTypeViewController.h"
#import "DZSelecteTypeInterface.h"
#import "DZTimeTrickManger.h"
#import "DZMChangedAccountNI.h"
#import "DZUserDataManager.h"
#import "DZTimeType.h"
#import "DZChangedTypesNI.h"

DEFINE_NSString(active_type);
@interface DZCheckTypeViewController () <DZMChangedAccountNI, DZChangedTypesNI>

@end

@implementation DZCheckTypeViewController

- (void) dealloc
{
    [DZDefaultNotificationCenter removeObserver:self forMessage:kDZNotification_changed_account];
    [DZDefaultNotificationCenter removeObserver:self forMessage:kDZNotification_TypesChanged];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [DZDefaultNotificationCenter addObserver:self forKey:kDZNotification_changed_account];
        [DZDefaultNotificationCenter addObserver:self forKey:kDZNotification_TypesChanged];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.tableView.selectedIndex < _timeTypes.count) {
        [self.tableView manuSelectedRowAt:self.tableView.selectedIndex];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didChangedAccount:(DZAccount *)oldAccount toAccount:(DZAccount *)otherAccount
{
    [self reloadAllData];
}

- (void) reloadAllData
{
    [super reloadAllData];
    if (_timeTypes.count > 0) {
        NSString* typeGuid = [[DZUserDataManager shareManager] activeUserDataForKey:kDZactive_type];
        NSInteger index = 0;
        for (int i = 0; i < _timeTypes.count; i++) {
            DZTimeType* type = _timeTypes[i];
            if ([type.guid isEqualToString:typeGuid]) {
                index = i;
                break;
            }
        }
        [self.tableView manuSelectedRowAt:index];
    }
}
- (void) dzTableView:(DZTableView *)tableView didTapAtRow:(NSInteger)row
{
    DZTimeType* type = [_timeTypes objectAtIndex:row];
    [[DZUserDataManager shareManager] setActiveUserData:type.guid forKey:kDZactive_type];
    [DZTimeTrickManger shareManager].timeType = type;
    [[DZNotificationCenter defaultCenter] postMessage:kDZNotification_selectedType userInfo:@{@"type": type}];
}


- (void) handleMessageDidRemoveType:(DZTimeType *)type
{
    [self reloadAllData];
}

- (void) handleMessageDidAddType:(DZTimeType *)type
{
    [self reloadAllData];
}
@end
