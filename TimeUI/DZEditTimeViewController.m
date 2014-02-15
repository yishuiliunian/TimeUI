//
//  DZEditTimeViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-2-15.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZEditTimeViewController.h"
#import "DZEditTimeSegmentView.h"
#import "DZSelectTypeViewController.h"
#import "DZAnalysisManager.h"
#import "DZTime.h"
@interface DZEditTimeViewController () <DZEditTimeSegmentDelegate, DZSelectTypeViewControllerDelegate>
{
    DZEditTimeSegmentView* _editTimeSegementView;
    UIButton* _saveButton;
    
    DZTime* _initialTime;
    
    float _willAddRote;
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

- (void) selectTypeViewController:(DZSelectTypeViewController *)vc didSelectedType:(DZTimeType *)type
{
    [_editTimeSegementView addDivisionLine:_willAddRote withType:type];
}

- (void) editTimeSegmentView:(DZEditTimeSegmentView *)timeView willAddLinewithRote:(float)rote
{
    _willAddRote = rote;
    DZSelectTypeViewController* selectVC = [[DZSelectTypeViewController alloc] init];
    selectVC.typeSelectDelegate = self;
    [self presentViewController:selectVC animated:YES completion:^{
        
    }];
//    [timeView addDivisionLine:rote withType:type];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _editTimeSegementView = [[DZEditTimeSegmentView alloc] initWithTime:_initialTime];
    _editTimeSegementView.delegate = self;
    [self.view addSubview:_editTimeSegementView];
    
	// Do any additional setup after loading the view.
    
    //
    _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_saveButton addTapTarget:self selector:@selector(saveAllTimes)];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:_saveButton];
}

- (void) saveAllTimes
{
    NSArray* allTimes = [_editTimeSegementView getAllEditedTimes];
    id<DZTimeDBInterface> db = DZActiveTimeDataBase;
    for (DZTime* time  in allTimes) {
        [db updateTime:time];
        DZTimeType*  type = [db timeTypByGUID:time.typeGuid];
        [DZShareAnalysisManager triggleAnaylysisWeekWithType:type];
        [DZShareAnalysisManager triggleAnaylysisTimeCostWithType:type];
        [DZShareAnalysisManager triggleAnaylysisTimeCountWithType:type];

    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void) viewWillLayoutSubviews
{
    _editTimeSegementView.frame = CGRectMake(0, 0, CGRectGetViewControllerWidth, CGRectGetViewControllerHeight - 50);
    _saveButton.frame = CGRectMake(0, CGRectGetMaxY(_editTimeSegementView.frame), CGRectGetViewControllerWidth, 40);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
