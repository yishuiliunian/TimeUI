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
#import "DZTimeTrickManger.h"
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
}
- (void) editTimeSegmentView:(DZEditTimeSegmentView *)timeView beginEditLine:(DZEditTimeLine *)line
{
    self.pdSuperViewController.pulldownEnable = NO;
}

- (void) editTimeSegmentView:(DZEditTimeSegmentView *)timeView finishEditLine:(DZEditTimeLine *)line
{
    self.pdSuperViewController.pulldownEnable = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (bDEVICE_OSVERSION_EQUAL_OR_LATER7) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    _editTimeSegementView = [[DZEditTimeSegmentView alloc] initWithTime:_initialTime];
    _editTimeSegementView.delegate = self;
    [self.view addSubview:_editTimeSegementView];
    
	// Do any additional setup after loading the view.
    
    //
    
    UIBarButtonItem* iteml = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSave)];
    self.navigationItem.leftBarButtonItem = iteml;
    
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAllTimes)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void) restoreTimeTrickToDate:(NSDate*)date
{
    [[DZTimeTrickManger shareManager] restoreTrickDate:date];
}
- (void) saveAllTimes
{
    NSArray* allTimes = [_editTimeSegementView getAllEditedTimes];
    id<DZTimeDBInterface> db = DZActiveTimeDataBase;
    NSDate* date = nil ;
    for (DZTime* time  in allTimes) {
        [db updateTime:time];
        DZTimeType*  type = [db timeTypByGUID:time.typeGuid];
        [DZShareAnalysisManager triggleAnaylysisWeekWithType:type];
        [DZShareAnalysisManager triggleAnaylysisTimeCostWithType:type];
        [DZShareAnalysisManager triggleAnaylysisTimeCountWithType:type];
        if ( !date || [time.dateEnd laterDate:date]) {
            date = time.dateEnd;
        }
    }
    [DZShareAnalysisManager triggleAnaylysisTimeCost];
    [self dismissModel];
    [self restoreTimeTrickToDate:date];
}

- (void) cancelSave
{
    [self restoreTimeTrickToDate:_initialTime.dateBegin];
    [self dismissModel];
}

- (void) dismissModel
{
    [self.pdSuperViewController pdPopViewControllerAnimated:YES completion:^{
        
    }];
}
- (void) viewWillLayoutSubviews
{
    _editTimeSegementView.frame = CGRectMake(0, 0, CGRectGetViewControllerWidth, CGRectGetViewControllerHeight );
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
