//
//  DZEditTimeViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-2-15.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZEditTimeViewController.h"
#import "DZEditTimeSegmentView.h"

@interface DZEditTimeViewController ()
{
    DZEditTimeSegmentView* _editTimeSegementView;
    UIButton* _saveButton;
    
    DZTime* _initialTime;
}
@end

@implementation DZEditTimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (instancetype) initWithInitTime:(DZTime *)time
{
    self = [super init];
    if (!self) {
        return self;
    }
    _initialTime = time;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _editTimeSegementView = [[DZEditTimeSegmentView alloc] initWithTime:_initialTime];
    [self.view addSubview:_editTimeSegementView];
    
	// Do any additional setup after loading the view.
}
- (void) viewWillLayoutSubviews
{
    _editTimeSegementView.frame = self.view.bounds;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
