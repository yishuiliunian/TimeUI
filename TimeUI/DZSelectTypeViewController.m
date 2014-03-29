//
//  DZSelectTypeViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-2-15.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZSelectTypeViewController.h"

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
@end