//
//  DZTypesViewController.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-11.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTypesViewController.h"
#import "DZDBManager.h"
#import "DZTimeType.h"
#import "DZTypeCell.h"
#import "DZMessageContainerView.h"
#import "DZNotificationCenter.h"
#import "DZTestInterface.h"
#import "DZAnalysisManager.h"
#import "DZImageCache.h"
#import <KXKiOSGradients.h>
#import "DZSawtoothView.h"
#import "DZSelecteTypeInterface.h"
#import "DZTimeTrickManger.h"
#import "NSString+WizString.h"
@interface DZTypesViewController () 
@end

@implementation DZTypesViewController
@synthesize selectDelegate = _selectDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) loadViewCSS:(id)cssValue forKey:(NSString *)key
{
    if ([key isEqualToString:@"background"]) {
        self.backgroudView.image =  cssValue;
    }  else if ([key isEqualToString:@"table_gradient"])
    {
        self.tableView.gradientColor = cssValue;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[DZAnalysisManager shareManager] triggleAnaylysisTimeCount];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    _timeTypes = [[DZActiveTimeDataBase allTimeTypes] mutableCopy];
    for (DZTimeType* type  in _timeTypes) {
        [[DZAnalysisManager shareManager] triggleAnaylysisWeekWithType:type];
    }
    DZSawtoothView* tooth = [[DZSawtoothView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    self.tableView.bottomView = tooth;
    tooth.color = [UIColor lightGrayColor];
    [self.tableView reloadData];

    [[DZNotificationCenter defaultCenter] addObserver:self forKey:@"a"];
}

- (CGFloat) dzTableView:(DZTableView *)tableView cellHeightAtRow:(NSInteger)row
{
    return DZTypeCellHeight;
}
- (NSInteger) numberOfRowsInDZTableView:(DZTableView *)tableView
{
    return _timeTypes.count;
}

- (DZTableViewCell*) dzTableView:(DZTableView *)tableView cellAtRow:(NSInteger)row
{
    static NSString* const cellIdentifiy = @"detifail";
    DZTypeCell* cell = (DZTypeCell*)[tableView dequeueDZTalbeViewCellForIdentifiy:cellIdentifiy];
    if (!cell) {
        cell = [[DZTypeCell alloc] initWithIdentifiy:cellIdentifiy];
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.nameLabel.font = [UIFont systemFontOfSize:28];
    }
    DZTimeType* type = [_timeTypes objectAtIndex:row];
    cell.nameLabel.text = type.name;
    cell.countLabel.text = [@([DZShareAnalysisManager numberOfTimeForType:type]) stringValue];
    cell.costLabel.text = [NSString readableTimeStringWithInterval:[DZShareAnalysisManager timeCostOfType:type]];
    cell.backgroundColor = [UIColor clearColor];
    cell.type = type;
    return cell;
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.tableView.topPullDownView.topYOffSet = self.tableView.contentOffset.y ;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.tableView.topPullDownView.state == DZPullDownViewStateToggled) {
        DZInputCellView* inputView = [[DZInputCellView alloc] init];
        inputView.delegate = self;
        [inputView showInView:[UIApplication sharedApplication].keyWindow withAnimation:YES completion:^{
            
        }];
    }
}


- (void) dzInputCellView:(DZInputCellView *)inputView hideWithText:(NSString *)text
{
    DZTimeType* type = [[DZTimeType alloc] initGenGUID];
    type.name = text;
    type.detail = text;
    [DZActiveTimeDataBase updateTimeType:type];
    [_timeTypes insertObject:type atIndex:0];
    [self.tableView insertRowAt:[NSSet setWithObject:@(0)] withAnimation:YES];
}

- (void) dzInputCellViewUserCancel:(DZInputCellView *)inputView
{
    
}

- (void) dzTableView:(DZTableView *)tableView deleteCellAtRow:(NSInteger)row
{
    DZTimeType* type = _timeTypes[row];
    [_timeTypes removeObjectAtIndex:row];
    [self.tableView removeRowAt:row withAnimation:YES];
    NSLog(@"delete row at %d %d", row,     [DZActiveTimeDataBase delteTimeType:type]);
}

- (void) dzTableView:(DZTableView *)tableView editCellDataAtRow:(NSInteger)row
{
    [DZShareAnalysisManager triggleCommand:@""];
}


@end