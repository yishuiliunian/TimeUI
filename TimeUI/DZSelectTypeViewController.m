//
//  DZSelectTypeViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-2-15.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZSelectTypeViewController.h"
#import "DZChangedTypesNI.h"
@interface DZSelectTypeViewController ()

@end

@implementation DZSelectTypeViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) dzTableView:(DZTableView *)tableView didTapAtRow:(NSInteger)row
{
    DZTimeType* type = [_timeTypes objectAtIndex:row];

    [self dismissViewControllerAnimated:YES completion:^{
        if ([_typeSelectDelegate respondsToSelector:@selector(selectTypeViewController:didSelectedType:)]) {
            [_typeSelectDelegate selectTypeViewController:self didSelectedType:type];
        }
    }];
}
- (void) didAddTypes:(DZTimeType *)type
{
    NSMutableDictionary* infos = [NSMutableDictionary dictionary];
    if (type) {
        infos[@"type"] = type;
    }
    infos[@"method"] = kDZTypesChangedAdd;
    [DZDefaultNotificationCenter postMessage:kDZNotification_TypesChanged userInfo:infos];
}

- (void) didRemoveTypes:(DZTimeType *)type
{
    NSMutableDictionary* infos = [NSMutableDictionary dictionary];
    if (type) {
        infos[@"type"] = type;
    }
    infos[@"method"] = kDZTypesChangedRemove;
    [DZDefaultNotificationCenter postMessage:kDZNotification_TypesChanged userInfo:infos];
}

@end
