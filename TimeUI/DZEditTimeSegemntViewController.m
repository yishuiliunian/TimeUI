//
//  DZEditTimeSegemntViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-2-14.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZEditTimeSegemntViewController.h"

@interface DZEditTimeSegemntViewController ()

@end

@implementation DZEditTimeSegemntViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView
{
    _editSegmentView = [[DZEditTimeSegmentView alloc] initWithFrame:CGRectLoadViewFrame];
    _editSegmentView.backgroundColor = [UIColor whiteColor];
    self.view = _editSegmentView;
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
